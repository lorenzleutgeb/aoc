import sys

for line in sys.stdin:
    [node, neighbors] = line.split(' <-> ')
    print('node({}).'.format(node))

    for child in neighbors.strip().split(', '):
        print('edge({},{}).'.format(node, child))
