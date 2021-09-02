#!/usr/bin/python3
# -*- coding: utf-8 -*-

from collections import defaultdict

with open("/media/moi/partage/dev/password/mots_francais.txt") as f:
    lst0 = f.read().decode("utf-8").split("\n")

lst1 = [line.split() for line in lst0 if line]
dct1 = defaultdict(float)

for prenom, freq in lst1:
    if not prenom.endswith("'") and len(prenom) > 1:
        dct1[prenom] += float(freq)

lst2 = sorted(dct1.items(), key=lambda item: item[1], reverse=True)

with open("mots_français_ok.txt", "w") as f:
    for prenom, freq in lst2:
        f.write("%s %s\n" % (prenom.encode("utf-8"), freq))
