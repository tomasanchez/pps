# [00](https://github.com/tomasanchez/pps/) - Paradigma Funcional

Durante este paradigma se trabajara con el lenguaje *Haskell*.

La guia de ejercicios con la que se guiara la catedra sera la presente en [Mumumki](https://mumuki.io/paths)

## Conceptos basicos

Este paradigma esta fuertemente orientado a describir construcciones en lugar de tratar de explicar los pasos a seguir para obtener un resultado.
Podemos pensarlo como una calculadora: consiste en modelar la misma, que en particular es extensible; uno puede programar sus propios "botones".

Funcion: es una relacion entre elementos de dos conjuntos y que cumple con **existencia** y **unicidad**. El hecho de que una funcion es una relacion implica que no es una secuencia de pasos, solo vincula el dominio con la imagen, entre los efectos de esto se encuentra la imposibilidad de pisar el valor de los parametros.
Una funcion solo servira entonces par dar un resultado; por ello es necesario conocer el dominio y su imagen.

Simetria de la igualdad: al igual que en matematicas, colocar un igual entre dos expresiones siginifica que la primera expresion es equivalente, lo mismo que la consiguiente al simbolo igual.
Por lo tanto entenderemos que se podra "reemplazar" por ese valor.

Pattern Matching: dada una cadena de *tokens* chequearle en busqueda de un patron, de manera de definir ciertos *behaviours* para determinados *inputs*

## Comenzando con Haskel

### Primer Ejemplo

```hs
nombreCompleto nombre apellido = apellido ++ ", " ++ nombre
```

Esto nos dice que las expresiones son equivalentes.

Por consola obtendriamos

```hs
> nombreCompleto "Tito" "Puente"
"Puente, Tito"
```

### Aplicacion

Las funciones por default se aplicaran

De manera infija para funciones nombradas con simbolos operarios

```hs
 > 2 * 3
 6
```

Y de manera prefija para funciones con un determinado nombre

```hs
> multiplicar 2 3
6
```

Sin embargo podemos "castear" su aplicacion de manera que

```hs
> (*) 2 3
6
> 2 `multiplicar` 3
6
```

### Pattern Matching en Haskell

Tengamos presente la funcion factorial definida como

n! = 1 * ... * (n-1) * n

En Haskell

```hs
factorial 0 = 1
factorial n = factorial ( n - 1 ) * n
```

Al igual que en la definicion formal, para n = 0 hay un valor predefinido. A esto se llama pattern matching.
