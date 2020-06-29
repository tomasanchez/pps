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
==============================================================================   PARCIAL 2020   ===============================================================================
===============================================================================================================================================================================
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------}

{-=============================================================== PARTE I =====================================================================-}


{-
    Nos piden desarrollar un sistema para administrar las carreras de chocobos que se realizan semanalmente en las pistas localizadas en las inmediaciones del complejo Gold Saucer, con el fin de simular y predecir los resultados de las carreras y asistir a los apostadores.

    Para eso necesitamos modelar el perfil de cada ave que participa, así como también las características de las diversas pistas en las que corren y el modo en que estas afectan los resultados.

    De cada Chocobo nos interesa registrar su color, el tiempo que lleva corriendo desde que empieza una carrera y la velocidad a la que se desplaza.

    También sabemos que las Pista en las que se realizan las carreras se componen de Tramos de distinta longitud, cada uno de los cuales atraviesa un tipo diferente de Terreno. El terreno del tramo influencia en gran medida la forma en que cada ave puede recorrerlo: No es lo mismo correr en una pradera que esquivando ramas en la selva! Cada terreno afecta la velocidad a la que un chocobo puede atravesar el tramo y el tiempo que este le requiere.

    Para representar estos datos, elegimos utilizar las siguientes estructuras:
-}

data Chocobo = Chocobo {
  tiempo :: Int,
  velocidad :: Int,
  color :: String
} deriving (Eq, Show)

type Pista = [Tramo]

data Tramo = Tramo {
  longitud :: Int,
  terreno :: Terreno
}

{-
    Ejercicio 1:
    
    Modelar una función para bajar en cierta cantidad la velocidad a la que un Chocobo corre,
    y otra para hacer que corra una distancia dada, considerando que recorrer una distancia,
    le lleva al Chocobo un tiempo equivalente a su velocidad dividida dicha distancia.
-}

bajarVelocidad :: Int ->  Chocobo -> Chocobo
bajarVelocidad n choc = choc { velocidad = (((-) n). velocidad) choc}

correrDistancia :: Int -> Chocobo ->  Chocobo
correrDistancia dist choc = choc { tiempo = ((`div` dist) . velocidad) choc}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 2:
    Definir el tipo Terreno, de forma tal que resulte adecuado para representar los diversos terrenos que los tramos de las pistas atraviesan y…
-}

type Terreno = (Chocobo -> Chocobo)

-- a) Modelos los siguientes terrenos:

--  asfalto: Este terreno es ideal para correr ya que no impacta de ninguna forma a los Chocobos.
asfalto :: Terreno
asfalto = id

--  bosque: Los múltiples obstáculos y peligros de este terreno obligan a los Chocobos a reducir su velocidad una cuarta parte

bosque :: Terreno
bosque choc = bajarVelocidad (((`div` 4) . velocidad) choc) choc

{-
    agua: Los tramos sumergidos en agua pueden impactar a las aves de diversas maneras.
    Si la profundidad del agua es menos de 50 cm, los pájaros son capaces de atravesar la perdiendo dos puntos de velocidad
    por cada cm de profundidad. Por otro lado, si el agua es más profunda que eso, los Chocobos no se animan a cruzarla y,
    en cambio, pierden 5 minutos bordeando por el costado. Cabe destacar que estas penalidades no afectan a los Chocobos Azules,
    que son naturalmente buenos nadadores y cruzan los tramos de agua como si nada.
-}

agua :: Int -> Terreno
agua prof choc | ((== "azul") . color) choc = asfalto choc
               | prof < 50 = bajarVelocidad (2 * prof) choc
               | otherwise = choc {tiempo = (((+)5 ) . tiempo) choc }

{-
    pantano:  Los pantanos son lugares horribles que mezclan todos los peores aspectos de los bosques y las zonas inundadas.
    Cuando un Chocobo cruza un pantano lo impacta igual que cruzar un bosque y 20 cm de agua (en ese orden). Además de eso,
    pierde un punto extra de velocidad, sólo por el cagazo que le da el lugar.
-}

pantano :: Terreno
pantano =  (bajarVelocidad 1 ) . (agua 20) . bosque   

{-
    b) Modelar una función correrTramo que, dado un Tramo y un Chocobo haga que el ave corra la distancia del tramo
    luego de ser afectada por el terreno.
-}
correrTramo :: Tramo -> Chocobo -> Chocobo
correrTramo tram choc = ( correrDistancia (longitud tram) . terreno tram) choc

{-
    c) Dar un ejemplo de pista que contenga tramos con todos los terrenos descritos anteriormente y uno más,
    inventado por vos, con un comentario que describa qué cambio hace.
-}
tramoAgua :: Tramo
tramoAgua = Tramo {longitud = 15, terreno = agua 30}

tramoPantano :: Tramo
tramoPantano = Tramo {longitud= 5, terreno = pantano}

tramoAsfalto :: Tramo
tramoAsfalto = Tramo {longitud= 10, terreno = asfalto}

tramoBosque :: Tramo
tramoBosque = Tramo {longitud = 5, terreno = bosque}

miPista :: Pista
miPista = [tramoAgua, tramoBosque, tramoPantano, tramoAsfalto]

-- Si el Chocobo es blanco, esta adaptado a los terrenos helados, y aumenta su velocidad en 20,
-- de otra manera si el chocobo va a una gran velocidad (50) resbala y aumenta su velocidad en 5,
-- Si no va rapido, entra con miedo y pierde tiempo resbalando lentamente bajando su velocidad tambien
hielo :: Terreno
hielo choc | ((== "blanco") . color) choc = choc {velocidad = velocidad choc + 20}
           | ((> 50) . velocidad ) choc = choc {velocidad = velocidad choc + 5}
           | otherwise = bajarVelocidad 5 choc {tiempo = (((-)3 ) . tiempo) choc }

tramoHielo :: Tramo
tramoHielo = Tramo {longitud = 20, terreno = hielo}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

{-
   Ejercicio 3:
   Definir funciones que, dada una lista de Chocobos:
-}

-- a) Indique cuál es el mayor tiempo de los Chocobos que todavía están corriendo (es decir, aquellos cuya velocidad es > 0).
mayorTiempoAunCorriendo :: [Chocobo] -> Int
mayorTiempoAunCorriendo = maximum . map tiempo . filter ((> 0) . velocidad)

-- b) Dada una lista de colores, indique si todos los Chocobos que llevan más de treinta minutos corriendo son de un color de la lista.

sonTodosDeUnColor :: [String] -> [Chocobo] -> Bool
sonTodosDeUnColor colores =  all (sonDeAlgunColor colores) . map color . filter ((>30). tiempo)

sonDeAlgunColor :: [String] -> String -> Bool
sonDeAlgunColor cls cl = any (== cl) cls

{-
    c) Dado un tramo y un Chocobo campeón, indique cuántos de los Chocobos de la lista pueden correr dicho tramo más rápido
    que el campeón.
-}
masRapidoQueCampeon :: Chocobo -> Terreno -> [Chocobo] -> Int
masRapidoQueCampeon campeon terr = length . filter ((\ c1 c2 -> velocidad c1 < velocidad c2 ) (terr campeon)) . map terr

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
{-
    Ejercicio 4:
    Utilizando la siguiente función ordenar:
-}

ordenar _ [] = []
ordenar f (x:xs) = (ordenar f . filter ((f x >=).f)) xs ++
                [x] ++
                (ordenar f . filter ((f x <).f)) xs

{-
    Modelar la función correrCarrera :: [Chocobo] -> Pista -> [Chocobo], que reciba una lista de participantes
    y una pista y retorne el podio resultante de la carrera, es decir,
    los tres Chocobos que recorrieron todos los tramos de la pista (en orden) en el menor tiempo, ordenados de menor a mayor tiempo.
-}

correrCarrera :: [Chocobo] -> Pista -> [Chocobo]
correrCarrera chocs pista = (take 3 . ordenar tiempo . map (`recorrerPista` pista)) chocs

recorrerPista :: Chocobo -> Pista -> Chocobo
recorrerPista choc p =  foldl (flip correrTramo) choc p

-- Tests
chocoAzul :: Chocobo
chocoAzul = Chocobo {tiempo = 0, velocidad = 50, color = "azul"}
chocoRojo :: Chocobo
chocoRojo = Chocobo {tiempo = 0, velocidad = 40, color = "rojo"}
chocoBlanco :: Chocobo
chocoBlanco = Chocobo {tiempo = 0, velocidad = 60, color = "blanco"}
chocoNegro :: Chocobo
chocoNegro = Chocobo {tiempo = 0, velocidad = 30, color = "negro"}
chocoAmarillo :: Chocobo
chocoAmarillo = Chocobo {tiempo = 0, velocidad = 100, color = "amarillo"}
-- Test 
losChoco :: [Chocobo]
losChoco = [chocoAmarillo, chocoAzul, chocoNegro, chocoRojo]

pista2 :: Pista
pista2 = [tramoHielo, tramoAsfalto]