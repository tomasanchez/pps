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
==============================================================================   LOGICO - Lecture 03  =========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*
    Ejercicio 1:

    Definir un predicado lecturaDensa/1 para saber si un material de lectura es denso:
    
        Un libro es denso si tiene al menos 200 páginas o si es de editorial Paidos.
        Por otro lado un paper es denso si la diferencia entre la cantidad de hojas y la cantidad de visitas es mayor que 100.
        Por último, una saga es densa si tiene más de cuatro libros.

    Considerar que los distintos materiales de lectura se representan con functores con esta forma:
    
    libro(Nombre, Editorial, CantidadDePaginas)
    paper(Titulo, CantidadDeHojas, CantidadDeVisitas)
    saga(Nombre, CantidadDeLibros)
*/


%lecturaDensa(Texto).

lecturaDensa(libro(_,_, CantidadDePaginas)) :- CantidadDePaginas >= 200.
lecturaDensa(libro(_,paidos,_)).
lecturaDensa(paper(_, Hojas, Visitas)) :- (Hojas - Visitas) > 100.
lecturaDensa(saga(_, Libros)) :- Libros > 4.


/*
    Ejemplos:

     lecturaDensa(saga(elSeniorDeLosAnillos,3)).
        false

    lecturaDensa(libro(elAleph,paidos,146)).
        true

    lecturaDensa(paper("Evidence for a Distant Giant Planet in the Solar System", 170, 30)).
        true

*/


/*
    Ejercicio 2:

    Usando el predicado lecturaDensa/1 definido para el ejercicio anterior, definir un predicado lectorIntenso/1 para saber si una persona prefiere la lectura intensa.
    Esto sucede cuando leyó más de un material de lectura (que podrían ser dos libros distintos, un paper y un libro, etc)
    y todo lo que leyó es denso.

    Contamos además con un predicado leyo/2 que relaciona a una persona con cada material de lectura que leyó.
*/


/*
    Base de datos:
*/
%leyo(Alguien, Texto).
leyo(nico, saga(dune,14)).
leyo(nico, libro(rebelionEnLaGranja,deBolsillo,144)).
leyo(nico, paper("No Silver Bullet: Essence and Accidents of Software Engineering", 230, 100)).
leyo(nico, paper("The relationship between design and verification", 250, 300)).

leyo(daiu, saga(fundacion,7)).
leyo(daiu, libro(elAleph,paidos,146)).

leyo(clara, paper("Evidence for a Distant Giant Planet in the Solar System", 170, 30)).
leyo(clara, paper("No Silver Bullet: Essence and Accidents of Software Engineering", 230, 100)).
leyo(clara, libro(rayuela,alfaguara,600)).
leyo(clara, saga(harryPotter,7)).

leyo(juan, libro(cosmos,planeta,362)).
leyo(juan, saga(elSeniorDeLosAnillos,3)).

leyo(flor, saga(harryPotter,7)).

%titulo(Texto).
titulo(saga(Titulo,_)) :- leyo(_, saga(Titulo,_)).
titulo(libro(Titulo,_,_)) :- leyo(_, libro(Titulo,_, _)).
titulo(paper(Titulo,_,_)) :- leyo(_, paper(Titulo, _, _)).


%lectorIntenso(Alguien).
lectorIntenso(Alguien) :- 
    leyo(Alguien, Texto),
    leyo(Alguien, OtroTexto),
    OtroTexto \= Texto,
    forall( (leyo(Alguien, NuevoTexto)), (lecturaDensa(NuevoTexto))).

