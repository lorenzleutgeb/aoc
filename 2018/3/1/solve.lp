covers(A,Xo,Yo) :-
	#int(Xo), #int(Yo),
	claim(A,Xa,Ya,Wa,Ha),
	Xa <= Xo, Xo < Xa2, Xa2 = Xa + Wa,
	Ya <= Yo, Yo < Ya2, Ya2 = Ya + Ha.

result(S) :- S = #count { Xo, Yo: covers(A,Xo,Yo), covers(B,Xo,Yo), A != B }.
