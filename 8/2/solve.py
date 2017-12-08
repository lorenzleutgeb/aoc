import sys

values = {}
maxval = 0

for line in sys.stdin:
    [reg, op, chg, _, left, comp, right] = line.strip().split(' ')

    chg = int(chg)

    value = 0 if reg not in values else values[reg]
    left = '0' if left not in values else str(values[left])

    if eval(' '.join([left, comp, right])):
        if op == 'dec':
            chg = chg * -1

        values[reg] = value + int(chg)

        maxval = max(maxval, values[reg])

print(maxval)
