#!/usr/bin/python3

import sys
import pickle

qwerty = r'''
`~ 1! 2@ 3# 4$ 5% 6^ 7& 8* 9( 0) -_ =+
    qQ wW eE rR tT yY uU iI oO pP [{ ]} \|
     aA sS dD fF gG hH jJ kK lL ;: '"
      zZ xX cC vV bB nN mM ,< .> /?
'''

azerty_be = r'''
²³ &1 é2 "3 '4 (5 §6 è7 !8 ç9 à0 )° -_
    aA zZ eE rR tT yY uU iI oO pP ^¨ $*
     qQ sS dD fF gG hH jJ kK lL mM ù% µ£
   <> wW xX cC vV bB nN ,? ;. :/ =+
'''

keypad = r'''
  / * -
7 8 9 +
4 5 6
1 2 3
  0 .
'''

mac_keypad = r'''
  = / *
7 8 9 -
4 5 6 +
1 2 3
  0 .
'''

def get_slanted_adjacent_coords(x, y):
    '''
    returns the six adjacent coordinates on a standard keyboard, where each row is slanted to the
    right from the last. adjacencies are clockwise, starting with key to the left, then two keys
    above, then right key, then two keys below. (that is, only near-diagonal keys are adjacent,
    so g's coordinate is adjacent to those of t,y,b,v, but not those of r,u,n,c.)
    '''
    return [(x - 1, y), (x, y - 1), (x + 1, y - 1), (x + 1, y), (x, y + 1), (x - 1, y + 1)]


def get_aligned_adjacent_coords(x, y):
    '''
    returns the nine clockwise adjacent coordinates on a keypad, where each row is vert aligned.
    '''
    return [(x - 1, y), (x - 1, y - 1), (x, y - 1), (x + 1, y - 1), (x + 1, y), (x + 1, y + 1), (x, y + 1),
            (x - 1, y + 1)]


def build_graph(layout_str, slanted):
    '''
    builds an adjacency graph as a dictionary: {character: [adjacent_characters]}.
    adjacent characters occur in a clockwise order.
    for example:
    * on qwerty layout, 'g' maps to ['fF', 'tT', 'yY', 'hH', 'bB', 'vV']
    * on keypad layout, '7' maps to [None, None, None, '=', '8', '5', '4', None]
    '''
    position_table = {}  # maps from tuple (x,y) -> characters at that position.
    tokens = layout_str.split()
    token_size = len(tokens[0])
    x_unit = token_size + 1  # x position unit len is token len plus 1 for the following whitespace.
    adjacency_func = get_slanted_adjacent_coords if slanted else get_aligned_adjacent_coords
    assert all(len(token) == token_size for token in tokens), 'token len mismatch:\n ' + layout_str
    for y, line in enumerate(layout_str.split('\n')):
        # the way I illustrated keys above, each qwerty row is indented one space in from the last
        slant = y - 1 if slanted else 0
        for token in line.split():
            x, remainder = divmod(line.index(token) - slant, x_unit)
            assert remainder == 0, 'unexpected x offset for %s in:\n%s' % (token, layout_str)
            position_table[(x, y)] = token

    adjacency_graph = {}
    for (x, y), chars in position_table.items():
        for char in chars:
            adjacency_graph[char] = []
            for coord in adjacency_func(x, y):
                # position in the list indicates direction
                # (for qwerty, 0 is left, 1 is top, 2 is top right, ...)
                # for edge chars like 1 or m, insert None as a placeholder when needed
                # so that each character in the graph has a same-length adjacency list.
                adjacency_graph[char].append(position_table.get(coord, None))
    return adjacency_graph


if __name__ == '__main__':
    FILEPATH = "/media/moi/partage/dev/password/zxcvbn-python/zxcvbn/adjacency_graphs.pickle"
    ADJACENCY_GRAPHS = {}

    for graph_name, args in [('qwerty', (qwerty, True)),
                             ('azerty_be', (azerty_be, True)),
                             ('keypad', (keypad, False)),
                             ('mac_keypad', (mac_keypad, False))]:
        graph = build_graph(*args)
        ADJACENCY_GRAPHS[graph_name] = graph

    with open(FILEPATH, 'wb') as f:
        f.write(pickle.dumps(ADJACENCY_GRAPHS, pickle.HIGHEST_PROTOCOL))

    with open(FILEPATH, 'rb') as f:
        ADJACENCY_GRAPHS_SAV = pickle.loads(f.read())

    print(ADJACENCY_GRAPHS_SAV)
