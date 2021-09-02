{% extends "base.tpl" %}
{% block header_title %}
<title>Préférences</title>
{% endblock %}

{% block page_title %}
<h1>Préférences de {{ current_user.user_name }}</h1>
{% endblock %}

{% block main_content %}
    <form class="apptst-pref-form" action='{{url_for("change_user_prefs")}}' method="POST">
        <div class="checkbox">
          <label>
            <input value="ok" name="is-admin" type="checkbox" {% if current_user.is_admin %}checked{% endif %}> <span class="apptst-checkbox-label">Administrateur</span>
          </label>
        </div>
        <button class="btn btn-success" type="submit">Appliquer</button>
    </form>
{% endblock %}