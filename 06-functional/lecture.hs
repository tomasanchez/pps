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
==============================================================================   EJERCITACION   ===============================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-}

{-
    De cada gimnasta nos interesa saber su peso y su coeficiente de tonificación.
    Los profesionales del gimnasio preparan rutinas de ejercicios pensadas para las necesidades de cada gimnasta.
    Una rutina es una lista de ejercicios que el gimnasta realiza durante unos minutos para quemar calorías y tonificar sus músculos.
-}

{-
    Ejericio 1

    Modelar a los Gimnastas y las operaciones necesarias para hacerlos ganar tonificación y quemar
     calorías considerando que por cada 500 calorías quemadas se baja 1 kg de peso.

-}

data Gimnasta = Gimnasta {
        peso :: Int,
        tonificacion :: Int
    } deriving(Show, Eq)

tonificar :: Int -> Gimnasta -> Gimnasta
tonificar ton gimnasta = gimnasta { tonificacion = (tonificacion gimnasta) + ton }

quemarCalorias :: Int -> Gimnasta -> Gimnasta
quemarCalorias kal gim = gim { peso = peso gim - kal `div` 500 }


{-
    Ejercicio 2
    
    a) La cinta es una de las máquinas más populares entre los socios que quieren perder peso.
        Los gimnastas simplemente corren sobre la cinta y queman calorías en función de la velocidad promedio alcanzada (quemando 10 calorías por la velocidad promedio por minuto).
        La cinta puede utilizarse para realizar dos ejercicios diferentes:

            i) La caminata es un ejercicio en cinta con velocidad constante de 5 km/h.

            ii) El pique arranca en 20 km/h y cada minuto incrementa la velocidad en 1 km/h,
            con lo cual la velocidad promedio depende de los minutos de entrenamiento.

-}

type Ejercicio = (Int -> Gimnasta -> Gimnasta)

{- a -}
cinta :: Int ->  Ejercicio
cinta velocidad tiempo = quemarCalorias (tiempo * velocidad * 10)

{- a . i -}
caminata :: Ejercicio
caminata = cinta 5

{- a . ii -}
pique :: Ejercicio
pique tiempo = cinta (tiempo `div` 2 + 20) tiempo

{-
        B ) Las pesas son el equipo preferido de los que no quieren perder peso, sino ganar musculatura. 
            Una sesión de levantamiento de pesas de más de 10 minutos hace que el gimnasta gane una tonificación
            equivalente a los kilos levantados. Por otro lado, una sesión de menos de 10 minutos es demasiado corta, y no causa ningún efecto en el gimnasta.
-}

pesas :: Int -> Ejercicio
pesas peso tiempo | tiempo > 10 = tonificar peso
                   | otherwise = id

{-  
        C) La colina es un ejercicio que consiste en ascender y descender sobre una superficie inclinada y quema 2 calorías por
        minuto multiplicado por la inclinación con la que se haya montado la superficie.

        Los gimnastas más experimentados suelen preferir otra versión de este ejercicio: la montaña, que consiste en 2 colinas sucesivas
        (asignando a cada una la mitad del tiempo total), donde la segunda colina se configura con una inclinación de 5 grados más que la
        inclinación de la primera. Además de la pérdida de peso por las calorías quemadas en las colinas, la montaña incrementa en 3
        unidades la tonificación del gimnasta.
-}

colina :: Int -> Ejercicio
colina inclinacion tiempo = quemarCalorias (2 * tiempo * inclinacion)

montania :: Int -> Ejercicio
montania inc tiempo = tonificacion 3 . colina (inc + 5) (tiempo `div` 2 ) . colina inc (tiempo `div` 2 )

data Rutina = Rutina {
 nombre :: String,
 duracionTotal :: Int,
 ejercicios :: [Ejercicio]
}

{-
    Ejercicio 3

    Dado un gimnasta y una Rutina de Ejercicios, representada con la siguiente estructura:
    Implementar una función realizarRutina, que dada una rutina y un gimnasta retorna el gimnasta resultante de realizar todos
    los ejercicios de la rutina, repartiendo el tiempo total de la rutina en partes iguales.
    Mostrar un ejemplo de uso con una rutina que incluya todos los ejercicios del punto anterior.
-}

realizarRutina :: Gimnasta -> Rutina -> Gimnasta
realizarRutina gimInicial rutina = foldl (\ gimnasta ejercicios -> (tiempoEjercicios rutina) gimnasta) gimInicial (ejercicios rutina)

tiempoEjercicios :: Rutina -> Int
tiempoEjercicios rut = ((div (duracionTotal rut)) . length . ejercicios ) rut


{-
    Ejercicio 4
    Definir las operaciones necesarias para hacer las siguientes consultas a partir de una lista de rutinas:
-}

{- ¿Qué cantidad de ejercicios tiene la rutina con más ejercicios? -}
mayorCantidadEjercicios :: [Rutina] -> Int
mayorCantidadEjercicios = maximum . map (length . ejercicios)

{- ¿Cuáles son los nombres de las rutinas que hacen que un gimnasta dado gane tonificación? -}
nombresRutinasTonificante :: Gimnasta -> [Rutina] -> [String]
nombresRutinasTonificante gim = map nombre . filter ((> (tonificacion gim)) . tonificacion . realizarRutina gim)

{- ¿Hay alguna rutina peligrosa para cierto gimnasta? Decimos que una rutina es peligrosa para alguien si lo hace perder más de la mitad de su peso. -}
hayPeligrosa :: Gimnasta -> [Rutina] -> Bool
hayPeligrosa gimnasta = any ( (< (peso gimnasta) `div` 2) . peso . (realizarRutina gimnasta))