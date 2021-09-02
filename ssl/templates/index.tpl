    {% extends "base.tpl" %}

    {% block header_title%}
      {% if ssl %}
      <title>Un site en http{S}</title>
      {% else %}
      <title>Un site PAS en http{S}</title>
      {% endif %}
    {% endblock %}

    {% block page_title %}
      <h1>Notes</h1>
      <p class="lead">Une application web de test pour des ateliers d'autodéfense numérique</p>
    {% endblock %}

    {% block main_content%}
    <p>Une petite application de prise de notes, avec des notes "publiques" càd visibles par tous les utilisateurs connectés et des notes "privée" visibles seulement par l'utilisateur qui les a créé.</p>
    <p>L'application va nous permettre de commencer à explorer ce que peuvent signifier "privé" et "public", "données", etc... dans le cadre d'Internet.</p>
    {% if ssl %}
    <p>Ça c'est un site qui est en HTTPS. Les informations qui circulent entre cet ordinateur et la machine qui sert le site (le serveur) sont cryptées.</p>
    {% else %}
    <p>Cette version du site n'est pas en HTTPS. Les informations qui circulent entre cet ordinateur et la machine qui sert le site (le serveur) ne sont pas cryptées. Elles circulent en clair et tout le monde peut les voir. Comme on va le voir...</p>
    {% endif %}

    {% endblock %}
