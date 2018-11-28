% Transitive closure of parent.
elder(P,N) :- parent(P,N).
elder(P,N) :- parent(P,E), elder(E,N).

% Recursive Weight.
rweight(N,Wr) :- node(N), Wc = #sum { W, C: weight(C,W), elder(N,C) }, weight(N,Wp), Wr = Wc + Wp.

% Node Cw is unbalanced and should have weight Wc instead of its current weight.
unbalanced(Cw,Wc) :-
	node(N),

	parent(N,Cc1),
	parent(N,Cc2),
	parent(N,Cw),

	Cc1 < Cc2,
	Cw != Cc1,
	Cw != Cc2,

	rweight(Cc1,Wrc),
	rweight(Cc2,Wrc),
	rweight(Cw,Wrw),

	Wrc != Wrw,

	weight(Cw,W),
	#absdiff(Wrc,Wrw,Wd),
	#absdiff(Wd,W,Wc).

% Discard (transitive) parents of unbalanced nodes.
discard(E) :- elder(E,N), unbalanced(N,_).

result(W) :- unbalanced(N,W), not discard(N).
