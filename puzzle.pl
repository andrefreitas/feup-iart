% 2.3

%estado inicial
estado_inicial([p, p, b, b, v]).

%estado final
estado_final(E) :- brancasAntesPretas(E, 2).

brancasAntesPretas(_, 0) :- !.
brancasAntesPretas([b|R], NB) :-
	NB1 is NB-1,
	brancasAntesPretas(R, NB1).
brancasAntesPretas([v|R], NB) :-
	brancasAntesPretas(R, NB).

%transições entre estados
sucessor(E,E2):- moveAdj(E,E2).
sucessor(E,E2):- salta1(E,E2).
sucessor(E,E2):- salta2(E,E2).

moveAdj([X,v|R], [v,X|R]).
moveAdj([v,X|R], [X,v|R]).
moveAdj([X|R], [X|R1]):- moveAdj(R,R1).

salta1([X1,X2,v|R], [v,X2,X1|R]).
salta1([v,X1,X2|R], [X2,X1,v|R]).
salta1([X|R], [X|R1]):- salta1(R,R1).

salta2([X1,X2,X3,v|R], [v,X2,X3,X1|R]).
salta2([v,X1,X2,X3|R], [X3,X1,X2,v|R]).
salta2([X|R], [X|R1]):- salta2(R,R1).


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