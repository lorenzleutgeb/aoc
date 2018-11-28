-root(N) :- node(N), node(P), parent(P,N).
result(N) :- node(N), not -root(N).
