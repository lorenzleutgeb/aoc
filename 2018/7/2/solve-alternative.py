import sys

lines = [l.split() for l in sys.stdin]
lines = [(l[1], l[7]) for l in lines]

steps = set([s[0] for s in lines] + [s[1] for s in lines])

def time(c):
    return 60 + ord(c) - ord('A')

def next_step(steps, l):
    return [s for s in steps if all(b != s for (_, b) in l)]

t = 0
workers = [0 for _ in range(5)]
work = [None for _ in range(5)]
while steps or any(w > 0 for w in workers):
    cand = list(next_step(steps, lines))
    cand.sort()
    cand = cand[::-1]

    for i in range(5):
        workers[i] = max(workers[i] - 1, 0)
        if workers[i] == 0:
            if work[i] is not None:
                lines = [(a, b) for (a, b) in lines if a != work[i]]
            if cand:
                n = cand.pop()
                workers[i] = time(n)
                work[i] = n
                steps.remove(n)

    t += 1

print(t)
