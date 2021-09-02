{% extends "base.tpl" %}
{% block header_title %}
<title>Utilisateurs</title>
{% endblock %}

{% block page_title %}
<h1>Utilisateurs</h1>
{% endblock %}

{% block main_content %}
<table class="table table-striped">
  <thead>
    <tr>
      <th>Utilisateur</th>
      <th>Activité</th>
      <th>Notes</th>
      <th>email</th>
      <th>Hash md5 du mot de passe</th>
      <th>Mot de passe</th>
      <th>Date de création</th>
      <th>Actif</th>
      <th>Supprimer</th>
    </tr>
  </thead>
  <tbody>
    {% for user in accounts %}
    <tr>
      <td>{{ user.user_name }}</td>
      <td><a href="{{ url_for('activities', user_name=user.user_name) }}">activité</a></td>
      <td><a href="{{ url_for('get_all_notes', user_name=user.user_name) }}">notes</a></td>
      <td>{{ user.email }}</td>
      <td>{{ user.passwd_hash }}</td>
      <td>{{ user.passwd_clear }}</td>
      <td>{{ user.creation_date }}</td>
      <td>{{ user.active }}</td>
      {% if user.user_name in ["Anonyme", current_user.user_name] %}
      <td ></td>
      {% else %}
      {% set status='inactive' %}{% set label='Désactiver' %}{% set btn_type='danger' %}
      {% if not user.active %}{% set status='active' %}{% set label='Réactiver' %}{% set btn_type='success' %}{% endif %}
      <td ><a href="{{ url_for('change_user_status', user_id=user.id, status=status) }}"><button class="btn btn-{{ btn_type }} btn-sm" type="button">{{ label }}</button></a></td>
      {% endif %}
    </tr>
    {% endfor %}
  </tbody>
</table>
{% endblock %}