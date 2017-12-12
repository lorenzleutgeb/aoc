reachable(A,B) :- edge(A,B).
reachable(A,B) :- reachable(A,C), edge(C,B).

representative(A,B) :- node(A), B = #min{ C: reachable(A,C) }.

result(R) :- R = #count{ X : representative(_,X) }.
