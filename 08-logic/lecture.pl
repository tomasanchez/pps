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
==============================================================================   LOGICO - Lecture 01  =========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
:- dynamic forall/1.

/*
    Ejercicio 1:

    Continuando con la problemática de los gustos de comidas, queremos determinar cuáles son las comidas que le gustan a Andrea.

    Sabemos que a Andrea le gustan todas las cosas que le gustan a Luis, excepto aquellas que también le gustan a Jose.
    Además a Andrea le gustan las achuras.

    Ya tenemos en nuestra base de conocimientos un predicado leGusta/2 que relaciona una persona con una comida que le gusta.
    Se pide extenderlo de forma conveniente para poder consultar los gustos de Andrea.

*/

% leGusta(Alguien, Comida).
leGusta(luis, asado).
leGusta(luis, pizza).
leGusta(luis, lomoAlChampignion).
leGusta(luis, revueltoGramajo).
leGusta(jose, pizza).
leGusta(jose, ensalada).
leGusta(jose, revueltoGramajo).
leGusta(andrea, achuras).
leGusta(andrea, Comida) :- leGusta(luis,Comida), not(leGusta(jose,Comida)).
leGusta(pepe, pizza).
leGusta(pipo, pizza).
leGusta(tito, pizza).
leGusta(toto, pizza).
leGusta(tato, pizza).
leGusta(pepe, revueltoGramajo).
leGusta(pepe, hamburguesa).
leGusta(pipo, ensalada).
leGusta(tito, hamburguesa).
leGusta(tito, tresEmpanadas).
leGusta(toto, papasFritas).
leGusta(tato, papasFritas).
leGusta(tito, papasFritas).
leGusta(pepe, papasFritas).
leGusta(pipo, papasFritas).

/*
    Ejercicio 2:

    Nuevamente tenemos en nuestra base de conocimientos información sobre los precios de las comidas del menú de un bar
    (mediante un predicado precio/2) y los gustos de las personas (mediante un predicado leGusta/2).

    Definir los siguientes predicados:

        masBarata/2 que relaciona dos comidas si la primera es más barata que la segunda.

        comidaPopular/1 que se cumple para una comida si le gusta a todas las personas o si
        es la más barata de todas las comidas del menú.

*/
precio(asado,450).
precio(hamburguesa,350).
precio(papasFritas,220).
precio(ensalada,190).
precio(revueltoGramajo, 220).
precio(tresEmpanadas, 120).
precio(pizza, 250).

masBarata(Comida, OtraComida) :- precio(Comida, Precio1), precio(OtraComida,  Precio2), Precio1 < Precio2.

comidaPopular(UnaComida) :- precio(UnaComida, _), forall((precio(Comida, _),  UnaComida \= Comida), (masBarata(UnaComida, Comida))).
comidaPopular(UnaComida) :- precio(UnaComida, _), forall(leGusta(Alguien, _), leGusta(Alguien, UnaComida)).