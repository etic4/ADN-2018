#!/usr/bin/python3

from zxcvbn import zxcvbn
from pprint import PrettyPrinter

results = zxcvbn("""lés/bonjour/gars^""", user_inputs=['etienne'])

pp = PrettyPrinter(indent=4)
pp.pprint(results)
