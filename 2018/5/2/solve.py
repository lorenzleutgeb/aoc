import sys

p = sys.stdin.readlines()[0].strip()

def run(s):
    stk = []
    for c in s:
        popped = False
        if stk:
            bk = stk[-1]
            if (('A' <= bk <= 'Z' and 'a' <= c <= 'z') or ('A' <= c <= 'Z' and 'a' <= bk <= 'z')) and bk.lower() == c.lower():
                stk.pop()
                popped = True
        if not popped:
            stk.append(c)
    return len(stk)

print(run(p))
#print(p)
changed = True
while changed:
    changed = False
    for i in range(0, len(p) - 1):
        j = i + 1
        if p[i] != p[j] and p[i].lower() == p[j].lower():
#            print(p[i] + p[j])
            p = p[:i] + p[j+1:]
#print(p)
            changed = True
            break
print(p)
print(len(p))
