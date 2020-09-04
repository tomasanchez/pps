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
================================================================   LOGICO - PARCIAL INCENDIOS  ================================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*
    Dados los recientes incendios en el país, organizaciones ambientalistas nos pidieron que desarrollemos un sistema en Prolog para analizar la información disponible.

    Contamos con una base de conocimiento inicial donde se detallan los datos recolectados de los distintos focos de incendio.

    El predicado foco/2 relaciona un lugar con la cantidad de hectáreas afectadas. 
    Los distintos tipos de lugares están representados con distintos functores, que contienen el nombre del lugar y su población:
        ->  ciudad(Nombre, Población)
        ->  pueblo(Nombre, Población)
        ->  campo(Nombre)

    Noten que los functores campo/1 no incluyen la población, porque el número es muy bajo y se considera despreciable.
*/
%foco(Lugar, HectareasAfectadas).
foco(ciudad(rosario, 500), 20).
foco(pueblo(cosquin, 20), 50).
foco(campo(km607), 300).
foco(campo(km605), 20).
/*
    También contamos con información acerca de la proximidad de los lugares,
     representada con el predicado cercanos/2, que relaciona dos nombres de lugares si son cercanos entre ellos.
*/

cercanos(caba, laPlata).
cercanos(baires, santaFe).

/*
    Por último, también contamos con un predicado provincia/2 que relaciona el nombre de un lugar(sea o no un foco de incendio)
      con el de la provincia donde queda.
*/

provincia(rosario, santaFe).
provincia(cosquin, cordoba).
provincia(km605, baires).

/*
    Se pide implementar los siguientes predicados de forma tal de que sean completamente inversibles,
     tratando de evitar las repeticiones de lógica y utilizando los conceptos del paradigma lógico aprendidos durante la cursada:
*/

% focosparecidos(Lugar, OtroLugar).
% Dos lugares son focos parecidos si no son el mismo lugar y las cantidades de hectáreas afectadas son iguales.
focosParecidos(UnLugar, OtroLugar):-
    foco(UnLugar, Hectareas1),
    foco(OtroLugar, Hectareas2),
    UnLugar \= OtroLugar,
    Hectareas1 = Hectareas2.


% focoGrave(Lugar)
% Un foco es grave si tiene más de 40 hectáreas, si es una ciudad o si su población es mayor a 200.
focoGrave(Lugar):-
    foco(Lugar, Hectareas),
    Hectareas > 40.
focoGrave(ciudad(Nombre, Poblacion)):-
    foco(ciudad(Nombre, Poblacion), _).
focoGrave(pueblo(Nombre, Poblacion)):-
    foco(pueblo(Nombre, Poblacion), _),
    Poblacion > 200.

% buenPronóstico(Lugar)
% Se cumple para un foco que no es grave, y no es parecido a ningún foco grave.
buenPronostico(Lugar) :-
    foco(Lugar, _),
    not(focoGrave(Lugar)),
    focoGrave(OtroLugar),
    not(focosParecidos(Lugar, OtroLugar)).

% provinciaComprometida/1
% Una provincia está comprometida  si tiene más de 3 focos de incendio.
provinciaComprometida(Provincia) :-
    provincia(_, Provincia),
    findall(Lugar, lugaresDeProvinciaConFoco(Lugar,Provincia), Focos),
    length(Focos, Cantidad),
    Cantidad > 3.

%Relaciona un lugar con su Provincia
lugaresDeProvinciaConFoco(Lugar, Provincia) :-
    nombre(Lugar, Nombre),
    provincia(Nombre, Provincia).

% nombre(Lugar, Nombre)
nombre(ciudad(Lugar,_), Nombre) :- foco(ciudad(Nombre, _), _), Nombre = Lugar.
nombre(pueblo(Lugar, _), Nombre) :- foco(pueblo(Nombre, _), _), Nombre = Lugar.
nombre(campo(Lugar), Nombre) :- foco(campo(Nombre), _), Nombre = Lugar.

% provinciaAlHorno/1
% Una provincia está al horno si todos los focos en ella son focos graves o si no tiene ningún lugar que no sea un foco.
provinciaAlHorno(Provincia) :-
    provincia(_, Provincia),
    forall(lugaresDeProvinciaConFoco(Lugar, Provincia), focoGrave(Lugar)).
provinciaAlHorno(Provincia) :-
    provincia(_,  Provincia),
    forall(provincia(Nombre, Provincia), nombre(_, Nombre)).


% lugarEnRiesgo/1
% Un lugar está en riesgo si es un foco de incendio que no tiene buen pronóstico o si está cerca de otro lugar en riesgo.
lugarEnRiesgo(Lugar) :-
    foco(Lugar, _),
    not(buenPronostico(Lugar)).
lugarEnRiesgo(Lugar) :-
    foco(Lugar, _),
    nombre(Lugar, Nombre1),
    foco(OtroLugar, _),
    OtroLugar \= Lugar,
    nombre(OtroLugar, Nombre2),
    cercanos(Nombre1, Nombre2),
    lugarEnRiesgo(OtroLugar).


/*
    BaseDeDatos.
*/
    
