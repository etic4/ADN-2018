{% extends "base.tpl" %}
{% block header_title %}
<title>Chiffrer avec GPG</title>
{% endblock %}


{% block page_js_css %}
    
{% endblock %}

{% block page_title %}
<h1>Chiffrer avec GPG</h1>
{% endblock %}

{% block main_content %}
    <p>Dans l'ordre:</p>

<ul>
<li>Installation de Thunderbird (cf <a href="https://pass.r1x.ovh/email/client">test</a>)</li>
<li>création d'un compte email et paramétrage thunderbird</li>
<li>Echange d'emails non cryptés</li>
<li>Installation de GPG</li>
<li>Installation d'Enigmail</li>
<li>Le cas échéant, ajout d'une nouvelle paire de clés (Enigmail/Gestion des clés/Générer)</li>
<li>Création de clés publiques et privées</li>
<li>Échange de mails cryptés</li>
</ul>

{% endblock %}
