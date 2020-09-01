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
================================================================   LOGICO - PARCIAL HOGWARTS    ===============================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*
    Las Casas de Hogwarts - 2020

    En Hogwarts, el colegio de magia y hechicería, hay 4 casas en las cuales los nuevos alumnos se distribuyen ni bien ingresan.
    Cada año estas casas compiten entre ellas para consagrarse la ganadora de la copa.

*/

/*
===============================================================================================================================================================================
================================================================   PARTE I - SOMBRERO SELECCIONADOR ===========================================================================
===============================================================================================================================================================================
*/

/*
    Para determinar en qué casa queda una persona cuando ingresa a Hogwarts, el Sombrero Seleccionador tiene en cuenta el carácter de la persona, lo que prefiere y en algunos casos su status de sangre.
    Tenemos que registrar en nuestra base de conocimientos qué características tienen los distintos magos que ingresaron a Hogwarts, el status de sangre que tiene cada mago y en qué casa odiaría quedar.
    Actualmente sabemos que:
        Harry es sangre mestiza, y se caracteriza por ser corajudo, amistoso, orgulloso e inteligente. Odiaría que el sombrero lo mande a Slytherin.
        Draco es sangre pura, y se caracteriza por ser inteligente y orgulloso, pero no es corajudo ni amistoso. Odiaría que el sombrero lo mande a Hufflepuff.
        Hermione es sangre impura, y se caracteriza por ser inteligente, orgullosa y responsable. No hay ninguna casa a la que odiaría ir.
*/

%coraje(Alguien).
coraje(harry).

%amistoso(Alguien).
amistoso(harry).

%orgulloso(Alguien).
orgulloso(harry).
orgulloso(draco).
orgulloso(hermione).

%responsable(Alguien).
responsable(hermione).

%inteligente(Alguien).
inteligente(draco).
inteligente(hermione).
inteligente(harry).

%sangre (Alguien, Sangre).
sangre(harry, mestiza).
sangre(hermione, impura).
sangre(draco, pura).

%odia(Alguien, Casa).
odia(harry, slytherin).
odia(draco, hufflepuff).


/*
    Además nos interesa saber cuáles son las características principales que el sombrero tiene en cuenta para elegir la casa más apropiada:
        Para Gryffindor, lo más importante es tener coraje.
        Para Slytherin, lo más importante es el orgullo y la inteligencia.
        Para Ravenclaw, lo más importante es la inteligencia y la responsabilidad.
        Para Hufflepuff, lo más importante es ser amistoso.
*/

%casa(Casa).
casa(slytherin).
casa(gryffindor).
casa(ravenclaw).
casa(hufflepuff).


/*
    Se pide:

    Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso de 
    Slytherin, que no permite entrar a magos de sangre impura.
*/

%admite(Casa, Alguien).
admite(slytherin, Alguien) :- sangre(Alguien, Sangre), Sangre \= impura.
admite(Casa, Alguien) :- casa(Casa), sangre(Alguien, _), Casa \= slytherin.

/*
    Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus características incluyen todo lo que se busca para los integrantes de esa casa,
     independientemente de si la casa le permite la entrada.
*/
%apropiado(Alguien, Casa).
apropiado(Alguien, slytherin) :- orgulloso(Alguien), inteligente(Alguien).
apropiado(Alguien, hufflepuff) :- amistoso(Alguien).
apropiadao(Alguien, ravenclaw) :- inteligente(Alguien), responsable(Alguien).
apropiado(Alguien, gryffindor) :- coraje(Alguien).

/*
    Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa, la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. 
    Además Hermione puede quedar seleccionada en Gryffindor, porque al parecer encontró una forma de hackear al sombrero.
*/

%seleccionado(Alguien, Casa).
seleccionado(Alguien, Casa) :-
    admite(Casa, Alguien), apropiado(Alguien, Casa),
    not(odia(Alguien, Casa)).
seleccionado(hermione, gryffindor).

/*
    Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se caracterizan por ser amistosos1
     y cada uno podría estar en la misma casa que el siguiente.
    No hace falta que sea inversible, se consultará de forma individual.
*/
cadenaDeAmistades(Magos):- 
    findall(Alguien, (amistoso(Alguien), amistoso(Otro), podriaEstarMismaCasa(Alguien, Otro)), Magos).

%(Aux)podriaEstarMismaCasa(Algiuien, Otro).
podriaEstarMismaCasa(Alguien, Otro) :- seleccionado(Alguien, Casa), seleccionado(Otro, Casa), Alguien \= Otro.

/*
===============================================================================================================================================================================
================================================================   PARTE II - COPA DE LAS CASAS ===============================================================================
===============================================================================================================================================================================
*/

/*
    A lo largo del año los alumnos pueden ganar o perder puntos para su casa en base a las buenas y malas acciones realizadas, 
     y cuando termina el año se anuncia el ganador de la copa.
    Sobre las acciones que impactan al puntaje actualmente tenemos la siguiente información:
        - Malas Acciones: son andar de noche fuera de la cama (que resta 50 puntos) o ir a lugares prohibidos. 
            La cantidad de puntos que se resta por ir a un lugar prohibido se indicará para cada lugar. 
            Ir a un lugar que no está prohibido no afecta al puntaje.
        - Buenas Acciones: son reconocidas por los profesores y prefectos individualmente y el puntaje se indicará para cada acción premiada.

*/

%realizoAccion(Alguien, accion(Accion, Puntos)).
realizoAccion(harry, accion(estuvo(fueraDeCama), -50)).
realizoAccion(harry, accion(estuvo(bosque), -50)).
realizoAccion(harry, accion(vencioVoldemort, 60)).
realizoAccion(hermione, accion(estuvo(seccionRestringidaBiblioteca), -10)).
realizoAccion(hermione, accion(estuvo(tercerPiso), -75)).
realizoAccion(hermione, accion(salvoAmigos, 50)).
realizoAccion(draco, accion(estuvo(mazmorras), 0)).
realizoAccion(ron, accion(ganoAjedrez, 50)).
realizoAcccion(Alguien, accion(pregunta(Dificultad, snape), Puntos)) :- 
    esDe(Alguien, _),
    Puntos is Dificultad / 2.
realizoAccion(Alguien, accion(pregunta(Dificultad, Profesor), Puntos)) :-
    esDe(Alguien, _),
    Profesor \= snape,
    Puntos is Dificultad.

/*
    También sabemos que los siguientes lugares están prohibidos:
*/

%lugarProhibido(Lugar, Puntos).
lugarProhibido(bosque, -50).
lugarProhibido(seccionRestringidaBiblioteca, -10).
lugarProhibido(tercerPiso, -75).

/*
    También sabemos en qué casa quedó seleccionado efectivamente cada alumno mediante el predicado esDe/2 que relaciona a la persona con su casa, por ejemplo:
*/
%esDe(Alguien, Casa).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).


/*
    Se pide incorporar a la base de conocimiento la información sobre las acciones realizadas y agregar la siguiente lógica a nuestro programa:

    a- Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo).
    b- Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.

*/

%buenAlumno(Alguien).
buenAlumno(Alguien) :-
    realizoAccion(Alguien, _),
    forall(realizoAccion(Alguien, Accion), not(malaAccion(Accion))).

%malaAccion(Accion)
malaAccion(accion(Accion, Puntos)) :- Puntos < 0.

accionRecurrente(Accion) :-
    realizoAccion(Alguien, Accion),
    realizoAccion(Otro, Accion),
    Alguien \= Otro.

/*
    Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.
*/

puntajeTotal(Casa, Total) :-
    casa(Casa),
    findall(Puntaje, ( esDe(Alguien, Casa), realizoAccion(Alguien, accion(_, Puntaje)) ), Puntos),
    sumlist(Puntos, Total).


/*
    Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor de puntos que todas las otras.
*/
ganadora(CasaGanadora) :-
    puntajeTotal(CasaGanadora,  TotalGanador),
    forall(casa(Casa), (Casa \= CasaGanadora, puntajeTotal(Casa, Total), TotalGanador > Total) ).

/*
    Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. 
    La información que nos interesa de las respuestas en clase son: cuál fue la pregunta, cuál es la dificultad de la pregunta y qué profesor la hizo.

    Por ejemplo, sabemos que Hermione respondió a la pregunta de dónde se encuentra un Bezoar, de dificultad 20, realizada por el profesor Snape, y cómo hacer levitar una pluma, de dificultad 25, realizada por el profesor Flitwick.

    Modificar lo que sea necesario para que este agregado funcione con lo desarrollado hasta ahora, teniendo en cuenta que los puntos que se otorgan equivalen a la dificultad de la pregunta, 
        a menos que la haya hecho Snape, que da la mitad de puntos en relación a la dificultad de la pregunta.
*/

/*
    Al principio plantee realiceAccion(Alguien, accion(Accion, Puntos)),
        esto facilito la modificacion agregando:
        accion(pregunta(Dificultad, Profesor), Puntos)
    Por estetica agregue luego un functor estuvo(Lugar).
*/