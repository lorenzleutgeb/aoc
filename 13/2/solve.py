import sys

raw = []

for line in sys.stdin:
    raw.append(tuple(map(int, line.split(': '))))

t = 0

while True:
    caught = False
    for it in raw:
        (d, r) = it

        if (d + t) % ((r - 1) * 2) == 0:
            caught = True
            break

    if not caught:
        break

    t = t + 1

print(t)
