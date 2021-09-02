#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import markdown2
from pathlib import Path


files = [
("adn", "ADN"),
("crypto_apps", "Crypto apps"),
("gpg", "Chiffrer avec GPG"),
]


THISDIR = Path(__file__).parent
DIRNAME = "markdown"
TRAGETDIRNAME = "templates"
DIRPATH = THISDIR / DIRNAME
TRAGETDIRPATH = THISDIR / TRAGETDIRNAME


TEMPLATE = """{% extends "base.tpl" %}
{% block header_title %}
<title>{title}</title>
{% endblock %}


{% block page_js_css %}
    
{% endblock %}

{% block page_title %}
<h1>{title}</h1>
{% endblock %}

{% block main_content %}
    {content}
{% endblock %}
"""


for filename, title in files:
    TPL = TEMPLATE
    filepath = os.path.join(DIRPATH, filename + ".mkd")
    destpath = os.path.join(TRAGETDIRPATH, filename + ".tpl")
    
    content = markdown2.markdown_path(filepath)

    TPL = TPL.replace("{title}", title)
    TPL = TPL.replace("{content}", content)
    
    with open(destpath, "w") as f:
        f.write(TPL)