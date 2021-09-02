{% extends "base.tpl" %}
{% block header_title %}
<title>Toutes les notes de {{ user_name }}</title>
{% endblock %}

{% block page_title %}
<h1 class="sub-header">Les notes privées et publiques de {{ user_name }}</h1>
{% endblock %}

{% block main_content %}
        {% for note in notes %}
          {% set privee = 'note-privee' %}
          {% if note.is_public %}{% set privee = '' %}{% endif %}
        <div class="note {{ privee }}">
          <div class="note-headers">
            <p class="note-user">{{ note.user.user_name }}</p>
            <p>{{ note.creation_date }}</p>
          </div>
          <div class="note-content">
            <h3>{{ note.title }}</h3>
            <p>{{ note.content }}</p>   
          </div>

        </div>
        {% endfor %}
{% endblock %}