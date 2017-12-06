import sys

digits = map(int, sys.stdin.readline().strip().split('\t'))

states = []

reallocs = 0
while tuple(digits) not in states:
    reallocs = reallocs + 1
    states.append(tuple(digits))

    (mi, mv) = max(enumerate(digits), key=lambda x: x[1])
    (md, mr) = divmod(mv, len(digits))

    digits[mi] = 0

    if md > 0:
        for i in range(len(digits)):
            digits[i] = digits[i] + md

    for i in range(mi + 1, mi + 1 + mr):
        j = i % len(digits)
        digits[j] = digits[j] + 1

for i, state in enumerate(states):
    if state == tuple(digits):
        print(reallocs - i)
        break
