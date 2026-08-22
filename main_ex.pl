% --- EXEMPLO De SOLUCAO COM ASSISTENCIA DO CLAUDE ---
:- use_module(library(clpfd)).

% ---------------------------------------------------------------
% IDEIA CENTRAL:
% Cada VALOR de cada categoria (ex: "azul", "joao", "janeiro"...)
% vira uma variavel cujo dominio e a POSICAO (1..5) em que ele
% ocorre. Assim:
%   - "Joao gosta de historia"   ==  Joao #= Historia
%   - "azul esta a esquerda de maio"  ==  Azul #< Maio
%   - "X esta ao lado de Y"    ==  abs(X-Y) #= 1
% Isso elimina a necessidade de permutacoes/alldifferent sobre
% tuplas complexas: cada categoria e apenas all_distinct/1 sobre
% suas 5 posicoes.
% ---------------------------------------------------------------

adjacente(X, Y) :- abs(X - Y) #= 1.
ponta(X) :- X #= 1 #\/ X #= 5.

modelo(Mochilas, Nomes, Meses, Jogos, Materias, Sucos) :-

    Mochilas  = [Amarela, Azul, Branca, _Verde, Vermelha],
    Nomes     = [_Denis, Joao, Lenin, Otavio, Will],
    Meses     = [_Agosto, Dezembro, Janeiro, Maio, Setembro],
    Jogos     = [TresOuMais, _CacaPalavras, Cubo, Forca, Logica],
    Materias  = [Biologia, _Geografia, Historia, Matematica, Portugues],
    Sucos     = [Laranja, Limao, Maracuja, Morango, Uva],

    Todas = [Mochilas, Nomes, Meses, Jogos, Materias, Sucos],
    append(Todas, TodasVars),
    TodasVars ins 1..5,

    all_distinct(Mochilas),
    all_distinct(Nomes),
    all_distinct(Meses),
    all_distinct(Jogos),
    all_distinct(Materias),
    all_distinct(Sucos),

    adjacente(Setembro, Laranja),        % 1
    Joao #= Historia,                    % 2
    Azul #< Maio,                        % 3
    adjacente(Will, Logica),             % 4
    Will #= Branca + 1,                  % 5  (branca exatamente a esquerda de Will)
    Morango #= 3,                        % 6
    Uva #= Logica,                       % 7
    adjacente(Forca, TresOuMais),        % 8
    Azul #< Uva,                         % 9
    ponta(Cubo),                         % 10
    adjacente(Forca, Vermelha),          % 11
    Biologia #= Morango,                 % 12
    adjacente(Janeiro, Setembro),        % 13
    Portugues #= Uva + 1,                % 14
    Matematica #= Dezembro,              % 15
    adjacente(Logica, Amarela),          % 16
    Azul #= Janeiro,                     % 17
    adjacente(Setembro, Cubo),           % 18
    Limao #= 1,                          % 19
    Matematica #= Maracuja,              % 20
    Lenin #= 5,                          % 21
    ponta(Otavio),                       % 22
    Forca #= 3.                          % 23

% ---------------------------------------------------------------
% Impressao do resultado
% ---------------------------------------------------------------

nomes_mochila([amarela, azul, branca, verde, vermelha]).
nomes_nome([denis, joao, lenin, otavio, will]).
nomes_mes([agosto, dezembro, janeiro, maio, setembro]).
nomes_jogo([tres_ou_mais, caca_palavras, cubo_vermelho, jogo_da_forca, logica]).
nomes_materia([biologia, geografia, historia, matematica, portugues]).
nomes_suco([laranja, limao, maracuja, morango, uva]).

% dado a lista de posicoes (na ordem fixa da categoria) e a lista de
% rotulos (mesma ordem), monta um par (Posicao-Rotulo)
monta_pares(Posicoes, Rotulos, Pares) :-
    pairs_keys_values(Pares0, Rotulos, Posicoes),
    maplist([R-P, P-R]>>true, Pares0, Pares).

linha(Categoria, Posicoes, Rotulos) :-
    monta_pares(Posicoes, Rotulos, Pares),
    keysort(Pares, Ordenados),
    pairs_values(Ordenados, Valores),
    maplist(celula, Valores, Celulas),
    atomic_list_concat(Celulas, Linha),
    format("~w~t~15|~w~n", [Categoria, Linha]).

celula(V, Celula) :- format(atom(Celula), "~w~t~16|", [V]).

imprime(Mochilas, Nomes, Meses, Jogos, Materias, Sucos) :-
    nomes_mochila(RM), nomes_nome(RN), nomes_mes(RMes),
    nomes_jogo(RJ), nomes_materia(RMat), nomes_suco(RS),
    format("~n~`-t~50|~n"),
    linha('Mochila', Mochilas, RM),
    linha('Nome', Nomes, RN),
    linha('Mes', Meses, RMes),
    linha('Jogo', Jogos, RJ),
    linha('Materia', Materias, RMat),
    linha('Suco', Sucos, RS),
    format("~`-t~50|~n").

resolver :-
    modelo(Mochilas, Nomes, Meses, Jogos, Materias, Sucos),
    append([Mochilas, Nomes, Meses, Jogos, Materias, Sucos], Todas),
    label(Todas),
    imprime(Mochilas, Nomes, Meses, Jogos, Materias, Sucos).

main :-
    statistics(cputime, T1),
    ( resolver -> true ; write('SEM SOLUCAO'), nl ),
    statistics(cputime, T2),
    Tempo is T2 - T1,
    format("~nTempo de execucao: ~3f s~n", [Tempo]).
