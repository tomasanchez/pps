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
================================================================   LOGICO - PARCIAL FESTIVAL DE ROCK  =========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/



% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, ..., littoNebbia], sanIsidro).

% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(sanIsidro, 85000, 3000).

% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).

% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival 
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes: 
%     - campo
%     - plateaNumerada(Fila)
%     - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(sanIsidro, zona1, 1500).



%   1)
%itinerante/1: Se cumple para los festivales que ocurren en más de un lugar, pero con el mismo nombre y las mismas bandas en el mismo orden.
itinerante(Festival) :-
    festival(Festival, Bandas, UnLugar),
    festival(Festival, Bandas, OtroLugar),
    OtroLugar \= UnLugar.

% careta/1: Decimos que un festival es careta si no tiene campo o si es el personalFest.
careta(personalFest).
careta(Festival) :-
    festival(Festival, _, _),
    not(entradaVendida(Festival, campo)).

% nacAndPop/1: Un festival es nac&pop si no es careta y todas las bandas que tocan en él son de nacionalidad argentina y tienen popularidad mayor a 1000.
nacAndPop(Festival) :-
    festival(Festival, Bandas, _),
    not(careta(Festival)),
    forall(member(Banda, Banda), (banda(Banda, argentina, Popularidad), Popularidad > 1000)).

% sobrevendido/1: Se cumple para los festivales que vendieron más entradas que la capacidad del lugar donde se realizan.
sobrevendido(Festival) :-
    festival(Festival, _, Lugar),
    lugar(Lugar, Capacidad, _),
    findall(Entrada, entradaVendida(Festival, Entrada), Entradas),
    length(Entrada, Cantidad),
    Cantidad > Capacidad.

/*
recaudaciónTotal/2: Relaciona un festival con el total recaudado con la venta de entradas. Cada tipo de entrada se vende a un precio diferente:
   - El precio del campo es el precio base del lugar donde se realiza el festival.
   - La platea general es el precio base del lugar más el plus que se aplica a la zona. 
   - Las plateas numeradas salen el triple del precio base para las filas de atrás (>10) y 6 veces el precio base para las 10 primeras filas.
*/
recaudaciónTotal(Festival, Recaudacion) :-
    findall(Precio, (festival(Festival, _, Lugar), precioEntrada(Festival, Lugar, Precio)), Ventas),
    sumlist(Ventas, Recaudacion).


% precioEntrada/2, Relaciona un festival con el precio correspondiente
precioEntrada(Festival, Lugar, Precio) :- 
    entradaVendida(Festival, campo),
    lugar(Lugar, _, Precio).

precioEntrada(Festival, Lugar, Precio) :-
    entradaVendida(Festival, plateaGeneral(Zona)),
    lugar(Lugar, _, Base),
    plusZona(Lugar, Zona, Plus),
    Precio is PrecioBase + Plus.

precioEntrada(Festival, Lugar, Precio) :-
    lugar(Lugar, _, Base),
    entradaVendida(Festival, plateaNumerada(Fila)),
    Fila =< 10,
    Precio is Base * 6.

precioEntrada(Festival, Lugar, Precio) :-
    lugar(Lugar, _, Base),
    entradaVendida(Festival, plateaNumerada(Fila)),
    Fila > 10,
    Precio is Base * 3.

/*
    delMismoPalo/2: Relaciona dos bandas si tocaron juntas en algún recital 
    o si una de ellas tocó con una banda del mismo palo que la otra, pero más popular.
*/
delMismoPalo(UnaBanda, OtraBanda) :-
    tocoCon(UnaBanda, OtraBanda).

delMismoPalo(UnaBanda, OtraBanda) :-
    tocoCon(UnaBanda, OtraMasPopular),
    banda(OtraMasPopular, _, Popularidad3),
    banda(OtraBanda, _, Popularidad2),
    Popularidad2 < Popularidad3,
    delMismoPalo(UnaBanda, OtraMasPopular).

tocoCon(Una, Otra) :-
    festival(_, Bandas, _),
    member(Una, Bandas),
    member(Otra, Bandas),
    Una \= Otra.    

    