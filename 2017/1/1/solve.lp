after(X,Y) :- Y = X + 1, dig(X,_), dig(Y,_).
after(n,0).

pair(X,D) :- dig(X,D), dig(Y,D), after(X,Y).

result(S) :- S = #sum{ D, X : pair(X,D) }.
