{% extends "base.tpl" %}
{% block header_title %}
<title>Crypto apps</title>
{% endblock %}


{% block page_js_css %}
    
{% endblock %}

{% block page_title %}
<h1>Crypto apps</h1>
{% endblock %}

{% block main_content %}
    <p>On peut crypter un fichier, un dossier, une partition, une image disque.</p>

<p>Il existe différentes applications, c'est très variable selon le système d'exploitation et très inégale en ergonomie.</p>

<p>On ne mentionne ici que des applications open source, à l'exception des systèmes intégrés à Windows et Mac OSx (qui sont propriétaires). D'une manière générale, crypter avec des application propriétaires, càd des applications dont le code source n'est pas rendu publique par ceux qui l'ont conçu et une erreur. </p>

<p>Chiffrer nos communications est très intéressant. Chiffrer nos supports de stockage l'est tout autant, et en particulier le disque dur de notre ordinateur ou la mémoire de notre smartphone. Nous ne le ferons pas aujourd'hui parce que ça requiert une sauvegarde de toutes les données de l'ordinateur, parce que ce avec quoi nous allons crypter doit être choisi soigneusement et bien compris, et parce que ça prend un peu de temps. Si pourtant il y avait une chose à faire, ce serait celle là. En plus de verouiller sa session utilisateur avec un mot de passe.</p>

<h2>Applications Multiplatforme</h2>

<h3>GPG</h3>

<p>GPG permet de crypter (de manière symétrique ou asymétrique) et de signer des données, des emails par exemple. Il n'est pas particulièrement simple à prendre en main ni a utiliser, mais c'est jusqu'ici le standard.</p>

<ul>
<li><a href="https://gnupg.org/">GPG</a> est installé par défaut sur ubuntu, debian, ...</li>
<li><a href="https://www.gpg4win.org/">GPG4Win</a> pour Windows</li>
<li><a href="https://gpgtools.org/">GPG Suite</a> pour Mac</li>
</ul>

<h3>VeraCrypt</h3>

<p><a href="https://www.veracrypt.fr/en/Home.html">Veracrypt</a> permet de créer des partition chiffrées, de chiffrer des clés USB ou des disques dur, tout cela avec la possibilité de nier leur existence de manière plausible.</p>

<h3>7-zip</h3>

<p><a href="https://www.7-zip.org/download.html">7-zip</a> permet de créer des fichier ou des dossiers compressés chiffrés.</p>

<h3>Cryptomator</h3>

<p><a href="https://cryptomator.org/">Cryptomator</a> permet de chiffrer des dossiers, pour stockage dans le cloud. En RAM se trouve une version déchiffrée du dossier qui est chiffrée avant chaque écriture dans le cloud.</p>

<h2>Applications sur Linux</h2>

<ul>
<li>Le "Gestionnaire d'archive" (ou "file-roller") sur Ubuntu/Linux permet de créer des archives chifrées avec 7zip (extensions 7z)</li>
<li><a href="https://mhogomchungu.github.io/zuluCrypt/">zulucrypt</a> permet de chiffrer des partitions et des disques durs</li>
<li><a href="http://ecryptfs.org/">ecryptfs</a>: pour chiffrer des partitions et des dossiers. Avant 18.04 ubuntu l'incluais par défaut pour permettre le chiffrement du dossier utilisateur. Ce n'est plus le cas parce que l'application et moins bien maintenue maintenant qu'avant, et que les développeurs d'Ubuntu considère qu'il est moins sûr de ne chiffrer que le dossier utilisateur.</li>
<li><a href="https://www.cryfs.org/">cryfs</a>: récent</li>
<li><a href="https://nuetzlich.net/gocryptfs/">gocryptfs</a>: récent</li>
<li>Luks</li>
<li><a href="https://vgough.github.io/encfs/">encfs</a>: obsolète?</li>
</ul>

<h2>Applications sur MacOSX</h2>

<ul>
<li><a href="https://www.keka.io/en/">Keka</a> pour Mac permet de créer des archives chifrées avec 7zip (extensions 7z)</li>
<li><a href="https://support.apple.com/fr-fr/HT204837">FileVault</a> pour chiffrer le disque de démarrage (le dossier utilisateur seulement jusqu'à 10.6)</li>
<li>Autre chose digne d'intérêt?</li>
</ul>

<h2>Applications sur Windows</h2>

<ul>
<li><a href="https://www.7-zip.org/">7zip</a> pour Windows permet de créer des archives chifrées avec 7zip (extensions 7z)</li>
<li>Bitlocker (application intégrée à windows) permet de chiffrer le disque dur. Elle n'est disponible que pour les utilisateurs de "Professional" ou "Entreprise". Pour ceux qui ont une édition "Familliale" il y a, paraît-il, "Device Encryption" qui est du même genre mais en moins bien. Le bas peuple qui a l'édition "Home" n'a pas d'option intégrée de chiffrement du disque dur.</li>
<li>Microsoft Office peut chiffrer les documents</li>
<li>Autre chose digne d'intérêt?</li>
</ul>

{% endblock %}
