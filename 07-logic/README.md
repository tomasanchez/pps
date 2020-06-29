# Paradigma Logico

Durante este paradigma se trabajara con el lenguaje *Prolog*.

La guia de ejercicios con la que se guiara la catedra sera la presente en [Mumumki](https://mumuki.io/paths).

## Conceptos Basicos

Partiendo de una conceptualizacion de que las cosas o son verdad, o son mentira.

```
Socrates es Humano
Los Humanos son mortales
--------------------------
Ergo, Socrates es mortal.
```

Si dijeramos que:

> Socrates **NO** es mortal

obtendriamos una falasia, ya que definimos que Socrates es humano primero, por dedudicciones logicas *(Modus Tollens)* si Socrates no fuese mortal, no seria humano.

### Predicacados

```pl
humano(socrates).
mortal(Alguien) :- humano(Alguien).
```

Donde podemos ver dos dieferencias, uno es un **Hecho**: no tienen ningun requerimiento; **Reglas**: establece condiciones para que el *statement* sea verdadero.

Individuos o **Atomos**: por convencion en miniscula.

**Variable**: comienzan con mayuscula.

En nuestro ejemplo: socrates es un atomo, siendo la primera linea un hecho; y Alguien es una variable utilizada en una Regla.

```pl
humano(platon).
humano(aristoteles).
humano(socrates).

mortal(Alguien) :- humano(Alguien).
mortal(elGalloDeAsclepio).

maestro(socrates, platon).
maestro(platon, aristoteles).

groso(Alguien) :-
    maestro(Alguien, Uno),
    maestro(Alguien, Otro),
    Uno \= Otro
```

En nuestra consola interactiva, provando **consultas individuales**

```
?- mortal(socrates).
    true.

?- mortal(zeus).
    false.
```

*Prolog* asume, que aquello que no conoce es *false*, por eso decimos que utiliza un **Universo cerrado**. Nada en la base de conocimientos le da prolog herramientas que permiten determinar si lo consultado es cierto.

**Consultas existenciales**, revisa que cosas existen en el sistema que pueden hacer verdadera la consulta.

```
?- mortal(Alguien).
    Alguien = platon;               //clickeando ';'
    Alguien = aristoteles;
    Alguien = socrates;
    Alguien = elGalloDeAsclepio;
    false.
```

Al tener una base finita de datos, cuando se queda sin respuestas devuelve false, por defecto.


```
?- maestro(Maestro, platon).
    Maestro = socrates;
    false.

?- maestro (platon, _).
    true.

?- maestro (platon, Discipulo).
    Discipulo = aristoteles.
```

Como se observa, utilizando una variable anonima solo responderia si tiene algun alumno, mientras que pasando una variable, devuelve quienes cumplen.

### Inversibilidad

"Capacidad de ligar una variable" que tiene un predicado.

Veamos este ejemplo con una consulta existencial:

```pl
?- maestro(Maestro, Discipulo)
    Maestro = socrates,     Discipulo = platon;
    Maestro = platon,       Doscopulo = aristoteles;
    false.
```

En cambio con:

```pl
odia(platon, diogenes)
odia(diogenes, _)
```

Consultando...

```
?- odia(diogenes, platon).
    true.

?- odia(Alguien, platon).
    Alguien = diogenes.

?- odia(diogenes, Alguien).
    true.
```

Notamos, que en nuestra ultima consulta esperabamos una lista de variables, pues diogenes odia a todo el mundo.
Sin embargo, por la definicion y utilizacion de variable anonima, solo obtenemos que si, odia a alguien.

En general, todos los predicados son inverisbles, mientras no este definido con una variable anonima.

**Inversibilidad** sera tratado como el *tipado* en *Haskell*.

## Aritmetica

Sea el siguiente ejemplo:

```
% siguiente(Anterior, Siguiente)
siguiente(N, N + 1).
```

Vemos que *Prolog* nos arroja:

```
?- siguiente(41, Siguiente).
    Siguiente = 41 + 1.
```

Corrijiendo esto, si en cambio utilizamos la siguiente definicion...

```
siguiente(N, S) :- S is N + 1.
```

```
?- siguiente(41, Siguiente).
    Siguiente = 42.

?- siguiente(41, 43).
    false.

Aunque esto pareciera estar bien, si quisieramos calcular el Anterior, *Prolog* no nos entenderia.

?- siguiente(Anterior, 42).
    Arguments are not sufficiently instantiated.
```

Como vemos, hasta ahora, esta condenado a no responder el anterior; no es inversible.

Redifiniendo nuevamente:

```
siguiente(N, S) :-
    numero(N),
    S is N + 1.
```

```
?- siguiente(Anterior, 42)
    Anterior = 41.
```

*Prolog* utiliza **back tracking**, va a ir generando los numeros hasta que satisfaga ``` S is N + 1 ```

## Practica

```
% amigo(Uno, Otro)
amigo(nico, fernando).
amigo(axel, Persona) :- amigo (Persona, nico).
amigo(alf, _).

% id(Algo, LoMismo)
id(X, X).

% mayorDeEdad(Persona)
mayorDeEdad(Persona):-
    edad(Persona, Edad),
    Edad > 18.

```

```
?- id(julia, Id).
    Id = julia.

?- id(Id, juia).
    Id = julia.
```

Dado el predicado inversible padre/2, d efinir los predicados abuelo/2, hermano/2 y ancestro/2.

```
% padre(Padre, Hijo)
padre(abraham, homero).
padre(homero, bart).

% abuelo(Abuelo, Nieto)
abuelo(abuelo, Nieto):-
    padre(Abuelo, Padre),
    padre(Padre, Nieto).

% hermano(Uno, Otro)
hermano (Uno, otro) :-
    padre(Padre, Uno),
    padre(Padre, Otro),
    Otro \= Uno.

% ancestro (Ancestro, Descendiente)
ancestro(Ancestro, Descendiente) :- padre(Ancestro, Descendiente).
ancestro(Ancestro, Descendiente) :-
    padre(Ancestro, Alguien),
    ancestro(Alguien, Descendiente).
```