import sys

def a():
    x = 65
    while True:
        x = (x * 16807) % 2147483647
        yield x


def b():
    x = 8921
    while True:
        x = (x * 48271) % 2147483647
        yield x

total = 0
for (i, va, vb) in zip(range(0, 40000000), a(), b()):
    if va & 0xFFFF == vb & 0xFFFF:
        total += 1

print(total)
