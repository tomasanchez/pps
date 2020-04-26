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


