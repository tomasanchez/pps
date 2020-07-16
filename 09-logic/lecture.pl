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
==============================================================================   LOGICO - Lecture 02  =========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*
    Predicados Disponibles:
*/

% Se cumple para los jugadores.
jugador(Jugador).
% Ejemplo:
% jugador(rojo).

% Relaciona un país con el continente en el que está ubicado,
ubicadoEn(Pais, Continente).
% Ejemplo:
% ubicadoEn(argentina, américaDelSur).

% Relaciona dos jugadores si son aliados.
aliados(UnJugador, OtroJugador).
% Ejemplo:
% aliados(rojo, amarillo).

% Relaciona un jugador con un país en el que tiene ejércitos.
ocupa(Jugador, País).
% Ejemplo:
% ocupa(rojo, argentina).

% Relaciona dos países si son limítrofes.
limítrofes(UnPaís, OtroPaís).
% Ejemplo:
% limítrofes(argentina, brasil).


/*
===============================================================================================================================================================================
==============================================================================  Ejercitacion    ===============================================================================
===============================================================================================================================================================================
*/


/*
    tienePresenciaEn/2: Relaciona un jugador con un continente del cual ocupa, al menos, un país.
*/
tienePresenciaEn(Jugador, Continente) :- ocupa(Jugador, Pais), ubicadoEn(Pais, Continente).

/*
    puedenAtacarse/2: Relaciona dos jugadores si uno ocupa al menos un país limítrofe a algún país ocupado por el otro.
*/
puedenAtacarse(UnJugador, OtroJugador) :- 
    ocupa(UnJugador, UnPais).
    ocupa(OtroJugador, OtroPais),
    limítrofes(UnPais, OtroPais).


/*
    sinTensiones/2: Relaciona dos jugadores que, o bien no pueden atacarse, o son aliados.
*/
sinTensiones(UnJg, OtroJg) :- aliados(UnJg, OtroJg).
sinTensiones(UnJg, OtroJg) :-
    jugador(UnJg),
    jugador(OtroJg),
    not(puedenAtacarse(UnJg, OtroJg)).

/*
    perdió/1: Se cumple para un jugador que no ocupa ningún país.
*/
perdio(Jg) :-
    jugador(Jg),
    not(ocupa(Jg, _)).

/*
    controla/2: Relaciona un jugador con un continente si ocupa todos los países del mismo.
*/
controla(UnJg, Continente) :-
    jugador(UnJg),
    ubicadoEn(_, Continente).
    forall(ubicadoEn(Pais, Continente),
    ocupa(Jugador, Pais)).

/*
    reñido/1: Se cumple para los continentes donde todos los jugadores ocupan algún país.
*/
reñido(Continente):-
    ubicadoEn(_,Continente),
    forall(jugador(Jugador), (ocupa(Jugador, Pais), ubicadoEn(Pais, Cotinente)) ).


/*
    atrincherado/1: Se cumple para los jugadores que ocupan países en un único continente.
*/
atrincherado(Jg):-
    jugador(Jg),
    ubicadoEn(_, Continente),
    forall( ocupa(Jg, Pais), ubicadoEn(Pais, Continente)).

/*
    puedeConquistar/2: Relaciona un jugador con un continente si no lo controla, pero todos los países del continente que
     le falta ocupar son limítrofes a alguno que sí ocupa y pertenecen a alguien que no es su aliado.
*/
puedeConquistar(Jg, Continente) :-
    jugador(Jg), ubicadoEn(_, Continente),
    not(controla(Jg, Continente)),
    forall( ( ubicadoEn(Pais, Continente), not(ocupa(Jg, Pais)) ), puedeAtacar(Jg, Pais) ).

/*
    Auxiliar :-  pais limitrofe a alguno que sí ocupa y pertenecen a alguien que no es su aliado
*/
puedeAtacar(Jg, PaisAtacado) :-
    ocupa(Jg, PaisPropio),
    limítrofes(PaisAtacado, PaisPropio),
    not( ( aliados(Jg, Aliado), ocupa(Aliado, PaisAtacado) ) ).
