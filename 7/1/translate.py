import sys

for line in sys.stdin:
    enc = line.split(' -> ')

    node = enc[0].split(' ')[0]
    print('node({}).'.format(node))

    if len(enc) < 2:
        continue

    for child in enc[1].strip().split(', '):
        print('parent({},{}).'.format(node, child))
