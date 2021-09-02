{% extends "base.tpl" %}
{% block header_title %}
<title>Client email</title>
{% endblock %}


{% block page_js_css %}
    <link href="{{url_for('static', filename='css/create_account.css')}}" rel="stylesheet">
{% endblock %}

{% block page_title %}
<h1>Client email</h1>
{% endblock %}

{% block main_content %}
<div class="row">
  <h2>Installer Thunderbird et GPG</h2>
  <div class="col-sm-4">
  
  <h3>Installer Thunderbird</h3>
    <p>Sur le <a href="https://www.thunderbird.net/fr/">site de Thunderbird</a></p>
    <p>(depuis ce site: <a href="{{url_for('static', filename='files/thunderbird-52.8.0.amd64.tar.bz2')}}">Linux 64</a>, <a href="{{url_for('static', filename='files/Thunderbird Setup 52.8.0.exe')}}">Windows</a>, <a href="{{url_for('static', filename='files/Thunderbird 52.8.0.dmg')}}">Mac OSX</a>)</p>
  </div>
  <div class="col-sm-4">
    <h3>Installer GPG</h3>
    <p>Pour Linux, c'est déjà installé</p>
    <p>Pour Mac OSX, installer <a href="https://gpgtools.org/">GPG Suite</a> (télécharger <a href="{{url_for('static', filename='files/GPG_Suite-2018.3.dmg')}}">depuis ce site).</a></p>
    <p>Pour Windows, installer <a href="https://www.gpg4win.org/">GPG4Win</a> (télécharger <a href="{{url_for('static', filename='files/gpg4win-3.1.2.exe')}}">depuis ce site).</a></p>
  </div>
  <div class="col-sm-4">
    <h3>Installer Enigmail</h3>
    <p>Site web d'<a href="https://www.enigmail.net/index.php/en/">Enigmail</a></p>
    <p>(télécharger <a href="{{url_for('static', filename='files/enigmail-2.0.7-sm+tb.xpi')}}">depuis ce site</a>)</p>
  </div>
</div>

<div class="row">
  <h2>Configurer Thunderbird</h2>
  <div class="col-sm-4">
    <h3>Serveur entrant (imap)</h3>
    <p><span class="gras">Nom d'hôte du serveur:</span>discuss.r1x.ovh</p>
    <p><span class="gras">port:</span>993</p>
    <p><span class="gras">SSL:</span>SSL/TLS</p>
    <p><span class="gras">Authentification:</span>Mot de passe normal</p>
    <p><span class="gras">Identifiant:</span>{nom_utilisateur}@discuss.r1x.ovh</p>
  </div>
  <div class="col-sm-4">
    <h3>Serveur sortant (smtp)</h3>
    <p><span class="gras">Nom d'hôte du serveur:</span>discuss.r1x.ovh</p>
    <p><span class="gras">port:</span>465</p>
    <p><span class="gras">SSL:</span>SSL/TLS</p>
    <p><span class="gras">Authentification:</span>Mot de passe normal</p>
    <p><span class="gras">Identifiant:</span>{nom_utilisateur}@discuss.r1x.ovh</p>
  </div>
</div>


{% endblock %}
