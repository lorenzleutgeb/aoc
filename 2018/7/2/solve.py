import sys
import networkx as nx
from networkx.algorithms.dag import lexicographical_topological_sort

tim = {}

#n, m, o = 2, 6, 0
n, m, o = 4, 26, 60

for i, letter in enumerate(map(chr, range(65, 65 + m))): #91
    tim[letter] = o + 1 + i

print(tim)

g = nx.DiGraph()

for foo in sys.stdin:
    x = foo.strip().split(" ")
    g.add_edge(x[0], x[1])

x = list(lexicographical_topological_sort(g))
print(x)


ws = [None] * n
tot = 0
while True:
    for i in range(n):
        if ws[i] != None:
            tim[ws[i]] = max(tim[ws[i]] - 1, 0)
            if tim[ws[i]] == 0:
                del tim[ws[i]]
                ws[i] = None

    if len(x) > 0:
        for i in range(n):
            wi = ws[i]
            if wi != None:
                continue
            if len(x) == 0:
                break
            for k in range(len(x)):
                pick = True
                for j in range(n):
                    if ws[j] != None and nx.has_path(g, ws[j], x[k]):
                        pick = False
                        break
                if pick:
                    ws[i] = x[k]
                    x = x[:k] + x[k+1 :]
                    break



    print(tot, " ".join(list(map((lambda x: '.' if x == None else x), ws))), sum(tim.values()))
    if sum(tim.values()) == 0:
        break
    tot = tot + 1

print(tot)
