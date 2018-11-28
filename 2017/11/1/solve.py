import sys

x, y = 0, 0

for step in sys.stdin.readline().strip().split(','):
    if step == 'n':
        y = y + 1
    if step == 'ne':
        y = y + 0.5
        x = x + 0.5
    if step == 'nw':
        y = y + 0.5
        x = x - 0.5
    if step == 's':
        y = y - 1
    if step == 'sw':
        y = y - 0.5
        x = x - 0.5
    if step == 'se':
        y = y - 0.5
        x = x + 0.5

print(abs(x) + abs(y))
