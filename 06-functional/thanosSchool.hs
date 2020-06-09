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
==============================================================================   PARCIAL ESCUELITA DE THANOS   =============================================================================
===============================================================================================================================================================================
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------}

{-=============================================================== PARTE I =====================================================================-}

-- Alias (No pedidos)
type Material = String
type Nombre = String
type Gema = Personaje -> Personaje

{-
    Ejercicio 1:
                    Modelar Personaje, Guantelete y Universo como tipos de datos, implementar Chasquido
-}

data Personaje = Personaje {
    nombre :: Nombre,
    planeta :: Nombre,
    edad :: Int,
    energia :: Int,
    habilidades :: [Nombre]

} deriving (Show, Eq)


data Guantelete = Guantelete {
    material :: Material,
    gemas :: [Gema]
}

-- No hace falta declarar un data, con un alias alcanza
type Universo = [Personaje]

chasquearUniverso :: Guantelete -> Universo -> Universo
chasquearUniverso glove universe | ((== "uru") . material) glove && ((== 6). length . gemas) glove = (take (length universe `div` 2)) universe
                                 | otherwise = universe
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 2: Resolver unicamente aplicando ORDEN SUPERIOR
                    Saber si el universo es pato para PENDEX, si alguno de los personajes es tiene menos de 45 anios.
                    Saber la energia total de un universo, sumatoria de todas las energias de los personajes
-}

aptoPendex :: Universo -> Bool
aptoPendex = any ((< 45) . edad)

energiaTotalUniverso :: Universo -> Int
energiaTotalUniverso = sum . map energia


{-=============================================================== PARTE II =====================================================================-}

{-
    Funcionalidad de las GEMAS

    La mente que tiene la habilidad de debilitar la energía de un usuario en un valor dado.
    El alma puede controlar el alma de nuestro oponente permitiéndole eliminar una habilidad en particular si es que la posee. Además le quita 10 puntos de energía. 
    El espacio que permite transportar al rival al planeta x (el que usted decida) y resta 20 puntos de energía.
    El poder deja sin energía al rival y si tiene 2 habilidades o menos se las quita (en caso contrario no le saca ninguna habilidad).
    El tiempo que reduce a la mitad la edad de su oponente pero como no está permitido pelear con menores, no puede dejar la edad del oponente con menos de 18 años. Considerar la mitad entera, por ej: si el oponente tiene 50 años, le quedarán 25. Si tiene 45, le quedarán 22 (por división entera). Si tiene 30 años, le deben quedar 18 en lugar de 15. También resta 50 puntos de energía.
    La gema loca que permite manipular el poder de una gema y la ejecuta 2 veces contra un rival.

-}

{-
        Ejercicio 3:
                        Modelar las Gemas
-}

gemaMente :: Int -> Gema
gemaMente n pj = pj { energia = energia pj - n}

gemaAlma :: Nombre -> Gema
gemaAlma hab pj = gemaMente 10 (pj {habilidades = (filter (/= hab) . habilidades) pj})

gemaEspacio :: Nombre -> Gema
gemaEspacio planet pj = gemaMente 20 (pj {planeta = planet})

gemaPoder :: Gema
gemaPoder pj | ((<= 2) . length . habilidades) pj = pj { energia = 0, habilidades = []}
             | otherwise = pj {energia = 0}

gemaTiempo :: Gema
gemaTiempo pj | ((<=18 ). (`div` 2) . edad) pj = gemaMente 50 (pj {edad = 18 })
              | otherwise = gemaMente 50 (pj  { edad = edad pj `div` 2})

gemaLoca :: Gema -> Gema
gemaLoca gema = gema . gema


-------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 4:
    Dar un ejemplo de un guantelete de goma con las gemas tiempo, alma que quita la habilidad de “usar Mjolnir”
     y la gema loca que manipula el poder del alma tratando de eliminar la “programación en Haskell”.
-}

guanteDeGoma :: Guantelete
guanteDeGoma = Guantelete { material = "goma", gemas = [gemaTiempo, gemaAlma "usar Mjormil", gemaLoca (gemaAlma "programación en Haskell")]}

-------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 5: NO USAR RECURSIVIDAD
    Generar la funcion utilizar que dado una lista de gemas y un enemigo ejecuta el poder de cada una de las gemas
    contra el personaje dado. Indicar como se produce el "efecto de lado"
-}

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gems pj = foldr id pj gems

-- Se utiliza como semilla el Personaje, como queres aplicar la gema sin tocarla, usamos id, que devuelve la misma
-- se van "creando" personajes, sobre los cuales se volvera aplicar la siguiente gema que resultan de aplicar la gema

-------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 6: Resolver utilizando recursividad.
    Definir la función gemaMasPoderosa que dado un guantelete y una persona
    obtiene la gema del infinito que produce la pérdida más grande de energía sobre la víctima. 
-}

gemaMasPoderosa ::  Personaje -> Guantelete-> Gema
gemaMasPoderosa pj = gemaMasPoderosaDe pj . gemas

gemaMasPoderosaDe :: Personaje -> [Gema] -> Gema
gemaMasPoderosaDe _ [g] = g
gemaMasPoderosaDe pj (g1:g2:gs)
 | (energia . g1) pj < (energia . g2) pj = gemaMasPoderosaDe pj (g1:gs)
 | otherwise = gemaMasPoderosaDe pj (g2:gs)

-------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 7
    Dada la siguiente funcion, Justifique si se puede ejecutar, relacionandolo con conceptops vistos en clase
-}

--
tony :: Personaje
tony = Personaje {nombre= "Tony", planeta = "Tierra", edad= 100, energia= 100, habilidades = ["Correr", "Saltar"]}

infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema:(infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas gemaTiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete = (utilizar . take 3. gemas) guantelete

-- Las funciones a  evaluar son:
-- gemaMasPoderosa tony guanteleteDeLocos -> No es posible, porque requiere "iterar" por toda la lista, la cual nunca terminaria
-- usoLasTresPrimerasGemas guanteleteDeLocos tony -> Si, gracias al lazy evaluation, solo utiliza una cantidad finita, de las infinitas

