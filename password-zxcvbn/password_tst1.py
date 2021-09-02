#!/usr/bin/python3

from zxcvbn import zxcvbn
from pprint import PrettyPrinter

# ICI UTILISE LA VERSION SYSTEME, python3-zxcvbn, orienté anglais-us
results = zxcvbn("""salutlesamis""", user_inputs=['archi'])

pp = PrettyPrinter(indent=4)
pp.pprint(results)
