#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""
Une application pour tester différents trucs dans la cadre d'ateliers d'autodéfense numérique.

"""

from flask import (Flask, Response, render_template, request, url_for,
                   redirect, jsonify, make_response, send_file, flash)
from flask_login import (LoginManager, login_required, current_user, login_user,
    logout_user, AnonymousUserMixin)

from models import db, User, Note, Activity, hash_password, IntegrityError

from enum import IntEnum
from functools import wraps


INVIT_CODE = "autonum"
# INVIT_CODE = ""

# flask_login
USE_SESSION_FOR_NEXT = True


app = Flask(__name__)
app.secret_key = "sKqX(d14d2w4,Dq4vZ<mlvw2972"
login_manager = LoginManager()
login_manager.init_app(app)


class Status(IntEnum):
    OK = 1
    USER_CREATED =2
    USER_EXISTS = 3
    PASS_DONT_MATCH = 4

#
# Exceptions
#

class PasswordDoesntMatchException(Exception): pass

class UserExistsException(Exception): pass

#
# Logique
#

def is_ssl(url):
    return url.split("://")[0].endswith("s")


def add_line_breaks(text):
    return "<br>".join(text.split("\n"))

def get_real_ip(request):
    # cf. https://stackoverflow.com/questions/12770950/flask-request-remote-addr-is-wrong-on-webfaction-and-not-showing-real-user-ip#answer-23281516
    return request.access_route[-1]

def log_activity(action):
    if current_user.is_anonymous:
        user_id = 1 # utilisateur anonyme, crée lors de la création des tables
    else:
        user_id = current_user.id
    try:
        activity = Activity.create(user=user_id, action=action, ip_addr=get_real_ip(request), user_agent=request.headers["user_agent"], platform=request.user_agent.platform, browser=request.user_agent.browser, version=request.user_agent.version)
    except Exception as e:
        app.logger.debug("Problème lors de la création d'une Activity:")
        app.logger.debug(e)


def create_user(request_form):
    if request_form["password"] != request_form["password_confirm"]:
        log_activity("Les mots de passe ne correspondent pas")
        raise PasswordDoesntMatchException()

    with db.transaction():
        try:
            password_encoded = request_form["password"].encode("utf-8")
            user = User.create(user_name=request_form["user_name"], email=request_form["email"], passwd_hash=hash_password(password_encoded), passwd_clear=request_form["password"])
            log_activity("Utilisateur {} crée".format(request_form["user_name"]))
            return user
        except IntegrityError:
            log_activity("L'utilisateur {} existe déjà".format(request_form["user_name"]))
            raise UserExistsException()

        except Exception as e:
            log_activity("Erreur lors de l'écriture en db")
            log_activity("{}".format(e))


def log_access(func):
    """Log comme Activity l'accès à l'url"""
    @wraps(func)
    def decorated_function(*args, **kwargs):
        log_activity(request.path)
        return func(*args, **kwargs)
    return decorated_function

#
# Routes
#

@app.route("/", methods=['GET'])
@log_access
def index_page():
    return render_template("index.tpl", ssl=is_ssl(request.url))


@app.route("/connexion", methods=["GET", "POST"])
@app.route("/connexion/<int:status>", methods=["GET", "POST"])
@log_access
def login_form(status=int(Status.OK)):
    if request.method == "POST":
        try:
            user = User.get(User.user_name == request.form["user_name"])
            if user.active:
                if not user.is_password_good(request.form["password"]):
                    log_activity("Les mots de passe ne correspondent pas!")
                else:
                    login_user(user)
                    log_activity("Utilisateur {} connecté".format(user.user_name))

                    return redirect(url_for("index_page"))

        except User.DoesNotExist:
            pass

        log_activity("La connexion a échoué")

    return render_template("login.tpl", status=status, ssl=is_ssl(request.url))


@app.route("/deconnexion")
@login_required
@log_access
def logout():
    logout_user()

    return redirect(url_for("index_page"))


@app.route("/creer_compte", methods=["GET", "POST"])
@log_access
def create_account_form():
    passwords_doesnt_match = False
    user_exists = False
    if request.method == "POST":
        invit_code = request.form["invitation_code"]

        passwords_doesnt_match = False
        user_exists = False

        #if invit_code == INVIT_CODE:
        if True:
            try:
                app.logger.info("Tentative de création d'un nouveau compte")
                create_user(request.form)
                return redirect(url_for("login_form", status=int(Status.USER_CREATED)))

            except PasswordDoesntMatchException:
                passwords_doesnt_match=True
                
            except UserExistsException:
                user_exists=True

    return render_template("create_account.tpl", user_exists=False, passwords_doesnt_match=False, ssl=is_ssl(request.url))


@app.route("/utilisateur/<user_id>/<status>")
@login_required
@log_access
def change_user_status(user_id, status):
    log_activity("Tentative de désactivation de l'utilisateur {}".format(user_id))
    try:
        user = User.get(User.id == user_id)
        user.active = True if status == "active" else False
        user.save()
        log_activity("L'utilisateur {} est maintenant 'inactif'".format(user.user_name))
    except IntegrityError:
        log_activity("Pas parvenu à désactiver l'utilisateurs {}".format(user_id))
        pass

    return redirect(url_for("user_list"))


@app.route("/utilisateurs")
@login_required
@log_access
def user_list():
    accounts = list(User.select())

    return render_template("user-list.tpl", accounts=accounts, ssl=is_ssl(request.url))


# @app.route("/moi/change_prefs", methods=["GET", "POST"])
@app.route("/admin", methods=["GET", "POST"])
@login_required
@log_access
def change_user_prefs():
    if request.method == "POST":
        is_admin = request.form.get("is-admin") != None
        current_user.is_admin = is_admin
        current_user.save()
        
    return render_template("user-prefs.tpl")

@app.route("/utilisateurs/activite/<user_name>")
@login_required
@log_access
def activities(user_name):
    activites = list(Activity.select().join(User).where(User.user_name == user_name))
    activites.sort(key=lambda r: r.datetime, reverse=True)

    return render_template("activites.tpl", user_name=user_name, activites=activites)


@app.route("/notes")
@login_required
@log_access
def get_notes():
    notes = list(Note.select().where(Note.is_public == True))
    notes.sort(key=lambda r: r.creation_date, reverse=True)
    
    return render_template("public_notes.tpl", notes=notes, ssl=is_ssl(request.url))


@app.route("/notes/add", methods=["POST"])
@login_required
@log_access
def add_public_note():
    note = Note.create(user=current_user.id, title=request.form["note_title"] ,content=add_line_breaks(request.form["note_content"]) , is_public=True)
    log_activity("Note publique créé.\nTitre: {}\nTexte: {}".format(request.form["note_title"], request.form["note_content"]))
    
    return redirect(url_for("get_notes"))


@app.route("/moi/notes")
@login_required
@log_access
def get_private_notes():
    notes = list(Note.select()
        .join(User)
        .where((User.id == current_user.id) & (Note.is_public == False)))
    notes.sort(key=lambda r: r.creation_date, reverse=True)
    
    return render_template("private_notes.tpl", notes=notes, ssl=is_ssl(request.url))


@app.route("/moi/notes/ajouter", methods=["POST"])
@login_required
@log_access
def add_private_note():
    note = Note.create(user=current_user.id, title=request.form["note_title"] ,content=add_line_breaks(request.form["note_content"]))
    log_activity("Note privée créé.\nTitre: {}\nTexte: {}".format(request.form["note_title"], request.form["note_content"]))
    
    return redirect(url_for("get_private_notes"))


@app.route("/notes/supprimer/<note_type>/<int:note_id>")
@login_required
@log_access
def delete_note(note_type, note_id):
    note = Note.get(Note.id == note_id)
    note.delete_instance()
    log_activity("Note supprimée.\nCréateur: {}\nTitre: {}\nTexte: {}".format(note.user.user_name, note.title, note.content))
    if note_type == "private":
        redirect_url = url_for("get_private_notes")
    else:
        redirect_url = url_for("get_notes")

    return redirect(redirect_url)


@app.route("/admin/notes/<user_name>")
@login_required
@log_access
def get_all_notes(user_name):
    notes = list(Note.select()
        .join(User)
        .where(User.user_name == user_name))
    notes.sort(key=lambda r: r.creation_date, reverse=True)
    
    return render_template("all_notes.tpl", user_name=user_name, notes=notes, ssl=is_ssl(request.url))

#
# Flask helpers
#

@login_manager.user_loader
def load_user(user_id):
    try:
        return User.get(User.id == str(user_id))
    except User.DoesNotExist:
        return None
        # logout_user()
        # log_activity("Utilisateur {} pas trouvé".format(user_id))


@login_manager.unauthorized_handler
def if_unauthorized():    
    return redirect(url_for("login_form"))


if __name__ == "__main__":
    app.run(port=8080, debug=True)