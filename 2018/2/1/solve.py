import sys

twos, threes = 0, 0

for line in sys.stdin:
    cnt = {}
    for x in line.strip():
        if x in cnt:
            cnt[x] = cnt[x] + 1
        else:
            cnt[x] = 1

    x2, x3 = False, False
    for k, v in cnt.items():
        if v == 2:
            x2 = True
        if v == 3:
            x3 = True

    twos = twos + x2
    threes = threes + x3

print(twos * threes)
