reachable(A,B) :- edge(A,B).
reachable(A,B) :- reachable(A,C), edge(C,B).

result(R) :- R = #count{ N : reachable(0,N) }.
