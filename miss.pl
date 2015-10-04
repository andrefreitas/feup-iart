%estado inicial
estado_inicial(estado(3, 3, 1)).

%estado final
estado_final(estado(0, 0, 0)).

%transições entre estados
sucessor(estado(NM, NC, 1), NovoEstado) :-
	NM1 is NM - 1,
	NC1 is NC - 1,
	NovoEstado = estado(NM1, NC1, 0),
	legal(NovoEstado).
sucessor(estado(NM, NC, 1), NovoEstado) :-
	NM1 is NM - 1,
	NovoEstado = estado(NM1, NC, 0),
	legal(NovoEstado).
sucessor(estado(NM, NC, 1), NovoEstado) :-
	NC1 is NC - 1,
	NovoEstado = estado(NM, NC1, 0),
	legal(NovoEstado).
sucessor(estado(NM, NC, 1), NovoEstado) :-
	NM1 is NM - 2,
	NovoEstado = estado(NM1, NC, 0),
	legal(NovoEstado).
sucessor(estado(NM, NC, 1), NovoEstado) :-
	NC1 is NC - 2,
	NovoEstado = estado(NM, NC1, 0),
	legal(NovoEstado).
sucessor(estado(NM, NC, 0), NovoEstado) :-
	NM1 is NM + 1,
	NC1 is NC + 1,
	NovoEstado = estado(NM1, NC1, 1),
	legal(NovoEstado).
sucessor(estado(NM, NC, 0), NovoEstado) :-
	NM1 is NM + 1,
	NovoEstado = estado(NM1, NC, 1),
	legal(NovoEstado).
sucessor(estado(NM, NC, 0), NovoEstado) :-
	NC1 is NC + 1,
	NovoEstado = estado(NM, NC1, 1),
	legal(NovoEstado).
sucessor(estado(NM, NC, 0), NovoEstado) :-
	NM1 is NM + 2,
	NovoEstado = estado(NM1, NC, 1),
	legal(NovoEstado).
sucessor(estado(NM, NC, 0), NovoEstado) :-
	NC1 is NC + 2,
	NovoEstado = estado(NM, NC1, 1),
	legal(NovoEstado).

legal(estado(NM, NC, _)) :-
	NM >= 0,
	NC >= 0,
	NM =< 3,
	NC =< 3,
	(NM >= NC; NM = 0),
	NMdireita is 3-NM,
	NCdireita is 3-NC,
	(NMdireita >= NCdireita; NMdireita = 0).
	
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