min(R,X) :- row(R), X = #min { Y: cell(R,_,Y) }.
max(R,X) :- row(R), X = #max { Y: cell(R,_,Y) }.

diff(R,D) :- min(R,A), max(R,B), D = B - A.

result(S) :- S = #sum { D, R: diff(R,D) }.
