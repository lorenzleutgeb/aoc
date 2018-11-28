import sys

code = list()
reg = [{}, {}]
total = 0
ip = [0, 0]
active = 0

for line in sys.stdin:
    tokens = line.strip().split(' ')

    op = tokens[0]
    x = tokens[1]
    y = tokens[2] if len(tokens) > 2 else None

    code.append((op, x, y))

    for i in range(len(reg)):
        reg[i][x] = i

def val(d, k):
    return d[k] if k.isalpha() else int(k)

while ip[active] >= 0 and ip[active] < len(code):
    (op, x, y) = code[ip[active]]

    r = reg[active]

    if op == 'snd':
        print('Playing', x)
        snd = val(x)
        total += 1
    elif op == 'set':
        print('Setting', x, 'to', val(y))
        reg[active][x] = val(r, y)
    elif op == 'add':
        reg[active][x] += val(r, y)
    elif op == 'mul':
        reg[active][x] *= val(r, y)
    elif op == 'mod':
        r[x] = r[x] % val(r, y)
    elif op == 'rcv':
        if val(x) != 0:
            rec = snd
            break
    elif op == 'jgz':
        if val(x) > 0:
            ip += int(y)
            continue

    ip += 1

print(rec)
