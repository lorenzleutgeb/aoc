p(X,Y) :- #int(X), #int(Y).

d(X1,Y1,X2,Y2,D) :-
    p(X1,Y1),
    p(X2,Y2),
    #absdiff(X1,X2,Dx),
    #absdiff(Y1,Y2,Dy),
    D = Dx + Dy.

dox(Xp,Yp,O,M) :-
    p(Xp,Yp), dot(O,Xd,Yd),
    d(Xp,Yp,Xd,Yd,M).

doy(X,Y,Ok,M) :-
    p(X,Y), dot(O,_,_), dot(Ok,_,_), O != Ok,
    dox(X,Y,O,N),
    #int(N),
    #int(M),
    N <= M.

cl(Xp,Yp,O,M) :-
    p(Xp, Yp), dot(O,_,_),
    #int(M),
    dox(Xp,Yp,O,M),
    not doy(Xp,Yp,O,M).

%:- p(X,Y), cl(X,Y,O1,_), cl(X,Y,O2,_), O1 <> O2.

border(Xp,Yp) :-
    p(Xp,Yp),
    Xp = #maxint.

border(Xp,Yp) :-
    p(Xp,Yp),
    Yp = #maxint.

border(Xp,Yp) :- p(Xp,Yp), Xp = 0.
border(Xp,Yp) :- p(Xp,Yp), Yp = 0.

inf(O) :-
    cl(Xp, Yp, O, _),
    border(Xp,Yp).

sz(O,C) :-
  dot(O,_,_),
  not inf(O),
  C = #count{Xp,Yp : #int(Xp), #int(Yp), cl(Xp,Yp,O,_)}.