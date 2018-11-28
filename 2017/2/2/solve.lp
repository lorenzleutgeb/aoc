checksum(R,D) :- cell(R,_,X), cell(R,_,Y), X > Y, #mod(X,Y,0), /(X,Y,D).

result(S) :- S = #sum { D, R: checksum(R,D) }.
