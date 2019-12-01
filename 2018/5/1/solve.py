import sys
import string

p = sys.stdin.readlines()[0].strip()

def run(s,x):
    stk = []
    for c in s:
        popped = False
        if stk:
            bk = stk[-1]
            if ((bk == x and c == x.lower()) or (c == x.lower() and bk == x)) and bk.lower() == c.lower():
                stk.pop()
                popped = True
        if not popped:
            stk.append(c)
    print(len(stk))
    return len(stk)

s = p

alpha = 'abcdefghijklmnopqrstuvwxyz'
M = {}
for c in alpha:
    M[c.lower()] = c.upper()
    M[c.upper()] = c.lower()

ans = 1e5
for rem in alpha:
    s2 = [c for c in s if c!=rem.lower() and c!=rem.upper()]
    stack = []
    for c in s2:
        if stack and c == M[stack[-1]]:
            stack.pop()
        else:
            stack.append(c)
    ans = min(ans, len(stack))
print(ans)


lel = min(string.ascii_lowercase, key=lambda x: run(p, x.upper()))
print(lel)
print(run(p, lel.upper()))
