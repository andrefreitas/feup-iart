%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Formalização do jogo dos palitos:
% - existem inicialmente 10 palitos sobre a mesa
% - cada jogador pode retirar um, dois ou três palitos na sua vez
% - o objectivo é evitar ficar com o último palito
%%%%%%%%%%

% a representação do estado vai incluir também o jogador a jogar,
% pois neste jogo é importante para efeitos de avaliação do estado

% representação de um estado: (NumeroPalitos, Quemjoga)

estado_inicial((10,max)).

% estado final (ter 0 palitos é bom): só interessa para o minimax simples
estado_final((0,max), 1).
estado_final((0,min), 0).

% transições entre estados (as jogadas são as mesmas para os 2 jogadores)
sucessor((N,max), _, (N1,min)) :- N>0, N1 is N-1.
sucessor((N,max), _, (N1,min)) :- N>1, N1 is N-2.
sucessor((N,max), _, (N1,min)) :- N>2, N1 is N-3.
sucessor((N,min), _, (N1,max)) :- N>0, N1 is N-1.
sucessor((N,min), _, (N1,max)) :- N>1, N1 is N-2.
sucessor((N,min), _, (N1,max)) :- N>2, N1 is N-3.

% avaliação de estados
minimax(E,_,Valor,_,0):-avalia(E,Valor).

minimax(E,max,Valor,Jogada,P):-
	findall(E2,sucessor(E,max,E2),Ls),
	( 
		Ls=[],!,avalia(E,Valor);
		maxvalue(Ls,Valor,Jogada,P)
	).
	
minimax(E,min,Valor,Jogada,P):-
	findall(E2,sucessor(E,min,E2),Ls),
	( 
		Ls=[],!,avalia(E,Valor);
		minvalue(Ls,Valor,Jogada,P)
	).
	

% max e min values
maxvalue([E],V,E,P):-
	P1 is P-1,
	minimax(E,min,V,_,P1).
	
maxvalue([E1|Es],MV,ME,P):-
	P1 is P-1,
	minimax(E1,min,V1,_,P1),
	maxvalue(Es,V2,E2,P),
	(V1>V2,!,MV=V1,ME=E1;
		MV=V2,ME=E2).
		
minvalue([E],V,E,P):-
	P1 is P-1,
	minimax(E,max,V,_,P1).
	
minvalue([E1|Es],MV,ME,P):-
	P1 is P-1,
	minimax(E1,max,V1,_,P1),
	minvalue(Es,V2,E2,P),
	(V1<V2,!,MV=V1,ME=E1;
		MV=V2,ME=E2).

avalia((N,max),H):-
	1 is N mod 4,!,H=0;H=1.
	
avalia((N,min),H):-
	1 is N mod 4,!,H=1;H=0.
		
pesq_minimax(Jogada,V,P):-
	estado_inicial(Ei),
	minimax(Ei,max,V,Jogada,P).