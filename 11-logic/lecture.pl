/*
    MIT License

    Copyright (c) 2020 Tomas Sanchez

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
===============================================================================================================================================================================
==============================================================================   LOGICO - Lecture 04  =========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*

Ejercicio 1:

Estamos armando un programa para analizar los resultados de una votación realizada a nivel nacional.

Tenemos una base de conocimientos con información sobre cuántos votos sacó cada partido político en las distintas provincias del país mediante un predicado votos/3, que relaciona al partido con la provincia
 y los votos conseguidos en esa provincia.

Definir un predicado votosTotales/2 para saber cuántos votos sacó un partido a nivel nacional.

Por ejemplo:

 votosTotales(pps, Votos).
    Votos = 3200555.
 

    El predicado debe ser completamente inversible.

*/

% Votos (Partido, Provincia, Votos) - Votos del partido por provincia (Base de Datos)
votos(Partido, Provincia, Votos).

% votosTotales (Partido, Votos)
votosTotales(Partido, Votos) :-
    votos(Partido, _, _),
    findall(VotosXProvincia, votos(Partido, _, VotosXProvincia), Provincias),
    sumlist(Provincias, Votos).


/*
    Ejercicio 2:

    

    Usando el predicado votosTotales/2 del ejercicio anterior y un predicado ordenadoPorVotosObtenidos/2
    que relaciona una lista de functores cuya forma es obtuvo(Partido, Votos) con una lista con esos mismos elementos pero ordenados de mayor a menor en base a la cantidad de votos, se pide desarrollar los siguientes predicados:

    resultadoVotacion/1 que se verifique para una lista de functores con la forma obtuvo(Partido, Votos) tal que los elementos incluyan la información
    de los votos totales obtenidos por cada partido, y la misma se encuentre ordenada por los votos obtenidos.

    cargosGanados/2 que relacione a un partido con una cantidad de cargos que ganó en base al resultado de la votación sabiendo que:
        al partido que sacó más votos le corresponden 5 cargos,
        al segundo le corresponden 2 cargos,
        al tercero le corresponde 1 cargo,
        los demás partidos no ganan cargos. 


*/

% ordenadoPorVotosObtenidos/2  obtuvo(Partido, Votos)
ordenadoPorVotosObtenidos(Lista, ListaOrdenada).

% resultadoVotacion (Resultados)
%       Resultados : [obtuvo(Partido, Votos)].
resultadoVotacion(Resultados) :-
    findall(obtuvo(Partido, Votos), votosTotales(Partido, Votos), ResultadosNoOrdenados),
    ordenadoPorVotosObtenidos(ResultadosNoOrdenados, Resultados).

% cargosGanados(Partido, Cargos).
cargosGanados(Partido, 5) :-
    votosTotales(Partido, _),
    resultadoVotacion( [obtuvo(Partido, _) | _] ).
cargosGanados(Partido, 2) :-
    votosTotales(Partido, _),
    resultadoVotacion( [_, obtuvo(Partido, _) | _] ).
cargosGanados(Partido, 1) :-
    votosTotales(Partido, _),
    resultadoVotacion( [_, _, obtuvo(Partido, _)| _]).