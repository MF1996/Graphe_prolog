:-dynamic  phi/2.
:-dynamic   p/2.


arc(e,a).
arc(a,e).
arc(e,b).
arc(b,e).
arc(a,d).
arc(d,a).
arc(d,s).
arc(s,d).
arc(b,f).
arc(f,b).
arc(f,s).
arc(s,f).
arc(a,c).
arc(c,a).
arc(b,c).
arc(c,b).
arc(c,d).
arc(d,c).
arc(c,s).
arc(s,c).
arc(c,f).
arc(f,c).



cout(e,a,4).
cout(a,e,4).
cout(e,b,2).
cout(b,e,2).
cout(a,d,5).
cout(d,a,5).
cout(d,s,4).
cout(s,d,4).
cout(b,f,3).
cout(f,b,3).
cout(f,s,8).
cout(s,f,8).
cout(a,c,3).
cout(c,a,3).
cout(b,c,5).
cout(c,b,5).
cout(c,d,1).
cout(d,c,1).
cout(c,s,5).
cout(s,c,5).
cout(c,f,4).
cout(f,c,4).


                        /*   Debut sommet de debut
                             Fin   sommet de fin
                             CHEMIN LISTE sommet pour ariver à ce chemin
                             Cout cout de ce chemin
                        */



dijkstra(Debut,Fin,[X|L],CHEMIN , Cout):- S=[Debut]
                                         ,eff2(Debut,[X|L],S1)            /* Effacer sommet de debut */
                                         ,assert(phi(Debut,0))            /* intialiser phi du sommet debut 0*/
                                         ,init_p(Debut,[X|L])             /* initialise resultat de p à Debut
                                                                             p contient squequnce
                                                                             à prendre pour arriver au plus cour chemin */
                                         ,init_phi_reste(S,S1)            /* initaliser phi à inf pour sommet
                                                                             non succ à Debut est succ on le cout de arc*/
                                         ,list_val_phi(S1,R)              /* Avoir List valeur phi */
                                         ,minimum(_,R,Sommet)             /* Choisit sommet qui à phi minimale*/
                                         ,eff2(Sommet,S1,S2)              /* effacer ce sommet de la liste */
                                         ,findall(Z,arc(Sommet,Z),M)      /* Trouver tous succeseure de sommet*/
                                         ,inter_section(M,S2,S3)          /* avoir intersection  pour calculer phi de intersection */
                                         ,exe_algo(Sommet,S2,S3)          /* Commencer suite de l'algotithme */
                                         ,nl
                                         ,afficher_chemin(Debut,Fin,P,Cout)  /*Affiche chemin*/
                                         ,inverser(P,CHEMIN)                 /*Inverse  Car sommet de la liste P son
                                                                                 Fin---->Debut donc on inverse*/
                                         ,nl.

                                  /*  Inverser une Liste */

                                         inv([],L,L).
                                         inv([X|Y],Z,R):-inv(Y,[X|Z],R).
                                         inverser(L,R):-inv(L,[],R).


                                  /*   Afficher Chemin     */
                                         afficher_chemin(Debut,Fin,[Fin|P],Cout):-
                                                                                   p(Fin,X)
                                                                                  ,chemin(Debut,P,X)
                                                                                  ,phi(Fin,Cout).
                                         chemin(Debut,P,Debut):-     P=[Debut].
                                         chemin(Debut,[Fin|P],Fin):-
                                                                     p(Fin,X)
                                                                    ,chemin(Debut,P,X).


                                   /* Initlisation p qui indique appartire on peut s'avoir chemin court*/
                                          init_p(_,[]):-!.
                                          init_p(Debut,[Debut|L]):-
                                                                   !
                                                                   ,init_p(Debut,L).
                                          init_p(Debut,[X|L]):-
                                                                Debut\=X
                                                                ,!
                                                                ,assert(p(X,Debut))
                                                                ,init_p(Debut,L).

                                    /* Executer algorithme */
                                          exe_algo(_,_,[]):-!.
                                          exe_algo(Sommet,S2,S3):-
                                                                   calcule_cout(Sommet,S3) /* Calcule cout qui
                                                                                              revient à calculer phi     */
                                                                  ,calculer_p(Sommet,S3)   /*      Mise à jour chemin    */
                                                                  ,list_val_phi(S3,R)      /*      Meme scenario
                                                                                            choisire sommet ayant
                                                                                            phi minimale effacer ....etc */
                                                                  ,minimum(Sommet,R,X)
                                                                  ,eff2(X,S2,S5)
                                                                  ,findall(Z,arc(X,Z),L)
                                                                  ,inter_section(L,S2,S6)
                                                                  ,exe_algo(X,S5,S6)
                                                                  ,!.



                                     /*       Calculer Cout          */
                                         calcule_cout(_,[]):-!.
                                         calcule_cout(Sommet,[X|L]):-
                                                                      phi(X,C)           /* cout succ de Sommet  */
                                                                     ,phi(Sommet,C1)     /* cout sommet lui meme */
                                                                     ,cout(Sommet,X,C2)  /* cout d'allez sommet vers X*/
                                                                     ,C3 is C2 +C1
                                                                     ,min_val(C3,C,Min)  /* Prend la plus petit valeur*/
                                                                     ,retract(phi(X,C))  /* retirer phi x ancien de la base fait*/
                                                                     ,assert(phi(X,Min)) /* Inserer phi X avec nouvelle valeur Min*/
                                                                     ,calcule_cout(Sommet,L),!.



                                     /*        Intersection               */
                                          inter_section([],_,[]):-!.
                                          inter_section([X|L],Y,[X|R]):- member(X,Y),!,inter_section(L,Y,R).
                                          inter_section([X|L],Y,R):- \+member(X,Y),!,inter_section(L,Y,R).


                                     /*        List valeur de PHI          */
                                          list_val_phi([X|L],[V|K]):-phi(X,V),list_val_phi(L,K),!.
                                          list_val_phi(_,K):-K=[],!.

                                      /* Min entre deux valeur pour phi     */
                                           min_val(X,Y,Min):-X>=Y ,!, Min is Y.
                                           min_val(X,Y,Min):-X=<Y ,!, Min is X.


                                      /* Minimum dans une Liste              */
                                           minimum(Sommet,[],X):-X=Sommet,!.
                                           minimum(_,[X|L],Sommet):-min(X,L,Min),phi(Sommet,Min),!.

                                           min(X,[Y|L],Min):- X=<Y,!,min(X,L,Min).
                                           min(X,[Y|L],Min):- X>=Y,!,min(Y,L,Min).
                                           min(X,[],Min):- Min is X ,!.

                                       /* Initialiser reste de phi            */

                                           init_phi_reste(_,[]):-!.
                                           init_phi_reste([Debut],[X|L]):-findall(Z,arc(Debut,Z),L2)
                                                                          ,init_succ_debut(Debut,L2)   /* initilaser succeseur */
                                                                          ,retirer_sommet(L2,[X|L],M) /*  retirer succeseur    */
                                                                          ,init_non_succ(M),!.        /*  initaliser non succ  */

                                       /* Retirer sommet de la Liste            */
                                            retirer_sommet([],L1,L1):-!.
                                            retirer_sommet([X|L],[Y|L1],M):-
                                                                             eff2(X,[Y|L1],L2)
                                                                             ,retirer_sommet(L,L2,M),!.

                                       /* Initaliser Non SUCC                    */
                                            init_non_succ([]).
                                            init_non_succ([X|L]):-assert(phi(X,inf))
                                            ,init_non_succ(L).

                                       /*  Init succ debut                        */
                                            init_succ_debut(_,[]).
                                            init_succ_debut(Debut,[X|L]):-
                                                                           cout(Debut,X,C)
                                                                          ,assert(phi(X,C))
                                                                          ,init_succ_debut(Debut,L).

                                        /* effacer un seule sommet*/
                                             eff2(_, [], []):-!.
                                             eff2(A, [A | L], M) :- eff2(A, L, M), !.
                                             eff2(A, [B | L], [B | M]) :- eff2(A, L, M),!.




                                             calculer_p(_,[]).
                                             calculer_p(Sommet,[X|L]):-
                                                                         phi(Sommet,C)
                                                                        ,cout(Sommet,X,C1)
                                                                        ,C2 is C +C1
                                                                        ,phi(X,C3)
                                                                        ,C2=C3
                                                                        ,retract(p(X,_))
                                                                        ,assert(p(X,Sommet))
                                                                        ,calculer_p(Sommet,L).

                                               calculer_p(Sommet,[_|L]):-calculer_p(Sommet,L).















































