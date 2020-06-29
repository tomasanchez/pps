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
==============================================================================   LOGICO - Lecture 00  =========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/



/*  Ejercicio 1:
    Cinco amigos deciden juntarse a comer en un bar del que se sabe cuáles son las comidas que ofrece y cuánto sale cada una de ellas:*/

        precio(asado,450).
        precio(hamburguesa,350).
        precio(papasFritas,220).
        precio(ensalada,190).

        tieneCarne(asado).
        tieneCarne(hamburguesa).

/*Desarrollar un predicado leGusta/2 que relacione a cada amigo con cada comida de su agrado de las que están en el bar sabiendo que:

    A Juan y Gabriela les gusta el asado.
    A Soledad le gustan las papas fritas y también las comidas que tienen carne y salen menos de $400.
    A Celeste le gusta todo lo que el bar ofrece.
    Carlos tiene problemas con el dueño del bar, por eso no le gusta nada de lo que ofrece. 

Por ejemplo, esta consulta debería ser cierta:

 leGusta(celeste, hamburguesa).
true
 

Además el predicado leGusta/2 debería ser totalmente inversible.

    Tener en cuenta que si se agregaran otras comidas o cambiaran los precios del bar, el programa tiene que seguir funcionando correctamente en base a lo que se describió anteriormente.*/


% Resolucion:

leGusta(juan, asado).
leGusta(gabriela, asado).
leGusta(soledad, papasFritas).
leGusta(soledad, Comida) :- tieneCarne(Comida), saleMenosDe400(Comida).
leGusta(celeste, Comida) :- precio(Comida, _).

saleMenosDe400(Comida) :- precio(Comida, Precio), Precio < 400.


/*  Ejercicio 2:
    Nuevamente tenemos en nuestra base de conocimientos información sobre los precios de las comidas del menú del
    bar mediante el predicado precio/2, y se agrega información relativa a cuál es el menú del día mediante un predicado menuDelDia/1.   
*/

precio(asado,450).
precio(hamburguesa,350).
precio(papasFritas,220).
precio(ensalada,190).

menuDelDia(ensalada).

/*
    Se pide desarrollar un predicado estaCaro/1 que se verifique para una comida si su precio es por lo menos el doble del menú del día.

    Al igual que para el ejercicio anterior, se espera que el predicado estaCaro/1 sea inversible, y si se agregaran otras comidas,
    se cambiara el menú del día, o cambiaran los precios del bar, el programa tiene que seguir funcionando correctamente
*/

% Resolucion:

estaCaro(Comida) :- precio(Comida, Precio), precioAlto(Precio).

precioAlto(Precio) :- menuDelDia(Comida), precio(Comida, Base), 2 * Base < Precio, Base \= Precio.