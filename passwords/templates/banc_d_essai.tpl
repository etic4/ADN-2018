    {% extends "base.tpl" %}

    {% block header_title%}
      <title>Passwords</title>
    {% endblock %}

    {% block page_title %}
      <h1>Est-il solide?</h1>
      <p class="lead">Entrez un mot de passe</p>
    {% endblock %}

    {% block main_content%}
        <div class="row passwd_input">
          <div class="col-md-3"></div>
          <input id="password_field" class="col-md-6" placeholder="Mot de passe" autofocus="" type="text" oninput="checkPassword()">
          <button onclick="checkPassword()">Check</button>
        </div>
        <div>
          <p>Entrez un mote de passe. Quatre mesure différentes de sa force seront données, basées sur des principes ou des ressources différentes. La première mesure ('zxcvbn') est la plus réaliste. Elle s'appuie sur une bonne connaissance de la manière dont les mots de passes sont attaqués. Les trois mesures suivantes sont grosso modo basées sur le même principe de combinaison de règles: des mots de passe suffisamments longs qui mixent tous les types de caractères. Leurs résultats sont significativement différents.</p>
        </div>
        <div class="check-results">
          <div class="row">
            <div class="col-md-6">
              <h3>zxcvbn FR</h3>
                <div class="passwapp-progress-container">
                  <div class="progress-bar" role="progressbar progress-bar-danger" style="width: 5;" id="zxcvbn_fr_be-meter"></div>
                </div>
              <div id="zxcvbn_fr_be-result"></div>
              <div><a href="https://blogs.dropbox.com/tech/2012/04/zxcvbn-realistic-password-strength-estimation/">Site</a></div>
            </div>
            <div class="col-md-6">
              <h3>Kartik strength meter</h3>
                <div class="passwapp-progress-container">
                  <div class="progress-bar" role="progressbar progress-bar-danger" style="width: 5;" id="kartik-meter"></div>
              <div id="kartik-result"></div>
              <div><a href="https://github.com/kartik-v/strength-meter/blob/master/README.md">Site</a></div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-6">
            <h3>fnando PasswordStrength</h3>
              <div class="passwapp-progress-container">
                <div class="progress-bar" role="progressbar progress-bar-danger" style="width: 5;" id="fnando-meter"></div>
                <div id="fnando-result"></div>
                <div><a href="https://github.com/fnando/password_strength/blob/master/README.md">Site</a></div>
              </div>
          </div>
          <div class="col-md-6">
            <h3>formget Password Strength Checker</h3>
              <div class="passwapp-progress-container">
                <div class="progress-bar" role="progressbar progress-bar-danger" style="width: 5;" id="formget-meter"></div>
                <div id="formget-result"></div>
                <div><a href="https://www.formget.com/password-strength-checker-in-jquery/">Site</a></div>
              </div>
          </div>
        </div>
      </div>


    {% endblock %}

    {% block scripts %}
    <script src="{{url_for('static', filename='js/mustache.min.js')}}"></script>
    <script src="{{url_for('static', filename='js/zxcvbn_fr_be.js')}}"></script>
    <script src="{{url_for('static', filename='js/kartik_strength_meter.js')}}"></script>
    <script src="{{url_for('static', filename='js/fnandoPS.js')}}"></script>
    <script src="{{url_for('static', filename='js/formget_checkStrength.js')}}"></script>
    
    
<!-- Templates mustache -->

<script type="text/template" id="zxcvbn-template">
  {% raw %}
  <p><strong>Password</strong>: {{ password }}</p>
  <p><strong>Score (0 - 4)</strong>: {{ score }}</p>
  <p><strong>Crack time minimum: </strong>{{ crack_times_display.offline_fast_hashing_1e10_per_second }}</p>
  <p><strong>Crack time maximum: </strong>{{ crack_times_display.online_throttling_100_per_hour }}</p>
  {% endraw %}
</script>

<script type="text/template" id="kartik-template">
  {% raw %}
  <p><strong>Password</strong>: {{ password }}</p>
  <p><strong>Score (0 - 5)</strong>: {{ score }}</p>
  <p><strong>Verdict: </strong>{{ verdict }}</p>
  {% endraw %}
</script>

<script type="text/template" id="fnando-template">
  {% raw %}
  <p><strong>Password</strong>: {{ password }}</p>
  <p><strong>Status</strong>: {{ status }}</p>
  <p><strong>Score (0 - 100)</strong>: {{ score }}</p>
  {% endraw %}
</script>

<script type="text/template" id="formget-template">
  {% raw %}
  <p><strong>Password</strong>: {{ password }}</p>
  <p><strong>Comment</strong>: {{ comment }}</p>
  <p><strong>Score (0 - 5)</strong>: {{ score }}</p>
  
  {% endraw %}
</script>

<script type="text/javascript">
  function zxvbn_show_results(zxcvbn_result, target_id) {
    update_bar("#" + target_id + "-meter", zxcvbn_result["score"], zxcvbn_result["score"] * 25);
    var rendered = Mustache.render($("#zxcvbn-template").html(), zxcvbn_result);
    $("#" + target_id + "-result").html(rendered);
  };

  function zxcvbn_fr_be_check(password) {
    var zxcvbn_result = zxcvbn_fr_be(password, user_inputs=[]);
    update_bar("#zxcvbn_fr_be-meter", zxcvbn_result["score"], zxcvbn_result["score"] * 25);
    var rendered = Mustache.render($("#zxcvbn-template").html(), zxcvbn_result);
    $("#zxcvbn_fr_be-result").html(rendered);
  };

  function kartik_check(password){
    var kartik_result = Strength.getStrength(password);
    update_bar("#kartik-meter", kartik_result["score"],  kartik_result["percent"]);
    var rendered = Mustache.render($("#kartik-template").html(), kartik_result);
    $("#kartik-result").html(rendered);
  };
  function fnandoPS(password) {
    var fnandoPS_result = PasswordStrength.test("", password);
    console.log(fnandoPS_result);
    var score ;
    var percent = fnandoPS_result["score"];
    var status = fnandoPS_result["status"];
    switch (status) {
      case "weak":
        score = 0;
        break;
      case "good":
        score = 3;
        break;
      case "strong":
        score = 4;
        break;
    };
    update_bar("#fnando-meter", score, percent);
    var rendered = Mustache.render($("#fnando-template").html(), fnandoPS_result);
    $("#fnando-result").html(rendered);
  };

  function formget_check(password) {
    var formget_result = formget_checkStrength(password);
    console.log(formget_result);
    update_bar("#formget-meter", formget_result["score"], formget_result["score"] * 20);
    var rendered = Mustache.render($("#formget-template").html(), formget_result);
    $("#formget-result").html(rendered);
  };


  function checkPassword() {
    var password = $("#password_field").val();
    zxcvbn_fr_be_check(password);
    kartik_check(password);
    fnandoPS(password);
    formget_check(password);
    
  };

  function update_bar(bar_id, score, percent) {
    if (percent === 0){
      percent = 5;
    };
    var bar_size = percent + '%';
    var $bar = $(bar_id);
    switch (score) {
        case 0:
            $bar.attr('class', 'progress-bar progress-bar-danger')
                .css('width', bar_size);
            break;
        case 1:
            $bar.attr('class', 'progress-bar progress-bar-danger')
                .css('width', bar_size);
            break;
        case 2:
            $bar.attr('class', 'progress-bar progress-bar-warning')
                .css('width', bar_size);
            break;
        case 3:
            $bar.attr('class', 'progress-bar progress-bar-info')
                .css('width', bar_size);
            break;
        case 4:
            $bar.attr('class', 'progress-bar progress-bar-success')
                .css('width', '100%');
            break;
    }
  };

</script>
    {% endblock %}