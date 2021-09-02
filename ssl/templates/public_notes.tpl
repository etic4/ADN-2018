{% extends "base.tpl" %}
{% block header_title %}
<title>Notes publiques</title>
{% endblock %}

{% block page_title %}
<h1 class="sub-header">Notes publiques</h1>
<p class="lead">Les notes ci-dessous sont visibles par tout utilisateur authentifié</p>
{% endblock %}

{% block main_content %}
        <div class="note-form">
          <h3>Ajout d'une note publique</h3>
          <form action='{{ url_for("add_public_note") }}' method="POST">
              <div class="form-part">
                <label for="note_title">Titre</label>
                <input type="text" name="note_title" class="form-control" id="note_title">
              </div>
              <div class="form-part">
                <label for="note_content">Texte</label>
                <textarea class="form-control" name="note_content" id="note_content" rows="2"></textarea>
              </div>
              <button type="submit" class="btn btn-success">Ajouter</button>
            </form>        
        </div>
        {% for note in notes %}
        <div class="note">
          <div class="delete-note"><a href="{{ url_for('delete_note', note_type='public', note_id=note.id) }}"><button class="btn btn-danger btn-sm" type="button">Supprimer</button></a></div>
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