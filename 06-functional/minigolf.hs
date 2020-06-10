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
==============================================================================   PARCIAL MINI GOLF   ==========================================================================
===============================================================================================================================================================================
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------}


-- Modelo inicial
data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart :: Jugador
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd ::  Jugador
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa :: Jugador
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles
between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b


{-
    Ejercicio 1:
    Sabemos que cada palo genera un efecto diferente,
    por lo tanto elegir el palo correcto puede ser la diferencia entre ganar o perder el torneo.
-}

{-
        a) Modelar los palos usados en el juego que a partir de una determinada
        habilidad generan un tiro que se compone por velocidad, precisión y altura.
-}

-- i) El putter genera un tiro con velocidad igual a 10, el doble de la precisión recibida y altura 0.

type Palo = Habilidad -> Tiro

putter :: Palo
putter ab = UnTiro {velocidad = 10, precision= ((*2) . precisionJugador) ab, altura = 0}

-- ii) La madera genera uno de velocidad igual a 100, altura igual a 5 y la mitad de la precisión.

madera ::  Palo
madera ab = UnTiro{ velocidad = 100, precision = ((`div` 2). precisionJugador) ab, altura = 5}

-- iii) Los hierros, que varían del 1 al 10 (número al que denominaremos n),
-- generan un tiro de velocidad igual a la fuerza multiplicada por n, la precisión dividida por n y una altura de n-3 (con mínimo 0). 
-- Modelarlos de la forma más genérica posible.

hierro :: Int -> Palo
hierro n ab = UnTiro {velocidad = (((* n) . fuerzaJugador) ab), precision = ((`div` n) . precisionJugador) ab, altura = max (n-3) 0}

{-
    b) Definir una constante palos que sea una lista con todos los palos que se pueden usar en el juego.
-}

palos :: [Palo]
palos = [putter, madera] ++ map hierro [1..10]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 2:
                Definir la función golpe que dados una persona y un palo, obtiene el tiro resultante de usar
                ese palo con las habilidades de la persona.
-}

golpe :: Jugador -> Palo -> Tiro
golpe jg p = p $ habilidad jg

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 3:
                Lo que nos interesa de los distintos obstáculos es si un tiro puede superarlo, y en el caso de poder superarlo,
                cómo se ve afectado dicho tiro por el obstáculo. En principio necesitamos representar los siguientes obstáculos:
-}


{-
        a) Un túnel con rampita sólo es superado si la precisión es mayor a 90 yendo al ras del suelo, independientemente de la velocidad del tiro.
        Al salir del túnel la velocidad del tiro se duplica, la precisión pasa a ser 100 y la altura 0.
-}

type Obstaculo = Tiro -> Tiro

hoyo :: Obstaculo
hoyo t = t {velocidad = 0, precision = 0, altura = 0}

tunel :: Obstaculo
tunel t | precision t > 90 = t {velocidad = ((*2) . velocidad) t, precision = 100, altura = 0}
        | otherwise = hoyo t

laguna :: Int -> Obstaculo
laguna largo t | (80 < velocidad t) && between 1 (altura t) 5 = t { altura = altura t `div` largo}
               | otherwise = hoyo t

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 4:
                Definir
-}

-- a) palosUtiles

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jg obs = filter (puedeSuperar obs .  golpe jg ) palos

puedeSuperar :: Obstaculo -> Tiro -> Bool
puedeSuperar obs t = hoyo t /= obs t

-- b) Saber, a partir de un conjunto de obstáculos y un tiro, cuántos obstáculos consecutivos se pueden superar.

qtosConsecutivosSupera :: Tiro -> [Obstaculo] -> Int
qtosConsecutivosSupera _ [] = 0
qtosConsecutivosSupera t (ob:obs)
 | puedeSuperar ob t = 1 + qtosConsecutivosSupera (ob t) (obs)
 | otherwise = 0

-- c) Definir paloMasUtil que recibe una persona y una lista de obstáculos y determina cuál es el palo que le permite superar más obstáculos con un solo tiro.

paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil j obs = maximoSegun (flip qtosConsecutivosSupera obs . golpe j) palos

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 5:
                    Dada una lista de tipo [(Jugador, Puntos)] que tiene la información de cuántos puntos ganó cada niño al finalizar el torneo,
                    se pide retornar la lista de padres que pierden la apuesta por ser el “padre del niño que no ganó”.
                    Se dice que un niño ganó el torneo si tiene más puntos que los otros niños.
-}

perdedores :: [(Jugador, Puntos)] ->[String]
perdedores jgs = (map ( padre. fst) . filter (/= (maximoSegun snd jgs))) jgs
