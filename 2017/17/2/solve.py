import sys

step = 3
pos = 0
result = -1

for i in range(50000000):
    pos = ((pos + step) % (i + 1)) + 1

    if pos == 1:
        result = (i + 1)

print(result)
