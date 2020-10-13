# 03 - Objetos

## Temas Vistos

- Colecciones
  - Listas
  - Bloques
- Igualdad
- Mutabilidad
- Identidad
- Practica

## Colecciones

De la misma manera que trabajabamos cin conjuntos en los otros modelos, pero adecuado a este nuevo paradigma.

### Listas

Al igual que en haskell, podemos observarlas como un arreglo.

```wlk
const lista = [1, 2, 3]
```

Cuando hablamos de lista ya debemos hacernos la idea de arbol binario de head y tail. Sin embargo en objetos, la consideramos una interfaz. Todo lo que podiamos realizar por fuera de la lista en haskell, en objetos estos seran metodos de la lista. Siguiendo el ejemplo anterior ejemplo:

```wlk
lista.filter(oCriterio)
```

Podemos simplificar la interfaz de lista en:

```
Lista
------
size()
head()
filter(cirteria)
map(transformation)
all(criteria)
any(criteria)
sum()

add(element)
remove(element)
forEach(operation)
...
```

Supongamos

```wlk

class bicho{
    method estaContenta() = ...
    method litrosDeLeche() = ...
    methor ordenar(){...}
}
```

Creando una coleccion de bichos...

```
> const bichos = {new bicho(), new bicho()}
> bichos.add(new bicho())
> bichos.size()
    3

> bichos.filter()
```

A diferencia de funcional, objetos necesita filtrar a partir de un objeto. Ahi es donde entran los bloques.

### Bloques

Podriamos considerarlo como el equivalente de las funciones lambdas de Haskell. Tendria un uso parecido tambien a orden superior.

```wlk
Bloque
------
apply(arge)
```

Como solucionamos nuestro filter entonces...

```wlk
object criterioEstaContenta{
    method apply(obicho) = obicho.estaContenta()
}

bichos.filter(criterioEstaContenta)
[unabichoContenta, otrabichoContenta]
```

Ahora, este metodo es bastante emborroso, donde tendriamos un monton de objetos por cada criterio.
Por eso Wollok ofrece un azucar sintactico.

```wlk
bichos.filter({ bicho => bicho.estaContenta() })
```

## Igualdad, Identidad y Mutabilidad

Supongamos

```wlk
const rosita    = new bicho();
const petunia   = new bicho();

/*No son iguales*/

const bichos = [ rosita, petunia]
const tristes = bichos.filter{bicho => !bicho.estaContenta()}

/*Suponiendo que posean los mismos elementos, Estas listas no son iguales.
Las modificanes a uno no afectara a la otra, si ambas guardan las mismas referencias*/

tristes.remove(petunia)
/*Ahora ya no son "iguales"*/

tristes.forEach{ bicho => bicho.ordeniar()}
/*Esto si tiene efecto de lado en ambas listas*/
```

Es decir, un objeto nunca es igual a otro. Vale destacar que causar efecto es extremadamente hostil.

Por mutabilidad, nos referimos a que la referencia a ese objeto no cambia, en una coleccion incluso se extiende a la referencia de sus elementos, pero si podria causar efecto en alguna coleccion.

En cuanto a la identidad, imagine esta situacion

```wlk
> bichos.add(rosita)
/*Agregamos una repiticion de Rosita*/

> bichos.size()
    3
/*Si bien no tenemos 3 bichos, tenemos 3 referencias, de las cuales 2 apuntan a la misma*/

```

## Practica

Modelar un corral de bichos que permita:

- Consultar cuantos lts de leche que podamos ordenias de bichos contentas.
- Saber si todas las bichos estan contentas.
- Ordeniar a todas las bichos contentas
- Podemos agregar cabras?

```wlk

class Vaca{
    method estaContenta() = ...
    method litrosDeLeche() = ...
    methor ordenar(){...}
}

class Corral{
    const bichos = []

    method lecheDisponible(){
        bichos.filter{bicho => bicho.estaContenta()}.sum{bicho => bicho.litrosDeLeche()}
    }

    method todasContentas() = bichos.all{bicho => bicho.estaContenta()}

    /* Cuidado con method m() = y method m(){} */
    method ordeniar(){
        bichos.forEach{ bicho =>
            if(bicho.estaContenta())
                bicho.ordenar()
        }
    }
}

class Cabra inherits Vaca{}
```
