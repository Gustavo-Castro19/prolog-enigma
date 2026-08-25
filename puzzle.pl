mochila(amarela). 
mochila(azul). 
mochila(branca). 
mochila(verde). 
mochila(vermelha).

nome(denis).
nome(joao).
nome(lenin).
nome(otavio).
nome(will).

mes(agosto).
mes(dezembro).
mes(janeiro).
mes(maio).
mes(setembro).

jogo(tres_ou_mais). 
jogo(caca_palavras). 
jogo(cubo_vermelho). 
jogo(jogo_da_forca). 
jogo(logica).

materia(biologia). 
materia(geografia). 
materia(historia). 
materia(matematica). 
materia(portugues).

suco(laranja). 
suco(limao). 
suco(maracuja). 
suco(morango). 
suco(uva).


pos(Lista, Valor, Posicao) :- nth1(Posicao, Lista, Valor).

mesma_posicao(L1, V1, L2, V2) :-
    pos(L1, V1, P), pos(L2, V2, P).

adjacentes(L1, V1, L2, V2) :-
    pos(L1, V1, P1), pos(L2, V2, P2),
    ( P2 is P1 + 1 ; P1 is P2 + 1 ).

esquerda(L1, V1, L2, V2) :-
    pos(L1, V1, P1), pos(L2, V2, P2), P1 < P2.

exatamente_esquerda(L1, V1, L2, V2) :-
    pos(L1, V1, P1), pos(L2, V2, P2), P2 is P1 + 1.

ponta(L, V) :- pos(L, V, P), (P =:= 1 ; P =:= 5).

naposicao(L, V, P) :- pos(L, V, P).


modelo(Mochilas, Nomes, Meses, Jogos, Materias, Sucos) :-

    findall(S, suco(S), SucosDominio),
    permutation(SucosDominio, Sucos),
    naposicao(Sucos, limao, 1),                            
    naposicao(Sucos, morango, 3),                          

    findall(J, jogo(J), JogosDominio),
    permutation(JogosDominio, Jogos),
    adjacentes(Jogos, jogo_da_forca, Jogos, tres_ou_mais),  
    ponta(Jogos, cubo_vermelho),                            
    naposicao(Jogos, jogo_da_forca, 3),                     
    mesma_posicao(Sucos, uva, Jogos, logica),               

    findall(M, mes(M), MesesDominio),
    permutation(MesesDominio, Meses),
    adjacentes(Meses, janeiro, Meses, setembro),            
    adjacentes(Sucos, laranja, Meses, setembro),            
    adjacentes(Jogos, cubo_vermelho, Meses, setembro),      

    findall(Mo, mochila(Mo), MochilasDominio),
    permutation(MochilasDominio, Mochilas),
    esquerda(Mochilas, azul, Sucos, uva),                   
    adjacentes(Jogos, jogo_da_forca, Mochilas, vermelha),   
    adjacentes(Jogos, logica, Mochilas, amarela),           
    esquerda(Mochilas, azul, Meses, maio),                  
    mesma_posicao(Mochilas, azul, Meses, janeiro),          

    findall(Mt, materia(Mt), MateriasDominio),
    permutation(MateriasDominio, Materias),
    mesma_posicao(Materias, biologia, Sucos, morango),      
    exatamente_esquerda(Sucos, uva, Materias, portugues),   
    mesma_posicao(Materias, matematica, Sucos, maracuja),   
    mesma_posicao(Materias, matematica, Meses, dezembro),   

    findall(N, nome(N), NomesDominio),
    permutation(NomesDominio, Nomes),
    naposicao(Nomes, lenin, 5),                             
    ponta(Nomes, otavio),                                   
    mesma_posicao(Materias, historia, Nomes, joao),         
    adjacentes(Jogos, logica, Nomes, will),                 
    exatamente_esquerda(Mochilas, branca, Nomes, will).     


linha(Categoria, Lista) :-
    format("~w~t~15|", [Categoria]),
    imprime_celulas(Lista),
    nl.

imprime_celulas([]).
imprime_celulas([V|T]) :-
    format(atom(C), "~w~t~16|", [V]),
    write(C),
    imprime_celulas(T).

imprime(Mochilas, Nomes, Meses, Jogos, Materias, Sucos) :-
    format("~n~`-t~90|~n"),
    linha('Mochila', Mochilas),
    linha('Nome',    Nomes),
    linha('Mes',     Meses),
    linha('Jogo',    Jogos),
    linha('Materia', Materias),
    linha('Suco',    Sucos),
    format("~`-t~90|~n").

resolver :-
    modelo(Mochilas, Nomes, Meses, Jogos, Materias, Sucos),
    !,
    imprime(Mochilas, Nomes, Meses, Jogos, Materias, Sucos).
resolver :-
    write('SEM SOLUCAO'), nl.

main :-
    statistics(cputime, T1),
    resolver,
    statistics(cputime, T2),
    Tempo is T2 - T1,
    format("~nTempo de execucao: ~3f s~n", [Tempo]).
