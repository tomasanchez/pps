# 01 - Paradigma Logico

## Orden Superior

Supongamos el siguiente ejemplo:

```prolog
% habitat(Animal, Bioma).
habitat(jirafa, sabana).
habitat(tigre, sabana).
habitat(tigre, bosque).
```

Podriamos hacer las siguientes consultas:

```prolog
?- habitat(tigre, Bioma).
    Bioma = sabana;
    Bioma = bosque.

?- habitat(Animal, sabana).
    Animal = jirafa;
    Animal = tigre;
```

Si quisiaramos desarrollar restricciones

```prolog
% acuatico(Animal).
acuatico(Animal) :- habitat(Animal, mar).
```

Realizando consultas...

```prolog
?- acuatico(tiburon).
    true.

?- acuatico(jirafa).
    false.

% A pesar de no definir que jirafa no vive en el mar, prolog asume que es falso
```

### Negacion

Ahora, si quisieramos saber que un animal es terrestre, simplemente podriamos decir que son aquellos que no viven en el mar.

```prolog
%terrestre(Animal).

terrestre(Animal) :- not(habitat(Animal, mar)).
```

En nuestro *prolog*, la negacion es una funcion de **Orden Superior**, ya que recibe una consulta como parametro; otro predicado.

Dada la siguiente consulta

```prolog
?- terresetre(Animal).
    false.
```

Por que obtenemos este resultado?

La variable animal no esta ligada a la consulta de habitat, sino a la consulta *not*, que nos devolvera *true* o *false*.
Por lo que decimos, que el *not* no es inversible, a menos que lo liguemos la vairable previamente a su uso en el el predicado *not* antes.

*Prolog* esta consultando si es cierto que "no hay animales que viven en el mar".

Para ello:

```prolog
terrestre(Animal) :-
    animal(Animal),
    not(habitat(Animal, mar)).
```

### Cuantificador Universal

Veamos la siguiente declaracion:

```prolog
%templado(Bioma).
%friolento(Animal), si el animal habita unicamente biomas templados.
friolento(Animal) :-
    habitat(Animal, Bioma), templado(Bioma).
```

El problema con esto es que si encontrara un caso que cumple que es templado devolveria true.

Arreglando este inconveniente, *prolog* provee el cuantificador *for all*.

```prolog
forall(Universo, Condicion).
```

```prolog
friolento(Animal) :-
    forall(habitat(Animal, Bioma), templado(Bioma)).
```

Veamos la siguiente consulta:

```prolog
?- fiolento(foca)
    false.
?- friolento(jirafa).
    true.
?- friolento(unicornio).
    true.
% Pero los unicornios no viven en ningun bioma
```

Un nuevo inconveniente es que si no existe el universo, todas las condiciones siempre se cumpliran.

Nuevamente, al hacer la siguiente modificacion

```prolog
friolento(Animal) :-
    animal(Animal).
    forall(habitat(Animal, Bioma), templado(Bioma)).
```

Se solucionaria este inconveniente.

## Not vs Forall

Se establece una equivalencia entre ambos.

Veamos el siguiente ejemplo

```prolog
% "Todos los animales son friolentos".
forall(animal(X), friolento(X)).

   % es lo mismo que decir que:

% "No hay ningun animal que no sea friolento"
not((Animal, not(friolento(X))))
```

Notese los parentesis, importante notar que *not* es de aridad uno.

```prolog
% No todos los animales son friolentos
not(forall(animal(X), friolento(X)))

% es lo mismo que

% Existe animales que no son friolentos
animal(X), not(friolento(X)).
```

Y finalmente

```prolog
% Ningun animal es friolento
forall(animal(X), not( friolento(X) ) ).

```

## Practica del dia

```prolog
% hostil(Animal, Bioma): relaciona los animales que se comen al animal en cuestion en un bioma determinado
hostil(Animal, Bioma) :-
    animal(Animal),
    habitat(_, Bioma),
    forall(habitat(OtroAnimal, Bioma), Bioma),
    come(OtroAnimal, Animal).

% Importante ligar por separado para no cambiar el significado.

% Usar habitat(Animal, Bioma) para ligar ambos, no seria correcto, ya que solo liga al Animal a Ese Bioma.

% terrible(Animal, Bioma).
terrible(Animal, Bioma) :-
    animal(Animal),
    habitat(_, Bioma),
    forall(come(OtroAnimal, Animal), Animal),
    habitat(OtroAnimal, Bioma).

%compatibles(UnAnimal, OtroAnimal).
compatibles(UnAnimal, OtroAnimal) :-
    animal(UnAnimal),
    animal(OtroAnimal),
    not(come(UnAnimal, OtroAnimal)),
    not(come(OtroAnimal, UnAnimal)).

%adaptable(Animal): si habita en todos los biomas
adaptable(Animal) :-
    animal(Animal),
    forall(habitat(_,Bioma), habitat(Animal, Bioma)).
% Estaria mal ligar Bioma antes del forall ya que consultaria si todos los biomas son el mismo bioma.


%raro(Animal). Si vive en un solo animal.
raro(Animal) :-
    habitat(Animal, Bioma),
    not((habitat(Animal, OtroBioma), Bioma\= OtroBioma)).

%dominante(Animal). si se come a todos los demas de un bioma.
dominante(Animal) :-
    habitat(Animal, Bioma),
    forall( (habitat(Otro, Bioma), Otro \= Animal), come(Animal, Otro)).
```
