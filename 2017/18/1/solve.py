import sys

def val(d, k):
    return int(k) if not k.isalpha() else (d[k] if k in d else 0)

code = []
reg = {}
snd = -1
rec = -1
ip = 0

for line in sys.stdin:
    tokens = line.strip().split(' ')

    if len(tokens) < 2:
        tokens.append(None)

    code.append(tuple(tokens))
    reg[tokens[1]] = 0

while ip >= 0 and ip < len(code):
    (op, x, y) = code[ip]

    if op == 'set':
        reg[x] = val(reg, y)
    elif op == 'add':
        reg[x] += val(reg, y)
    elif op == 'mul':
        reg[x] *= val(reg, y)
    elif op == 'mod':
        reg[x] = reg[x] % val(reg, y)
    elif op == 'snd':
        snd = val(reg, x)
    elif op == 'rcv':
        if val(reg, x) != 0:
            rec = snd
            break
    elif op == 'jgz':
        if val(reg, x) > 0:
            ip += val(reg, y)
            continue

    ip += 1

print(rec)
