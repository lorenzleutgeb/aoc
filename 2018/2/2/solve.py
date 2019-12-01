import sys

def match(s1, s2):
    pos = -1

    for i, (c1, c2) in enumerate(zip(s1, s2)):
        if c1 != c2:
            if pos != -1:
                return -1
            else:
                pos = i

    return pos

words = []

for line in sys.stdin:
    words.append(line[:-1])

for a in words:
    for b in words:
        if a == b:
            continue
        x = match(a, b)
        if x != -1:
            print(a[:x] + a[x+1:])
            break
