import sys

step = 3
buf = [0]
pos = 0

for i in range(2017):
    pos = (pos + step) % len(buf) + 1
    buf.insert(pos, i + 1)

print(buf[pos + 1])
