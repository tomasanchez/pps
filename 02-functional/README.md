# 02 - Funcional

## Composición

Podemos traer el concepto matemático, dados tres conjuntos `A, B, C`  y poseo las función `g: A -> B` y `f: B -> C`, podemos establecer `f∘g: A -> C`. Donde `(f∘g) (x) == f ( g(x) )`.

Una traducción en haskell:

```hs
 g :: a -> b
 f :: b -> c
 f . g :: a -> c
```

Esto nos permite despreocuparnos de como se "cablean" las funciones, entre si, sino  que **a cada una le llegue el tipo de dato que necesita**, su implementación se asemeja a una **black box**. Por lo que la imágen de una debe pertenecer al dominio de la otra. Véase como no puede usarse `g . f`. Otra consideración es que la misma composición es una función.

Véamos el siguiente ejemplo de alumnos y notas:

```hs
nota            :: Alumno   -> Int
esMenorAOcho    :: Int      -> Bool
not             :: Bool     -> Bool
```

Con esto podríamos construir la siguiente función, dónde no necesitaríamos utilizar el concepto visto.

```hs
promociona alumno = not (esMenorAOhcho (nota alumno))
```

Véase como en la siguiente implementación
Este implementación está bien, no tiene nada de malo, pero si está bueno marcar que cuanto más pasos queremos agregar, mas paréntesis habría que agregar, donde se perdería legibilidad. Y ahí es dónde la anidación hace agua.

```hs
promociona alumno = (not . esMenorAOcho . nota) alumno
```

Es muy interesante esta aplicación y hasta lo visto, puede que no se justifique este agregado de complejidad, pero en realidad el cierre de la utilidad de composición se podrán observar en el siguiente resumen.

Nótese que la aplicación de las funciones es a partir de la que esta más cerca del parámetro, en este caso `nota`. Y cabe destacar los paréntesis, dónde de no encontrarse, cambiaría totalmente el significado de la expresión: la precedencia, resaltada entre `()` convertiría a: `not . esMenorAOcho . (nota alumno)`, `nota alumno` devolvería un entero y no una función, entonces no podría componerse. Por lo cual son bastante importantes.

Esta forma de plantearlo es más linda, ya que se aplican los conceptos del paradigma: se arma una secuencia de transformaciones, pudiendo modelar respondiendo a preguntas como **"dónde estoy? a dónde quiere llegar?"** y luego es cuestión de encontrar las funciones apropiadas que permitan armar el "camino". Componer permite aplicar funciones sin aplicarlas, lo cual permite delegar para poder simplificar el problema.

## Currificación

Tomemos el tipo de la funcion de composición:

```hs
(.) :: (b -> c) -> ( a -> b) -> (a -> c)
```

Vemos que solo podemos pasar funciones que solo toman un parametro, lo cual parece bastante restrictivo: muchas de las funciones que normalmente utilizamos utilizan un solo parametro.

Por suerte este no es el caso, y en haskell todas las funciones pasan por un proceso denominado currifación. Esto consiste en la simplificacion de una función que resibe varios parametros, en una que recibe un único parámetro y devuelve una función. Asi podríamos ver que: 

```hs
f :: a -> b -> c -> d
```

Recibe al parámetro `a` y retorna `b -> c -> d`, la cual a su vez toma `b` y devulve `c -> d`. Estando sucediendo algo como:

```hs
f :: a -> ( b -> (c -> d) )
```

Y esto es automático, por lo cual en realidad nunca pasamos más de un parametro, sino aplicando primero uno y lo que devuelve otra funcion a la cual se le aplica el otro "parametro".

## Aplicación Parcial

Por aplicación parcial se entiende a la aplicación de una función, pero suministrando menos parámetros que los que esta requiere. El resultado de aplicar parcialmente una función es otra función que espera menos parámetros que la original, ya que puede realizar reemplazos en su definición por expresiones o valores concretos. La aplicación parcial es muy útil para componer funciones y para parametrizar funciones de Orden Superior. Veamos algunos ejemplos:

```hs
    take 3
    (+1)
    max "hola"
```

```hs
(&&) :: Bool -> Bool -> Bool
```

Ahora sabemos que no recibe dos `Booleans` sino uno solo y devuelve una función que espera otro más. Por lo cual puedo consultar lo siguiente:

```hs
(&&) unBool :: Bool -> Bool
```

Pareciera que estas funciones tienen "memoria". Ademas permite establecer que tipo esperar, por ejemplo

```hs
(>) :: Ord a => a -> a -> Bool
```

Si aplicaramos un `Int`, devolveria una función que esperase otro `Int` y devuelva el `Bool`.

```hs
(>) unInt :: Int -> Bool
```

Donde se termina la ambiguedad.

## Aplicación parcial - Segundo Parametro

En ocasiones sucede que no podemos aplicar parcialmente una función ya que el valor que le queremos pasar no es el primero que espera sino otro, por ejemplo si quiero saber si un nombre es exótico, que se cumple si tiene x, k, q o w, no sería correcto intentar hacer:

```hs
esExotico nombre = any (elem "XKQWxkqw") nombre
```

Ya que “xkqw” que es la lista en la cual quiero verificar si se encuentra uno de los caracteres del nombre, no es correcto tratar de aplicárselo a elem porque debería ser el segundo parámetro, no el primero. De hecho esa función va a compilar correctamente, pero no va a funcionar como esperamos, ya que al intentar usarla de esta forma:

```hs
> esExotico "Xiomara"
```

Nosotros esperaríamos que nos diga True, pero vamos a tener un error de tipos:

```hs
Couldn't match expected type `[ [Char] ]' with actual type `Char'
```

Esto sucede porque si a elem le aplicamos un String (equivalente a `[Char]`), el resultado va a ser una función de tipo `[ [Char] ] -> Bool`.

### Como Podemos Resolverlo?

#### Expresiones Lambda

```hs
esExotico nombre = any (\letra -> elem letra "XKQWxkqw") nombre
```

#### Notación Infija

```hs
> 10 `mod` 2
```

#### Usando Flip

En Haskell existe una función de Orden Superior llamada `flip` cuyo tipo es `(a -> b -> c) -> b -> a -> c`, y sirve justamente para resolver esta clase de problemas ya que lo que hace es aplicar la función que recibe con los parámetros en el orden inverso al que le llegan. Podríamos usar flip parcialmente aplicada para lograr nuestro objetivo.

```hs
esExotico nombre = any (flip elem "XKQWxkqw") nombre
```
