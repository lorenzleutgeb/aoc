import sys

raw = sys.stdin.readline().strip()
lengths = (list(map(int, raw.split(','))))

nums = list(range(0, 256))

current, skip = 0, 0

for l in lengths:
    for i in range(0, int(l / 2)):
        x = (current + i) % len(nums)
        y = (current + l - i - 1) % len(nums)

        tmp = nums[x]
        nums[x] = nums[y]
        nums[y] = tmp

    current = current + l + skip
    skip = skip + 1

print(nums[0] * nums[1])
