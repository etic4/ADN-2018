#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Une application pour tester différents trucs dans la cadre d'ateliers d'autodéfense numérique.

(-> pour forcer reload par gunicorn...)
"""

from flask import Flask, render_template, request, url_for, redirect
from models import db,Passwords
from emails_users import create_user as create_email_user, list_users
from hashlib import md5

INVIT_CODE = "autonum"

app = Flask(__name__)
app.secret_key = "sKqXljqsfKV35/><&ÀKCw2972"

#
# Exceptions
#

class PasswordDoesntMatchException(Exception): pass

class UserExistsException(Exception): pass

class BadUsernameException(Exception): pass


def add_line_breaks(text):
    return "<br>".join(text.split("\n"))


def create_user(request_form):
    login = request_form["user_name"]

    if "@" in login:
        login = login.split("@")[0].strip()
    
    if not login:
        raise BadUsernameException()

    if request_form["password"] != request_form["password_confirm"]:
        app.logger.info("Les mots de passe ne correspondent pas")
        raise PasswordDoesntMatchException()

    retcode = create_email_user(request_form["user_name"], request_form["password"])

    if retcode == -1:
        message = "L'utilisateur {} existe déjà!".format(request_form["user_name"])
        app.logger.info(message)
        raise UserExistsException(message)
        
    app.logger.info("Utilisateur {} crée".format(request_form["user_name"]))
    
    return

#
# Routes
#
@app.route("/", methods=['GET'])
def index():
    return render_template("adn.tpl")

@app.route("/banc_d_essai", methods=['GET'])
def banc_d_essai():
    return render_template("banc_d_essai.tpl")

@app.route("/zxcvbn", methods=['GET'])
def zxcvbn():
    return render_template("zxcvbn.tpl")

#
# Mots de passe
#
@app.route("/passwords")
def get_passwords():
    passwords = list(Passwords.select())
    passwords.sort(key=lambda r: r.datetime)
    
    return render_template("passwords.tpl", passwords=passwords)


@app.route("/passwords/add", methods=["POST"])
def add_password():
    hashed_password =  md5(request.form["password_clear"].encode("utf-8")).hexdigest()
    password = Passwords.create(password=hashed_password, comment=add_line_breaks(request.form["password_comment"]))
    
    return redirect(url_for("get_passwords"))


@app.route("/passwords/liste_mots")
def passwords_list():
    return render_template("lookup_dict_francais.tpl")


@app.route("/email/creer", methods=["GET", "POST"])
def create_account_form():
    passwords_doesnt_match = False
    user_exists = False
    wrong_invit = False

    if request.method == "POST":
        invit_code = request.form["invitation_code"]

        if invit_code == INVIT_CODE:
            try:
                app.logger.info("Tentative de création d'un nouveau compte")
                create_user(request.form)
                return redirect(url_for("create_account_form"))

            except PasswordDoesntMatchException:
                passwords_doesnt_match=True
                
            except UserExistsException:
                user_exists=True

            except BadUsernameException:
                pass
        else:
            wrong_invit = True

    return render_template("create_account.tpl", user_exists=user_exists, passwords_doesnt_match=passwords_doesnt_match, wrong_invit=wrong_invit, users_list=list_users())


@app.route("/email/client")
def emails_params():
    return render_template("client_email.tpl")


@app.route("/email/gpg")
def gpg():
    return render_template("gpg.tpl")

@app.route("/crypto/apps")
def crypto_apps():
    return render_template("crypto_apps.tpl")

@app.route("/crypto/chiffrer")
def chiffrer():
    return render_template("chiffrer.tpl")


if __name__ == "__main__":
    app.run(port=8080, debug=True)