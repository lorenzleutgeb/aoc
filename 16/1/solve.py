import sys

p = list(map(lambda x: chr(x + ord('a')), range(0, 16)))

raw = sys.stdin.readline().strip()

for move in raw.split(','):
    if move[0] == 's':
        s = int(move[1:])
        p = p[-s:] + p[:-s]
    else:
        if move[0] == 'x':
            (a, b) = map(int, move[1:].split('/'))
        elif move[0] == 'p':
            (a, b) = map(p.index, move[1:].split('/'))

        p[b], p[a] = p[a], p[b]

print(''.join(p))
