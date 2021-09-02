{% extends "base.tpl" %}
{% block header_title %}
<title>Solidité des mots et phrases de passe</title>
{% endblock %}

{% block page_title %}
<h1 class="sub-header">Solidité des mots et phrases de passe</h1>
{% endblock %}

{% block main_content %}
        <div class="text-content">
          <p>Entrez des mots de passe et évaluez chaque fois, dans le champs 'commentaire', si c'est selon vous un bon ou un mauvais mot de passe et s'il est pratique ou non à utiliser. Le mot de passe sera 'crypté' avec un algorithme faible (md5) et stocké dans une base de données. Les mots de passe proposés seront mis à l'épreuve et nous verrons la prochaine fois s'ils auront résisté à une attaque résolue.</p>
        </div>
        <div class="password-form">
          <h3>Ajout d'un mot de passe</h3>
          <form action='{{ url_for("add_password") }}' method="POST">
              <div class="form-part">
                <label for="password_clear">Mot de passe</label>
                <input type="text" name="password_clear" class="form-control" id="password_clear">
              </div>
              <div class="form-part">
                <label for="password_comment">Commentaire</label>
                <textarea type="text" name="password_comment" class="form-control" id="password_comment" rows="2"></textarea>
              </div>
              <button type="submit" class="btn btn-success">Ajouter</button>
            </form>        
        </div>
        <div class="passwords-list">
          <h3>Les mots et phrases de passe proposés</h3>
          {% for password in passwords %}
          <div class="password-hashed">
            <div class="hashed-password"><span class="badge badge-primary">{{password.id}}</span><span>{{password.password}}</span> --> <span class="clear-passw">{{ password.clear_passw }}</span></div>
            <div class="text-comment">{{password.comment}}</div>
          </div>
        
        {% endfor %}
      </div>
{% endblock %}