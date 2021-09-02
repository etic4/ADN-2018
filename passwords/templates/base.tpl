<!DOCTYPE html>
<html lang="fr"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    {% block header_title%}
    {% endblock %}

    <!-- Bootstrap core CSS -->
    <link href="{{url_for('static', filename='css/bootstrap.min.css')}}" rel="stylesheet">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->

    <link href="{{url_for('static', filename='css/ie10-viewport-bug-workaround.css')}}" rel="stylesheet">

    <!-- Custom styles for this template -->

    <link href="{{url_for('static', filename='css/starter-template.css')}}" rel="stylesheet">

    <link href="{{url_for('static', filename='css/passwapp.css')}}" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    {% block page_js_css %}
    {% endblock %}
  </head>

  <body>

    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="{{ url_for('index') }}">ADN</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav">

          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Sésames <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="{{url_for('banc_d_essai')}}">Banc d'essai</a></li>
              <li><a href="{{url_for('zxcvbn')}}">zxcvbn</a></li>
              <li><a href="{{url_for('passwords_list')}}">Liste de mots</a></li>
            </ul>
          </li>

          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Emails<span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href='{{url_for("create_account_form")}}'>Créer un compte email</a></li>
              <li><a href='{{url_for("emails_params")}}'>Client email</a></li>
              <li><a href='{{url_for("gpg")}}'>Installer et utiliser GPG</a></li>
            </ul>
          </li>

<!--           <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Chiffrer<span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href='{{url_for("crypto_apps")}}'>Crypto apps</a></li>
            </ul>
          </li> -->
          <li><a href='{{url_for("crypto_apps")}}'>Crypto apps</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>



    <div class="container">
      <div class="starter-template">
      {% block page_title%}
        <h1>Titre</h1>
        <p class="lead">Sous-titre</p>
      {% endblock %}
      </div>

      <div class="main-content">
      {% block main_content%}
      {% endblock %}
      </div>

    </div><!-- /.container -->

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="{{url_for('static', filename='js/jquery.js')}}"></script>

    <script src="{{url_for('static', filename='js/bootstrap.min.js')}}"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="{{url_for('static', filename='js/ie10-viewport-bug-workaround.js')}}"></script>
    {% block scripts %}
    {% endblock %}
  
</body>
</html>