invalid(R) :- word(R,A,W), word(R,B,W), A != B.
result(S) :- S = #count { R: row(R), not invalid(R) }.
