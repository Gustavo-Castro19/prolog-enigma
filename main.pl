main :- statistics(cputime,T1),
modelo,
statistics(cputime,T2),
Time is T2-T1,
format('~n tempo de execucao ~3f s ~n', [tempo]),
fail.

modelo :- 
alldifferent([ 
  (Mochila_1, Nome_1, Mes_1, Jogo_1, Materia_1, Suco_1),
  (Mochila_2, Nome_2, Mes_2, Jogo_2, Materia_2, Suco_2),
  (Mochila_3, Nome_3, Mes_3, Jogo_3, Materia_3, Suco_3),
  (Mochila_4, Nome_4, Mes_4, Jogo_4, Materia_4, Suco_4),
  (Mochila_5, Nome_5, Mes_5, Jogo_5, Materia_5, Suco_5)
]). 

imprime_lista([]) :- write('\n\n FIM do imprime_lista \n').
imprime_lista([H|T]) :-
     write('\n......................................\n'),
     write(H), write(' : '),
     imprime_lista(T).

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
mes(setembro).
mes(janeiro). 
mes(dezembro). 
mes(maio). 

jogo(caca_palavra). 
jogo(tres_ou_mais). 
jogo(forca). 
jogo(logica). 
jogo(cubo). 

materia(geografia).
materia(matematica).
materia(biologia).
materia(historia).
materia(portugues).


suco(limao). 
suco(morango). 
suco(maracuja). 
suco(uva). 
suco(laranja). 
