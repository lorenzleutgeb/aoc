import sys
import networkx as nx
from networkx.algorithms.dag import lexicographical_topological_sort

g = nx.DiGraph()

for foo in sys.stdin:
    x = foo.strip().split(" ")
    g.add_edge(x[0], x[1])

x = list(lexicographical_topological_sort(g))#, key=prio.get))
print(''.join(x))
