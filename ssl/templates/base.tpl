<!DOCTYPE html>
<html lang="fr"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    {% block header_title%}
    {% endblock %}

    <!-- Bootstrap core CSS -->
    <link href="{{url_for('static', filename='css/bootstrap.css')}}" rel="stylesheet">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->

    <link href="{{url_for('static', filename='css/ie10-viewport-bug-workaround.css')}}" rel="stylesheet">

    <!-- Custom styles for this template -->

    <link href="{{url_for('static', filename='css/starter-template.css')}}" rel="stylesheet">

    <link href="{{url_for('static', filename='css/apptst.css')}}" rel="stylesheet">

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
          <a class="navbar-brand" href="{{ url_for('index_page') }}">Notes</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            {% if not current_user.is_authenticated %}
            <li><a href='{{url_for("create_account_form")}}'>Créer un compte</a></li>
            <li><a href="{{ url_for('login_form') }}">Login</a></li>
            {% else %}
            <li><a href="{{ url_for('get_notes') }}">Notes publiques</a></li>
            {% if current_user.is_admin %}
            <li><a href="{{ url_for('user_list') }}">Utilisateurs</a></li>
            {% endif %}
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">{{ current_user.user_name }} <span class="caret"></span></a>
              <ul class="dropdown-menu inverse-dropdown">
                <li><a href="{{ url_for('get_private_notes') }}">Notes privées</a></li>
                <!-- <li><a href="{{url_for('change_user_prefs')}}">Préférences</a></li> -->
                <li><a href="{{ url_for('logout') }}">Logout</a></li>
              </ul>
            </li>
            {% endif %}
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

    <script type="text/javascript">console.log("test: " + document.cookie);</script>
    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="{{url_for('static', filename='js/jquery.js')}}"></script>

    <script src="{{url_for('static', filename='js/bootstrap.js')}}"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="{{url_for('static', filename='js/ie10-viewport-bug-workaround.js')}}"></script>
    {% block scripts %}
    {% endblock %}
  
</body>
</html>