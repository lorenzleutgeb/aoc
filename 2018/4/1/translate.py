import sys

from operator import itemgetter
from dateutil.parser import parse

sleeps = {}
events = []

for i, ln in enumerate(sys.stdin):
    print(ln[1:17])
    stamp = parse(ln[1:17])
    guard = None
    if 'falls asleep' in ln:
        event = 1
    elif 'wakes up' in ln:
        event = 2
    elif 'begins shift' in ln:
        event = 3
        guard = int(ln.split(' ')[3][1:])
    events.append((stamp, event, guard))

events.sort()

last = None
sleep = None
for event in events:
    (stamp, event, guard) = event
    if event == 3 and guard != None:
        last = guard
    if event == 1:
        sleep = stamp.minute
    if event == 2:
        if last not in sleeps:
            sleeps[last] = 0
        sleeps[last] = sleeps[last] + stamp.minute - sleep

xs = {}

for k in sleeps:
    xs[k] = [0] * 60

last = None
sleep = None
for event in events:
    (stamp, event, guard) = event
    if event == 3 and guard != None:
        last = guard
    if event == 1:
        sleep = stamp.minute
    if event == 2:
        print(sleep, stamp.minute)
        for i in range(sleep, stamp.minute):
            xs[last][i] = xs[last][i] + 1

print(xs)
m = 0
n = None
xx = 0
for k, v in xs.items():
    bestIndex, best = max(enumerate(v), key=itemgetter(1))
    if best > xx:
        n = k
        m = bestIndex
        xx = best
        print(n, m)

print(m * n)
