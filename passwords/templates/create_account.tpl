{% extends "base.tpl" %}
{% block header_title %}
<title>Créer un compte</title>
{% endblock %}


{% block page_js_css %}
    <link href="{{url_for('static', filename='css/create_account.css')}}" rel="stylesheet">
{% endblock %}

{% block page_title %}
<h1>Créer un compte</h1>
{% endblock %}

{% block main_content %}

<form class="form-create-account" action='{{url_for("create_account_form")}}' method="POST">
      <input type="text" class="form-control" id="user_name" name="user_name" required="" placeholder="Nom d'utilisateur">
      {% if user_exists %}
      <p>L'utilisateur existe déjà!</p>
      {% endif %}
      <input type="password" class="form-control" id="password" name="password" required="" placeholder="Phrase de passe">
      <input type="password" class="form-control" id="password_confirm" name="password_confirm"  required="" placeholder="Confirmer la phrase de passe">
      {% if passwords_doesnt_match %}
      <p>Les phrases de passe ne correspondent pas!</p>
      {% endif %}
      <input type="text" class="form-control" id="invitation_code" name="invitation_code" placeholder="Code d'invitation">
      {% if wrong_invit %}
      <p>Mauvais code d'invitation!</p>
      {% endif %}
    <button class="btn btn-lg btn-primary btn-block" type="submit">Créer un compte</button>
</form>

<div class="users_list">
    <h2>Utilisateurs existants</h2>
    <ol>
    {% for username in users_list %}
    <li>{{ username }}</li>
    {% endfor %}
    </ol>
</div>

{% endblock %}
