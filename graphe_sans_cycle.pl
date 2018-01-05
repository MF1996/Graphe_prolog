:-dynamic arc/3.


arc(a,b,0).
arc(a,c,0).
arc(c,f,0).
arc(f,d,0).
arc(c,e,0).
arc(d,c,0).
arc(d,e,0).
arc(d,a,0).
arc(b,f,0).

chemin(X,_):-arc(X,X,_),!.
chemin(X,Y):-arc(X,Y,_),nl,write("arc("),write(X),write(","),write(Y),write(")"),!.
chemin(X,Y):- arc(X,Z,N)
	     ,retract(arc(X,Z,N))   /* retirer arc(X,Z,N) de la base des fait */
	     ,N1 is N+1,            /* N1 nombre fois passe par arc(X,Z)  */
	     assert(arc(X,Z,N1))      /* Inseret arc avec Nouvelle valeur apres avoir increment N1  */
	     ,nl,nl,write("arc(")
              ,write(X),write(","),write(Z),write(")")
              ,write("Nombre  fois  passe :"),write(N1),nl,nl
             ,N1=<1                      /* qui est nombre fois passe par arc(X,Z)*/
	                    ,chemin(Z,Y).


circuit(X):-write("Sommet "),write(X),chemin(X,X). /* chemin de a vers a exemple */

graphe_sans_cycle([]):- write("Graphe est sans Cycle").


/*si n'existe pas de circuit on passe verifier sommet suivant*/
graphe_sans_cycle([X|L]):-
                          not(circuit(X))
                        ,nl,nl,write(X),write(" n'a pas de cycle"),nl,nl,reinitialiser([X|L])
                         ,!,graphe_sans_cycle(L).


reinitialiser([]).
reinitialiser([X|L]):-findall(Z,arc(X,Z,_),M),init(X,M),reinitialiser(L).

init(_,[]).
init(X,[Y|L]):- retract(arc(X,Y,_)),assert(arc(X,Y,0)),init(X,L).

/*   Remarque
  Il n'est forecement de partitre du sommet b puis aboutire à b il peut
  y avoir des cycles internet quand on parcoure le graphe

*/





















