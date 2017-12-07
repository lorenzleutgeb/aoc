import sys

for line in sys.stdin:
    enc = line.split(' -> ')

    [node, weight] = enc[0].strip().split(' ')
    print('node({}).'.format(node))
    print('weight({},{}).'.format(node, weight[1:-1]))

    if len(enc) < 2:
        continue

    for child in enc[1].strip().split(', '):
        print('parent({},{}).'.format(node, child))
