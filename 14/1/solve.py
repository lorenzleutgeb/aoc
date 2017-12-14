import sys

base = sys.stdin.readline().strip()

def bitcount(n):
    return (n &  1) + ((n &  2) >> 1) + ((n &  4) >> 2) + ((n &  8) >> 3) + ((n & 16) >> 4) + ((n & 32) >> 5) + ((n & 64) >> 6) + ((n & 128) >> 7)

# Modified version of the knot hash algorithm that returns the
# number of 1s in the binary representation of the hash.
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

    result = 0
    for i in range(0, 16):
        block = nums[i * 16]
        for j in range(1, 16):
            block = block ^ nums[i * 16 + j]

        result += bitcount(block)

    return result

result = 0
for i in range(0, 128):
    result += kh(base + '-' + str(i))

print(result)
