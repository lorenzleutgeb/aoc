import sys

score, total = 0, 0
garbage, ignore = False, False

for c in sys.stdin.readline().strip():
    if ignore:
        ignore = False
    elif c == "!":
        ignore = True
    elif c == "<":
        garbage = True
    elif c == ">":
        garbage = False
    elif not garbage:
        if c == "{":
            score = score + 1
            total = total + score
        elif c == "}":
            score = score - 1

print(total)
