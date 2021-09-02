{% extends "base.tpl" %}

{% block header_title %}
<title>Haché</title>
<p class="lead">Veuillez vous authentifier</p>
{% else %}
<h1>Login</h1>
{% endif %}
{% endblock %}

{% block main_content %}
      <form class="form-signin" action='{{url_for("login_form")}}' method="POST">
        <label for="user_name" class="sr-only">Nom d'utilisateur</label>
        <input id="user_name" name="user_name" class="form-control" placeholder="Nom d'utilisateur" required="" autofocus="" type="text">
        <label for="inputPassword" class="sr-only">Phrase de passe</label>
        <input id="inputPassword" name="password" class="form-control" placeholder="Password" required="" type="password">
<!--         <div class="checkbox">
          <label>
            <input value="remember-me" name="remember-me" type="checkbox"> Se souvenir de moi
          </label>
        </div> -->
        <div>
          <a href='{{url_for("create_account_form")}}'>Créer un compte</a>
        </div>
        <button class="btn btn-lg btn-primary btn-block" type="submit">Ok</button>
      </form>
{% endblock %}