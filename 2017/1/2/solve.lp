after(X,Y) :- Y = X + S, S = n / 2, dig(X,_), dig(Y,_).
after(Y,X) :- after(X,Y).

pair(X,D) :- dig(X,D), dig(Y,D), after(X,Y).

result(S) :- S = #sum{ D, X : pair(X,D) }.
