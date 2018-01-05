:-dynamic arc/3.




arc(a,b,0). arc(a,c,0). arc(b,d,0). arc(b,c,0). arc(e,b,0). arc(c,d,0).
arc(c,f,0). arc(c,e,0). arc(e,f,0). arc(f,g,0). arc(d,f,0).   arc(f,d,0).
arc(g,f,0). arc(b,a,0). arc(d,g,0). arc(f,c,0). arc(f,e,0). arc(c,a,0).
arc(e,c,0). arc(d,b,0). arc(g,d,0). arc(d,c,0). arc(c,b,0). arc(b,e,0).


graphe_connexe([X|L]):-G=[X|L],connexe([X|L],G),!.





connexe([],_):-!.
connexe([X|L],G):-tester(X,G),!,connexe(L,G).
connexe([X|_],_):-nl,nl,write("Appartir du sommet :")
                       ,write(X),nl,nl
                       ,write(" on ne peut pas obtenir ensemble du sommets gu graphe").

tester(_,[]).

tester(X,[Y|L]):-X=Y,!,tester(X,L).

tester(X,[Y|L]):-chemin(X,Y),!,tester(X,L).

chemin(X,Y):-arc(X,Y,_),!.
chemin(X,Y):-arc(X,Z,N) ,N=<1
             ,retract(arc(X,Z,N))   /* retirer arc(X,Z,N) de la base des fait                     */
	     ,N1 is N+1,            /* N1 nombre fois passe par arc(X,Z)                          */
	     assert(arc(X,Z,N1))    /* Inseret arc avec Nouvelle valeur apres avoir increment N1  */
	                            /* qui est nombre fois passe par arc(X,Z)                     */
	     ,chemin(Z,Y),!,retract(arc(X,Z,N1)),assert(arc(X,Z,N)). /* rendre valeur intiale de arc dans
                                                                        cas chemin X,Y exist             */









