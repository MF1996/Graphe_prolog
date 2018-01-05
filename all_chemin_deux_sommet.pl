:-dynamic arc/2.


arc(a,d).
arc(c,d).
arc(c,a).
arc(b,a).
arc(b,d).
arc(b,c).



chemin(X,Y,L):-arc(X,Y),L=[X,Y].
chemin(X,Y,L):-
		arc(X,Z)
		,chemin(Z,Y,L2)
		,L=[X|L2].

