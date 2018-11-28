import sys

digits = sys.stdin.readline().strip()

print('#maxint = 10000.')
print('#const n = {}.'.format(len(digits) - 1))

for i, d in enumerate(digits):
    print('dig({},{}).'.format(i, d))
