{-  MIT License

    Copyright (c) 2020 Tomas Sanchez

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
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
==============================================================================   PARCIAL GNOMOS   =============================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-}
import Data.List (intersect)

-- Alias de Resolucion (No pedidos)
type Nombre = String
type Valor = Int
type Pobalcion = Int
-- 

-- Alias del Enunciado
type Material = (Nombre, Valor)
type Edificio = (Nombre, [Material])
type Aldea = (Pobalcion, [Material], [Edificio])
--

{-
    Ejercicio 1:
    Desarrollar las siguientes funciones

-}

{-      a) "esDeCalidad" que recibe un material
           y devuelve si su valor es mayor que 20
-}

-- La idea es demostrar un gran dominio y entendimiento del paradigma
esDeCalidad :: Material -> Bool
esDeCalidad = (>20) . snd
-- Podriamos descomponer esDeCalidad (name, value) = value > 20, pero para mostar mas dominio
-- es mejor realizar composicion y aplicacion parcial
-- Point Free para sobrar

{-
    ---------------------------------------------------------------------------------------------------------------------
-}

{-      b) "disponibles", recibe el nombre de un material y una aldea
        y retorna la cantidad de materiales disponibles con ese nombre en la aldea
-}

-- Para mejor lectura creo este Alias
type Cantidad = Int

-- Tenemos que obtener la lista de materiales, filtrar por nombre y dar la cantidad
disponibles :: Nombre -> Aldea -> Cantidad
disponibles name  =  (length . filter ((== name) . fst ) . materiales)
-- Uno estaria tentado a usar snd, pero snd :: (a, b) -> b, y tenemos (a, b, c). No tipa
-- Aprovechamos para clavar una '\ lambda function. Bien podria definirse como una funcion de orden inferior

materiales :: Aldea -> [Material]
materiales (_, mts, _) = mts

{-
    Test con:
    disponibles "Acero" (50, [("Acero", 15), ("Acero", 20), ("J", 0)], [])
-}

{-
    ---------------------------------------------------------------------------------------------------------------------
-}

{-
    c) "valorTotal" que recibe una aldea
    retorna la suma del valor de sus materiales disponibles y de los usados en los edificios
-}

-- Funciones de Acceso
poblacion :: Aldea -> Pobalcion
poblacion (pob, _, _) = pob

edificios :: Aldea -> [Edificio]
edificios (_, _, ed) = ed
--

-- Este es facil de entender, pero complicado de codear.
-- Recomendacion: Ir delegando problemas a otras funciones. Capo creaste 3 funciones ademas de las pedidas...
-- intentar resolverlo en una y 2 lineas es para dolores de cabeza. Perdi 40 minutos tratando de lograr eso.
-- Ademas Facilita la lectura enves de estar viendo composicion tras composicion ves un nombre que es mas intuitivo
valorTotal :: Aldea -> Valor
valorTotal village =  (sumaEdificios . edificios) village + (valorMateriales . materiales) village

-- Sabemos que la funcion sum devuelve la suma de una lista de enteros
sumaEdificios :: [Edificio] -> Valor
sumaEdificios = sum . map valorEdificio

-- La dificultad es que las listas estan metidas en las tuplas y hay que ir sacandolas de a poco
valorEdificio :: Edificio -> Valor
valorEdificio = valorMateriales . snd

--  Esta funcion si bien es una pavada, como su logica se repite en muchas otras, es mejor definirla como orden inferior
valorMateriales :: [Material] -> Valor
valorMateriales = sum . map snd

{-
===========================================================================================================================================================
-}

{-
    Ejercicio 2:
        Desarrollar las siguientes para modificar la aldea
-}



{-
        a) "tenerGnomito" aumenta en uno la poblacion
-}

-- No podemos usar variables anonimas
tenerGnomito :: Aldea -> Aldea
tenerGnomito (pob, mat, ed) = (pob+1, mat, ed)

{-
    ---------------------------------------------------------------------------------------------------------------------
-}

{-
        b) lustrarMaderas
        aumenta en 5 el valor de todos los materiales disponibles cuyo nombre empieza con Madera
-}

-- Relativamente sencillo, solo debemos tocar la lista de Materiales y subirle 5 si cumplen condicion
lustrarMaderas :: Aldea -> Aldea
lustrarMaderas (pob, mat, ed) = (pob, map subirMaderas mat, ed)

-- Como es una funcion partida podemos aplicar guardas
subirMaderas :: Material -> Material
subirMaderas (name, value) | "Madera" <= name = (name, value + 5)
                           | otherwise = (name, value)
-- Supongamos que " 'Madera' <= name" funciona correctamente

{-
    ---------------------------------------------------------------------------------------------------------------------
-}

{-
        c) "recolectar" que recibe un material, una candtidad y una aldea
        y retorna una aldea con n materiales disponibles mas como el recibido
-}

-- Sin hacernos dolor de cabeza, la idea es no cambiar nada de la aldea salvo la lista de [Material]
recolectar :: Material -> Cantidad -> Aldea -> Aldea
recolectar material amount (p, m, e) = (p, ((replicate amount material) ++ m), e) 
-- Utilizar "replicate" que genera una lista con n elementos del segundo parametro y luego concatenarle la lista original

{-
    ---------------------------------------------------------------------------------------------------------------------
-}

{-
        d) "construirEdificio" que recibe un edificio y una aldea
        retorna la aldea luego de agregar ese edifcio, gastando materiales
        suponer que hay materiales suficientes
-}

-- Si bien la idea es facil, vamos scandonos los problemas de a uno
-- Ena la primera, creamos la aldea y modificamos los materiales unicamente
-- Como es una lista y la modificamos alterandola, usamos MAP, delegamos el problema a otra funcion
construirEdificio :: Edificio -> Aldea ->  Aldea
construirEdificio nuevo_ed (p, m, e) = (p, map (consumirMateriales nuevo_ed) m , nuevo_ed : e)
-- Uno estaria tentado a hacer nuevo_ed ++ e, pero eso solo funciona con [a] y nuevo_ed es a, usamps operador :

-- Tenemos una funcion partida, si necesita el material, lo modificia, sino devuelve al mismo, ahora para crear otro material, delegamos a otra funcion como obtener el valor del material, pero sabemos que se tiene que restar
consumirMateriales :: Edificio -> Material -> Material
consumirMateriales ed mat | (any (seaMaterial mat) . snd) ed = (fst mat, snd mat - (snd . materialesEdificio mat) ed)
                          | otherwise = mat
-- El unico problema es que esto deja un Material con 0 unidades, ej ("Acero", 0)

-- Esta funcion obtiene el material, como lo obtiene es problema de otro
materialesEdificio :: Material -> Edificio -> Material
materialesEdificio mat = head . filter (seaMaterial mat) . snd
-- Nota: GHCi no quiere aceptar 'find' recomendada por la catedra, almenos en mi caso

-- Se busca que los nombres sean iguales
seaMaterial :: Material -> Material -> Bool
seaMaterial mat1 mat2 = fst mat1 == fst mat2 && snd mat1 >= snd mat2

-- Test
macondo :: Aldea
macondo = (gnomitos, [acero15, acero25], [panaderia])
-- ==
gnomitos :: Pobalcion
gnomitos = 50
-- ==
acero25 :: Material
acero25 = ("Acero", 25)
acero15 ::  Material
acero15 = ("Acero", 15)
acero10 :: Material
acero10 = ("Acero", 10)
madera :: Material
madera = ("Madera de Arce", 20)
piedra :: Material
piedra = ("Piedra", 10)
-- ==
barracas :: Edificio
barracas = ("Barracas", [acero25, madera])
panaderia :: Edificio
panaderia = ("Panaderia", [madera])
--

{-
===========================================================================================================================================================
-}

{-
    Ejercicio 3
-}

{-
    a) Obtener el nombre y valor total de los Edificios que tienen algun material de calidad de una aldea
-}

-- Copio el type de Material para mejor comprension
type Chetificio = Material

-- Voy deleganado funciones
valorDeEdificiosChetos :: Aldea -> [Chetificio]
valorDeEdificiosChetos =  map marcarComoCheto . edificiosCalidad

-- Filtro los de calidad
edificiosCalidad :: Aldea -> [Edificio]
edificiosCalidad = filter (any esDeCalidad . snd ) . edificios

--Creo la estructura que me piden
marcarComoCheto :: Edificio -> Chetificio
marcarComoCheto edif = (fst edif, valorEdificio edif)


--Test
gnomoaldea :: Aldea
gnomoaldea = (gnomitos, [], [barracas,panaderia])
-- Cumple Nota, a diferencia del enunciado, defino madera como 20, para ambos casos.

{-
    ---------------------------------------------------------------------------------------------------------------------
-}

{-
        b) Lista de Nombres de los materiales comunes, que estan en todos los edificios de la aldea
-}

-- Primero Busco la lista de todos los materiales
nombresDeMaterialesComunes ::  Aldea -> [Nombre]
nombresDeMaterialesComunes = foldr1 intersect . nombresMaterialesUsados . materialesUsados

-- Para ello defino esta funcion para mejor lecutura
materialesUsados :: Aldea -> [[Material]]
materialesUsados = map snd . edificios

-- Ahora consigo todos los nombres, pero los mantengo en lista de lista para poder "identificar edificios"
nombresMaterialesUsados :: [[Material]] -> [[Nombre]]
nombresMaterialesUsados = map (map fst)
-- Luego volemos a la pimera funcion. Ahi debemos Buscar los nombres que se repiten y ademas des-enlistar para tener [Nombre]
-- Importante, para esto necesitamos INTESERCT que esta en Data.List, que nos permite encontrar los iguales dadas dos listas
-- Pero Como las listas se comparan con la anterior necesitamos el Fold, y ademas nuestra seed es el primer edificio, por ello foldl1 o bien foldr1
