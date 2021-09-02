{% extends "base.tpl" %}
{% block header_title %}
<title>Activités de l'utilisateur {{ user_name }}</title>
{% endblock %}

{% block page_title %}
<h1>Activités de l'utilisateur {{ user_name }}</h1>
{% endblock %}

{% block main_content %}
<table class="table table-striped">
  <thead>
    <tr>
      <th>Date</th>
      <th>Action</th>
      <th>IP</th>
      <th>Système</th>
      <th>Navigateur</th>
      <th>Version</th>
    </tr>
  </thead>
  <tbody>
    {% for activite in activites %}
    <tr>
      <td>{{ activite.datetime}}</td>
      <td>{{ activite.action }}</td>
      <td>{{ activite.ip_addr}}</td>
      <td>{{ activite.platform}}</td>
      <td>{{ activite.browser}}</td>
      <td>{{ activite.version}}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>
{% endblock %}