import sys

nums = []
for i, row in enumerate(sys.stdin):
    nums.append(int(row))

seen = set()
sux = 0
while True:
    for i in nums:
        sux = sux + i
        if sux in seen:
            print(sux)
            seen.clear()
            break
        else:
            seen.add(sux)
