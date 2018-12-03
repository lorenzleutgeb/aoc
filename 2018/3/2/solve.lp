left(A,B) :-
	claim(A,Xa,Ya,Wa,Ha),
	claim(B,Xb,Yb,Wb,Hb),
	XWa = Xa + Wa,
	Xb >= XWa.

below(A,B) :-
	claim(A,Xa,Ya,Wa,Ha),
	claim(B,Xb,Yb,Wb,Hb),
	YHa = Ya + Ha,
	Yb >= YHa.

-overlap(A,B) :- left(A,B).
-overlap(A,B) :- below(A,B).
-overlap(B,A) :- -overlap(A,B).
-overlap(A,A) :- claim(A,_,_,_,_).

overlap(A,B) :- not -overlap(B,A), claim(A,_,_,_,_), claim(B,_,_,_,_).

bad(X) :- claim(X,_,_,_,_), claim(Y,_,_,_,_), overlap(X,Y).

result(X) :- not bad(X), claim(X,_,_,_,_).
