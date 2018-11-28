import sys

result = 0

for line in sys.stdin:
    [d, r] = map(int, line.split(': '))

    if d % ((r - 1) * 2) == 0:
        result += d * r

print(result)
