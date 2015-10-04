slots(4). 
disciplinas(12). 
disciplina(1,[1,2,3,4,5]). 
disciplina(2,[6,7,8,9]). 
disciplina(3,[10,11,12]). 
disciplina(4,[1,2,3,4]). 
disciplina(5,[5,6,7,8]). 
disciplina(6,[9,10,11,12]). 
disciplina(7,[1,2,3,5]). 
disciplina(8,[6,7,8]). 
disciplina(9,[4,9,10,11,12]). 
disciplina(10,[1,2,4,5]). 
disciplina(11,[3,6,7,8]). 
disciplina(12,[9,10,11,12]). 

incomp(D1,D2,N):-
	disciplina(D1,LA1),
	disciplina(D2,LA2),
	findall(A,(member(A,LA1),member(A,LA2)),LA12),
	length(LA12,N).
	
faval(Sol,V):-
	findall(N,
				(nth1(D1,Sol,Slot),
				 nth1(D2,Sol,Slot),
				 D1<D2,
				 incomp(D1,D2,N)),
			LInc),
	sumlist(LInc,V).
	
hillclimbing(Sol,SolF):-
	vizinho(Sol,Sol2),
	faval(Sol,V),
	faval(Sol2,V2),
	V2<V,!,write(Sol2-V2),nl,
	hillclimbing(Sol2,SolF).
	
hillclimbing(SolF,SolF).

vizinho(Sol,Sol2):-
	nth1(D,Sol,Slot),
	slots(Ns),
	between(1,NS,NoooSlot),
	NoooSlot\=Slot,
	mudaslot(Sol,D,NoooSlot,Sol2).

mudaslot(Sol,D,NoooSlot,Sol2):-
	D1 is D-1,  length(L1,D1),
	append(L1,[_|L2],Sol),
	append(L1,[NovoSlot|L2],Sol2).
	
	
sol_inicial([1,1,1,1,1,1,1,1,1,1,1,1]). % Mudar isto para gerar a solucao! Solucao aleatoria? 
sol_inicial([1,1,1,2,2,2,3,3,3,4,4,1]). % Quase a solucao 
sol_inicial([1,1,4,2,2,2,3,3,3,4,4,1]). % Minimo Local? 
sol_inicial([1,2,3,4,1,2,3,4,1,2,3,4]). % E agora

solv:-
	sol_inicial(S),
	hillclimbing(S,SF),
	write(SF).

