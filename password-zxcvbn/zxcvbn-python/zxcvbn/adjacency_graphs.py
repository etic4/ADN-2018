#!/usr/bin/python

import pickle

FILEPATH = "/media/moi/partage/dev/password/zxcvbn-python/zxcvbn/adjacency_graphs.pickle"
with open(FILEPATH, 'rb') as f:
    ADJACENCY_GRAPHS = pickle.loads(f.read())