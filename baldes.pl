:- use_module(library(lists)).

estado_inicial(b(0,0)).
estado_final(b(2,0)).

sucessor(b(X,Y), b(4,Y),C) :- X<4,C is 4-X.
sucessor(b(X,Y), b(X,3),C) :- Y<3,C is 3-Y.
sucessor(b(X,Y), b(0,Y),X) :- X>0.
sucessor(b(X,Y), b(X,0),Y) :- Y>0.
sucessor(b(X,Y), b(4,Y1),C) :-
			X+Y>=4,
			X<4,
			Y1 is Y-(4-X),
			C is 4-X.
sucessor(b(X,Y), b(X1,3),C) :-
			X+Y>=3,
			Y<3,
			X1 is X-(3-Y),
			C is 3 - Y.
sucessor(b(X,Y), b(X1,0),C) :-
			X+Y<4,
			Y>0,
			X1 is X+Y,
			C is X+Y.
sucessor(b(X,Y), b(0,Y1),C) :-
			X+Y<3,
			X>0,
			Y1 is X+Y,
			C is X+Y.
			
pesq_prof(E,_,[E]):-estado_final(E).
pesq_prof(E,Visit,[E|R]):-
	sucessor(E,E2), 
	\+(member(E2,Visit)),
	pesq_prof(E2,[E2|Visit],R).

resolve_pp(Sol):-
	estado_inicial(Ei),
	pesq_prof(Ei,[Ei],Sol).
	
pesq_larg([E-Cam|R],[E|Cam]):-estado_final(E).
pesq_larg([E-Cam|R],Sol):-
	findall(E2-[E|Cam],
	sucessor(E,E2),Ls),
	append(R,Ls,L2),
	pesq_larg(L2,Sol).

resolve_pl(Sol):-
	estado_inicial(Ei),
	pesq_larg([Ei-[]],SolInv),
	reverse(SolInv,Sol).
	
h(b(X,Y),H):-
	estado_final(b(Xf,Yf)),
	DifX is Xf-X,
	DifY is Yf-Y,
	H is max(abs(DifX),abs(DifY)).
	
astar([F-E-Cam-G-H|R],[E|Cam]):- estado_final(E).
astar([F-E-Cam-G-H|R],Sol):- 
	findall(F2-E2-[E|Cam]-G2-H2,
			(sucessor(E,E2,C),
				G2 is G+C,
				h(E2,H2),
				F2 is G2+H2),
				LS),
	append(R,LS,L2),
	keysort(L2,L2Ord),
	astar(L2Ord,Sol).
	
resolve_astar(S):-
	estado_inicial(Ei),h(Ei,H),
	astar([H-Ei-[]-0-H],SInv),
	reverse(SInv,S).