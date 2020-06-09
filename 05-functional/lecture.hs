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

Harry Potter y el Parcial de Funcional

Se pide desarrollar un programa Haskell que ayude a regular el consumo de las pociones
 que se enseñan a los alumnos del colegio Hogwarts de Magia y Hechicería.

Las pociones, producidas al combinar ingredientes exóticos que causan efectos diversos,
 pueden ser consumidas con el fin de alterar los niveles de suerte, inteligencia y fuerza de quien las bebe.

Para representar este modelo contamos con las siguientes definiciones:
-}

data Persona = Persona {
  nombrePersona :: String,
  suerte :: Int,
  inteligencia :: Int,
  fuerza :: Int
} deriving (Show, Eq)

data Pocion = Pocion {
  nombrePocion :: String,
  ingredientes :: [Ingrediente]
}

type Efecto = Persona -> Persona

data Ingrediente = Ingrediente {
  nombreIngrediente :: String,
  efectos :: [Efecto]
}

nombresDeIngredientesProhibidos :: [[Char]]
nombresDeIngredientesProhibidos = [
 "sangre de unicornio",
 "veneno de basilisco",
 "patas de cabra",
 "efedrina"]

maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun _ [ x ] = x
maximoSegun  f ( x : y : xs)
  | f x > f y = maximoSegun f (x:xs)
  | otherwise = maximoSegun f (y:xs)


{-
    Ejercicio 1:

    Dada una persona definir las siguientes funciones para cuantificar sus niveles de suerte, inteligencia y fuerza sin repetir código:

        a) sumaDeNiveles que suma todos sus niveles.
        b) diferenciaDeNiveles es la diferencia entre el nivel más alto y más bajo.
        c) nivelesMayoresA n, que indica la cantidad de niveles de la persona que están por encima del valor dado.

-}

sumaDeNiveles :: Persona -> Int
sumaDeNiveles = sum . niveles

diferenciaDeNiveles :: Persona -> Int
diferenciaDeNiveles persona = (maximum . niveles) persona - (minimum . niveles) persona

niveles ::  Persona -> [Int]
niveles persona = [fuerza persona, inteligencia persona, inteligencia persona] 

nivelesMayoresA :: Int -> Persona -> Int
nivelesMayoresA n =  length . filter (>n) . niveles

{-
    Ejercicio 2.

    Definir la función efectosDePocion que dada una poción devuelve una lista con los efectos de todos sus ingredientes.

-}

-- Importante Concat para aplanar [[a]] -> [a], Utilzia ++ para Unir Conjuntos
efectosDePocion :: Pocion -> [Efecto]
efectosDePocion = concat . map (efectos) . ingredientes


{-
    Ejercicio 3.

    Dada una lista de pociones, consultar:

    a. Los nombres de las pociones hardcore, que son las que tienen al menos 4 efectos.
    b. La cantidad de pociones prohibidas, que son aquellas que tienen algún ingrediente
     cuyo nombre figura en la lista de ingredientes prohibidos.
    c. Si son todas dulces, lo cual ocurre cuando todas las pociones de la lista tienen algún ingrediente llamado “azúcar”.

-}

pocionesHardcore :: [Pocion] -> [String]
pocionesHardcore = map nombrePocion . filter ((>=4) . length . efectosDePocion)

cantidadPocionesProhibidas :: [Pocion] -> Int
cantidadPocionesProhibidas = length . filter (esProhibida)

esProhibida :: Pocion -> Bool
esProhibida = any ((`elem` nombresDeIngredientesProhibidos) . nombreIngrediente) . ingredientes

todasDulces :: [Pocion] -> Bool
todasDulces = all (any ((== "azucar") . nombreIngrediente ) . ingredientes)

{-
    Ejercicio 4.

        Definir la función tomarPocion que recibe una poción y una persona, y devuelve como quedaría la persona después de tomar la poción.
         Cuando una persona toma una poción, se aplican todos los efectos de esta última, en orden.

-}

tomarPocion :: Pocion -> Persona -> Persona
tomarPocion pocion personaBase =  (foldl (\persona efecto -> efecto persona) personaBase  . efectosDePocion) pocion


{-
    Ejercicio 5.

    Definir la función esAntidotoDe que recibe dos pociones y una persona, y dice si tomar la segunda poción
     revierte los cambios que se producen en la persona al tomar la primera.
-}

esAntidotoDe :: Pocion -> Pocion -> Persona -> Bool
esAntidotoDe pocion antidoto persona = ((== persona) . (tomarPocion antidoto) . (tomarPocion pocion)) persona

{-
    Ejercicio 6.

    Definir la función personaMasAfectada que recibe una poción, una función cuantificadora
     (es decir, una función que dada una persona retorna un número) y una lista de personas,
      y devuelve a la persona de la lista que hace máxima el valor del cuantificador.
    
    Mostrar un ejemplo de uso utilizandolos cuantificadores definidos en el punto 1.
-}

personaMasAfectada :: Pocion -> (Persona -> Int) -> [Persona] -> Persona
personaMasAfectada pocion criterio = maximoSegun ( criterio . tomarPocion pocion)
