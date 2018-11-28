import sys

base = sys.stdin.readline().strip()

# Modified version of the knot hash algorithm that returns
# a binary encoding of the result.
def kh(raw):
    lengths = (list(map(ord, raw))) + [17, 31, 73, 47, 23]

    nums = list(range(0, 256))

    current, skip = 0, 0

    for i in range(0, 64):
        for l in lengths:
            for j in range(0, int(l / 2)):
                x = (current + j) % len(nums)
                y = (current + l - j - 1) % len(nums)

                tmp = nums[x]
                nums[x] = nums[y]
                nums[y] = tmp

            current = current + l + skip
            skip = skip + 1

    result = ''

    for i in range(0, 16):
        block = nums[i * 16]
        for j in range(1, 16):
            block = block ^ nums[i * 16 + j]

        result += bin(block)[2:].rjust(8, '0')

    return result

s = ''
for i in range(0, 128):
    s += kh(base + '-' + str(i))

result = 0

representatives = {i: i for i, c in enumerate(s) if c == '1'}

def neighbours(x):
    i, j = divmod(x, 128)
    if i > 0:   yield x - 128
    if i < 127: yield x + 128
    if j > 0:   yield x - 1
    if j < 127: yield x + 1

def representative(a):
    while representatives[a] != a: a = representatives[a]
    return a

def join(a, b):
    ra, rb = representative(a), representative(b)
    if ra != rb:
        representatives[ra] = rb

for i in representatives:
    for n in neighbours(i):
        if s[n] == '1': join(i, n)

print(len(set(map(representative, representatives))))
