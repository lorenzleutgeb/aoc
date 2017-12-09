import sys

score, total = 0, 0
garbage, ignore = False, False

for c in sys.stdin.readline().strip():
    if ignore:
        ignore = False
    elif c == "!":
        ignore = True
    elif c == ">":
        garbage = False
    elif garbage:
        total = total + 1
    elif c == "<":
        garbage = True

print(total)
