import sys

cells = []

for i, row in enumerate(sys.stdin):
    if row.strip() is '':
        break

    cells.append(int(row.strip()))

p, s = 0, 0

while p >= 0 and p < len(cells):
    s = s + 1

    tmp = cells[p]
    cells[p] = cells[p] + 1
    p = p + tmp

print(s)
