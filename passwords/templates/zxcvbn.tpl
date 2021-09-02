    {% extends "base.tpl" %}

    {% block header_title%}
      <title>Passwords</title>
    {% endblock %}

    {% block page_title %}
      <h1>zxcvbn</h1>
      <p class="lead">Une mesure beaucoup réaliste</p>
    {% endblock %}

    {% block main_content%}
        <div class="row passwd_input">
          <div class="col-md-3"></div>
          <input id="password_field" class="col-md-6" placeholder="Mot de passe" autofocus="" type="text" oninput="checkPassword()">
          <button onclick="checkPassword()">Check</button>
        </div>
      <p><a href="https://blogs.dropbox.com/tech/2012/04/zxcvbn-realistic-password-strength-estimation/">zxcvbn</a> met en oeuvre la stratégie la plus convaincante à mon sens. L'algorithme essaye d'estimer dans quelle mesure la mot de passe résisterait à une attaque bien menée, qui utiliserait des listes de mots de passe connu et testerait des structures courantes de construction de mots de passe.</p>
      <p>Sa force est aussi, dans une certaine mesure, sa faiblesse. L'algorithme utilise des listes de mots de passes, de mots courants, de prénoms ainsi qu'une carte du clavier pour évaluer la capacité de résistance du mot de passe aux attaques courantes. Ces dictionnaires sont fortement associé à la langue de l'utilisateur. Par défaut, ils sont fournis pour l'anglais, et pour l'anglaise seulement. À ma connaissance, les sites et les applications (<a href="https://bitmask.net/">bitmask</a>, par exemple) qui utilisent l'algorithme ne prennent pas la peine d'adapter les fichiers utilisés à la langue de l'utilisateur (pour peu qu'ils la connaisse), ou bien n'ont pas les ressources pour le faire.</p>
      <p>On peut voir ici que ça fait parfois une différence importante.</p>
        <div class="check-results">
          <div class="row">
            <div class="col-md-6">
              <h3>zxcvbn FR</h3>
              <p class="lead">Dictionnaires et clavier francophones</p>
                <div class="passwapp-progress-container">
                  <div class="progress-bar" role="progressbar" style="width: 0;" id="zxcvbn_fr_be-meter"></div>
                </div>
              <div id="zxcvbn_fr_be-result"></div>
            </div>
            <div class="col-md-6">
              <h3>zxcvbn EN</h3>
              <p class="lead">Dictionnaires et clavier anglophones</p>
                <div class="passwapp-progress-container">
                  <div class="progress-bar" role="progressbar" style="width: 0;" id="zxcvbn-meter"></div>
              <div id="zxcvbn-result"></div>
            </div>
          </div>
        </div>


    {% endblock %}

    {% block scripts %}
    <script src="{{url_for('static', filename='js/mustache.min.js')}}"></script>
    <script src="{{url_for('static', filename='js/zxcvbn_fr_be.js')}}"></script>
    <script src="{{url_for('static', filename='js/zxcvbn.js')}}"></script>


<script type="text/template" id="zxcvbn-template">
  {% raw %}
  <p><strong>Password</strong>: {{ password }}</p>
  <p><strong>Score</strong>: {{ score }}</p>
  <p><strong>Crack times</strong>:</p>
  <ul>
    <li><strong>Offline fast hashing 1e10/s</strong>: {{ crack_times_display.offline_fast_hashing_1e10_per_second }}</li>
    <li><strong>Offline slow hashing 1e4/s</strong>: {{ crack_times_display.offline_slow_hashing_1e4_per_second }}</li>
    <li><strong>Online no throttling 10/s</strong>: {{ crack_times_display.online_no_throttling_10_per_second }}</li>
    <li><strong>Online throttling 100/h</strong>: {{ crack_times_display.online_throttling_100_per_hour }}</li>
  </ul>

<!--   <p><strong>Warning</strong>: {{ feedback.warning }}</p>
  <p><strong>Suggestions</strong>:</p>
  <ul>
    {{ #feedback.suggestions }}
    <li>{{ . }}</li>
    {{ /feedback.suggestions }}
  </ul> -->
  {% endraw %}
</script>

<script type="text/template" id="zxcvbn-pattern-bruteforce">
  {% raw %}
  <div class="passwapp-pattern">
    <h4>Séquence {{ seq_nbr }}</h4>
  <p><strong>Pattern</strong>: {{pattern}}</p>
  <p><strong>Token</strong>: {{token}}</p>
  {% endraw %}
  </div>
</script>

<script type="text/template" id="zxcvbn-pattern-dictionary">
  {% raw %}
  <div class="passwapp-pattern">
    <h4>Séquence {{ seq_nbr }}</h4>
  <p><strong>Pattern</strong>: {{ pattern }}</p>
  <p><strong>Token</strong>: {{ token }}</p>
  <p><strong>Matched word</strong>: {{ matched_word }}</p>
  <p><strong>Dictionnary name</strong>: {{ dictionary_name }}</p>
  <p><strong>Reversed</strong>: {{ reversed }}</p>
  <p><strong>L33t</strong>: {{ l33t }}</p>
  {% endraw %}
  </div>
</script>

<script type="text/template" id="zxcvbn-pattern-date">
  {% raw %}
  <div class="passwapp-pattern">
    <h4>Séquence {{ seq_nbr }}</h4>
  <p><strong>Pattern</strong>: {{ pattern }}</p>
  <p><strong>Token</strong>: {{ token }}</p>
  <p><strong>Separator</strong>: {{ separator }}</p>
  <p><strong>Year</strong>: {{ year }}</p>
  <p><strong>Month</strong>: {{ month }}</p>
  <p><strong>Day</strong>: {{ day }}</p>
  {% endraw %}
  </div>
</script>

<script type="text/template" id="zxcvbn-pattern-repeat">
  {% raw %}
  <div class="passwapp-pattern">
    <h4>Séquence {{ seq_nbr }}</h4>
  <p><strong>Pattern</strong>: {{ pattern }}</p>
  <p><strong>Token</strong>: {{ token }}</p>
  <p><strong>Base token</strong>: {{ base_token }}</p>
  {% endraw %}
  </div>
</script>

<script type="text/template" id="zxcvbn-pattern-regex">
  {% raw %}
  <div class="passwapp-pattern">
    <h4>Séquence {{ seq_nbr }}</h4>
  <p><strong>Pattern</strong>: {{ pattern }}</p>
  <p><strong>Token</strong>: {{ token }}</p>
  <p><strong>Regex name</strong>: {{ regex_name }}</p>
  {% endraw %}
  </div>
</script>

<script type="text/template" id="zxcvbn-pattern-spatial">
  {% raw %}
  <div class="passwapp-pattern">
    <h4>Séquence {{ seq_nbr }}</h4>
  <p><strong>Pattern</strong>: {{ pattern }}</p>
  <p><strong>Token</strong>: {{ token }}</p>
  <p><strong>Graph</strong>: {{ graph }}</p>
  <p><strong>Turns</strong>: {{ turns }}</p>
  <p><strong>Shifted count</strong>: {{ shifted_count }}</p>
  </div>
  {% endraw %}
</script>

<script type="text/template" id="zxcvbn-pattern-sequence">
  {% raw %}
  <div class="passwapp-pattern">
    <h4>Séquence {{ seq_nbr }}</h4>
  <p><strong>Pattern</strong>: {{ pattern }}</p>
  <p><strong>Token</strong>: {{ token }}</p>
  <p><strong>Sequence nbr</strong>: {{ seq_nbr }}</p>
  <p><strong>Sequence name</strong>: {{ sequence_name }}</p>
  <p><strong>Sequence space</strong>: {{ sequence_space }}</p>
  </div>
  {% endraw %}
</script>

<script type="text/javascript">
  function zxvbn_show_results(zxcvbn_result, target_id) {
    update_bar("#" + target_id + "-meter", zxcvbn_result["score"], zxcvbn_result["score"] * 25);
    var rendered = Mustache.render($("#zxcvbn-template").html(), zxcvbn_result);
    $("#" + target_id + "-result").html(rendered);

    var sequence = zxcvbn_result["sequence"];
    for (var i = 0; i < sequence.length; i++) {
        sequence[i]["seq_nbr"] = i + 1;
        var template = $("#zxcvbn-pattern-" + sequence[i]["pattern"]);
        console.log("Sequence name: ", sequence[i]["pattern"]);
        $("#" + target_id + "-result").append(Mustache.render(template.html(), sequence[i]));
    };
  };
  function zxcvbn_fr_be_check(password) {
    var zxcvbn_result = zxcvbn_fr_be(password, user_inputs=[]);
    console.log(zxcvbn_result);
    zxvbn_show_results(zxcvbn_result, "zxcvbn_fr_be");
  };

  function zxcvbn_check(password) {
    var zxcvbn_result = zxcvbn(password, user_inputs=[]);
    console.log(zxcvbn_result);
    zxvbn_show_results(zxcvbn_result, "zxcvbn");
  };

  function checkPassword() {
    var password = $("#password_field").val();
    zxcvbn_fr_be_check(password);
    zxcvbn_check(password);
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