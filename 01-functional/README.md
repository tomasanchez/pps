# [01](https://github.com/tomasanchez/pps/) - Paradigma Funcional

## Guardas

Podemos considerar las guardas como el *"if statement"* de *Haskell*. A su vez, puede ser observado como un *pattern matching*, donde en vez de que sea exactamente un patron, se verifica si se cumple una condicion.

Como hacemos esto?

```hs
myFuncition condition | condition{-?-} = {-Behaviour-}
                      | otherwise = {-Behaviour 2-}
```

Ahora supongamos que queremos definir una función que nos indica según una edad, la cantidad de horas de sueño recomendable, que la describiremos (arbitrariamente) de la siguiente forma:

> Para menores de 5 -> 11 horas.
> 
> Para mayores de 30 -> 7 horas.
> 
> Para cualquier otra edad -> 8 horas.

```hs
horasSuenioRecomendadoEnEdad edad
  | edad < 5 = 11
  | edad > 30 = 7
  | otherwise = 8
```

Vemos que para cada caso se verifica si cumple, sino continua, de no cumplirse las dos primeras, tiene un escape *"default"* gracias al *"otherwise"*

### Error comun

No confundir guardas con funciones booleanas

```hs
esMayorDeEdad edad | edad > 18 = True
                   | otherwise =  False
```

Esto es innecesario, ya que por definicion `edad > 18` devuelve un booleano.

```hs
esMayorDeEdad edad = edad > 18
```

## Data

Un data es una estructura compleja, que nos permite definir tipos compuestos a partir de otros tipos.

```hs
data <nombre_del_tipo> = <constructor> <tipo_de_los_campos>
```

Ejemplo:

```hs
data Alumno = Alu String String Int
    {-Constructor Nomre Legajo Nota -}
```

Si lo chequearamos en la consola:

```
> :t Alu
Alu :: String -> String -> Int -> Alumno
```

Vemos que *Alu* es una funcion que dado dos *Strings* y un *Int* nos instancia un *Alumno*.

```
> Alu "Jose" "199040-5" 8
No instance for (Show Cliente) arising from use of a `print`
```

Si bien, se instancio un Alumno con esos datos, haskell no sabe como mostrarlo por la consola.

```hs
data Alumno = Alu String String Int deriving (Show, Eq)
            {-Lo podemos arreglar con este agregado-}
```

Sin meternos en mucho detalle, estas dos *type classes*, *Show* y *Eq* nos permiten, mostrar por pantalla y comparar (igualacion) respectivamente.

Accediendo a las estructuras

```hs
data Alumno = Alu String String Int deriving (Show, Eq)

nota :: Alumno -> Int
nota ( Alu elNombre elLegajo laNota) = laNota
```

Vemos que estamos instanciando a un alumno dentro de una funcion, los parentisis marcan que se trata de un solo parametro.

### Variable Anonima

Como vemos no utilizamos las variables *elNombre* y *elLegajo*. Al ser ignoradas, podemos escribirlo como:

```hs
nota (Alu _ _ laNota) = laNota

legajo (Alu _ elLegajo _) = elLegajo

nombre (Alu elNombre _ _) = elNombre

{-Nota: la variable anonima "_" solo puede utilizarse a izquierda.-}
```

Notese que estas funciones de acceso son mas eficientes a la larga, que *pattern matching*.

Moraleja: Al definir un data, debemos definir funciones de acceso.

## Chiches

### Type Alias

Consideremos el ejemplo anterior

```hs
data Alumno = Alu String String Int deriving (Show, Eq)
```

Como vimos anterior mente, al pedirle el tipado a Haskell nos tira

```
> :t Alu
Alu :: String -> String -> Int -> Alumno
```

Esto resulta poco intuitivo, por ello, el lenguaje nos permite los *type alias*

```hs
type Nombre = String
type Legajo = String
type Nota = Int
```

Luego podemos reemplazar:

```hs
data Alumno = Alu Nombre Legajo Nota deriving (Show, Eq)
```

Ahora, volviendole a pedir el tipado, es un poco mas gentil, arrojando:

```
> :t Alu
Alu :: Nombre -> Legajo -> Nota -> Alumno
```

### Syntactic Sugar

Cuando definimos un data, quedamos en definir las funciones de acceso por lo que deberiamos codear

```hs
data Alumno = Alu Nombre Legajo Nota deriving (Show, Eq)

nombre :: Alumno -> Nombre
nombre (Alu elNombre _ _) = elNombre

legajo :: Alumno -> Legajo
legajo (Alu _ elLegajo _) = elLegajo

nota :: Alumno -> Nota
nota (Alu _ _ laNota) = laNota
```

Este chiche nos facilita la lectura y escritura, sin alterarnos el significado

```hs
data Alumno =  Alumno {
    nombre :: Nombre,
    legajo :: Legajo,
    nota :: Nota
} deriving (Show, Eq)
```

Esto a nos permite la siguiente instancia por consola:

```
> Alumno { nombre="Jose", legajo="194421-4", nota=8}
Alumno { nombre="Jose", legajo="194421-4", nota=8}
```

### Tuplas

Podemos pensarlos como *datas* anonimos, en esta cursada no se utilizaran.

Podemos ver la construccion de una tupla como

```
> ("Jose", "1994421-4", 8)
("Jose", "1994421-4", 8)

> :t ("Jose", "1994421-4", 8)
(String, String, Int)
```

Estas se usan, por lo general en aplicaciones muy genericas. Vemos que el tipado deja mucho que desear, no hay manera de distinguir las tuplas entre si.

## Pattern Matching Avanzado

Teniendo el siguiente Alumno de Paradigmas

```hs
data Alumno = Alumno{
    legajo :: String,
    plan :: Int,
    notaFuncional :: Nota,
    notaLogico :: Nota,
    notaObjetos :: Nota
} deriving (Show, Eq)

data Nota = Nota{
    valor :: Int,
    detalle ::  String
} deriving (Show, Eq)
```

Si quisieramos una funcion identidad (ya definida en haskell). Suponiendo que tendriamos que usar *pattern matchig*

```hs
id :: Nota -> Nota
id nota = nota
```

Ahora suponganos que por alguna razon, debemos "explotar" la nota.

```hs
id (Nota elValor elDetalle) = ???

{- Una alternativa seria reconstruir la nota-}

id (Nota elValor elDetalle) = Nota elValor elDetale
```

Sin embargo existe una alternativa mas simpatica, que permite crear un patron

```hs
id nota@{Nota elValor elDetalle} = nota
```

Podemos interpretarlo como un `#define`

Siguiendo con otro ejemplo, necesitamos un promedio de las notas, que sera la nota final

```hs
notaFinal :: Alumno -> Nota
notaFinal (Alumno _ (Nota fun _) (Nota log _) (Nota obj _)) = (fun + log + obj) `div` 3
```

A esto llamamos patron compuesto: un patron que contiene patrones.

Como vemos esto es emborroso, por lo cual se recomienda

```hs
notaFinal nota = (valor notaFuncional nota + valor notaObjetos nota + valor notaLogico nota) `div` 3
```

Veamos este otro ejemplo:

```hs
aprobado :: Bool
aprobado alumno | plan alumno <= 1995 = notaFinal alumno >= 4
                | otherwise           = notafinal alumno >= 6
```

Debemos aplicar guardas cuando se tratan de funciones partidas.

---------------------------------------------------------------
