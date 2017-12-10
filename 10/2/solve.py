import sys

raw = sys.stdin.readline().strip()
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

    result = result + hex(block)[2:].rjust(2, '0')

print(result)
