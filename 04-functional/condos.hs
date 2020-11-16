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
    Buscar departamentos para alquilar por los medios tradicionales es una tarea compleja,
        ya que requiere mucho tiempo de investigación buscando en los clasificados de los diarios y recorriendo inmobiliarias.
    Es por eso que hoy en día cada vez son más las personas que dejaron eso atrás dejando que internet se encargue de buscar las supuestas mejores alternativas para sus necesidades.

    Por eso surge una nueva página para buscar departamentos que permita al usuario personalizar sus propias búsquedas
     y de paso eventualmente mandarle mails con las nuevas ofertas inmobiliarias que podrían ser de su interés a ver si agarra viaje.

    Tenemos los departamentos modelados de la siguiente forma:
-}

type Barrio = String
type Mail = String
type Requisito = Depto -> Bool
type Busqueda = [Requisito]

data Depto = Depto {
 ambientes :: Int,
 superficie :: Int,
 precio :: Int,
 barrio :: Barrio
} deriving (Show, Eq)

data Persona = Persona {
   mail :: Mail,
   busquedas :: [Busqueda]
}

ordenarSegun:: (a -> a-> Bool) -> [a] -> [a]
ordenarSegun _ [] = []
ordenarSegun criterio (x:xs) = (ordenarSegun criterio . filter (not . criterio x)) xs ++ [x] ++ (ordenarSegun criterio . filter (criterio x)) xs


between :: Ord a => a -> a -> a -> Bool
between cotaInferior cotaSuperior valor =
 valor <= cotaSuperior && valor >= cotaInferior


dto1 = Depto {ambientes = 3, superficie = 80, precio = 7500, barrio = "Palermo"}

deptosDeEjemplo = [
 Depto 3 80 7500 "Palermo",
 Depto 1 45 3500 "Villa Urquiza",
 Depto 2 50 5000 "Palermo",
 Depto 1 45 5500 "Recoleta"]

 {-
    Se pide desarrollar las siguientes funciones y consultas de modo que se aprovechen tanto como sea posible los conceptos de orden superior,
     aplicación parcial y composición.

    Ejercicio 1:

    a)  Definir las funciones mayor y menor que reciban una función y dos valores,
         y retorna true si el resultado de evaluar esa función sobre el primer valor es mayor o menor
          que el resultado de evaluarlo sobre el segundo valor respectivamente.
    b)  Mostrar un ejemplo de cómo se usaría una de estas funciones para ordenar una lista de strings en base a su longitud usando ordenarSegun.
 
 
 -}

-- A)
mayor :: Ord a => (t -> a) -> t -> t -> Bool
mayor f v1 = ((< f v1) . f )

menor ::  Ord a=> (t -> a ) -> t -> t -> Bool
menor f v1 = ((> f v1) . f)

-- B)
-- Ejemplo ordenarSegun (menor length) []

{-
    Ejercicio 2:

    Definir las siguientes funciones para que puedan ser usadas como requisitos de búsqueda:

    a)  ubicadoEn que dada una lista de barrios que le interesan al usuario,
     retorne verdadero si el departamento se encuentra en alguno de los barrios de la lista.
    b)  cumpleRango que a partir de una función y dos números, indique si el valor retornado por la función al ser aplicada
     con el departamento se encuentra entre los dos valores indicados.

-}

-- A)
-- En Clase utilizan `elem` al ser mejor "abstraccion"
ubicadoEn :: Depto -> [Barrio] -> Bool
ubicadoEn dto = any (== barrio dto)

-- B)
cumpleRango :: Ord a => (Depto -> a) -> a -> a -> Depto -> Bool
cumpleRango f inf sup = between inf sup . f

{-
    Ejercicio 3:

    a)  Definir la función cumpleBusqueda que se cumple si todos los requisitos de una búsqueda se verifican para un departamento dado.
    b)  Definir la función buscar que a partir de una búsqueda,
            un criterio de ordenamiento y una lista de departamentos retorne todos aquellos que cumplen con la búsqueda
            ordenados en base al criterio recibido.
    c) Mostrar un ejemplo de uso de buscar para obtener los departamentos de ejemplo, ordenado por mayor superficie, que cumplan con:

        - Encontrarse en Recoleta o Palermo
        - Ser de 1 o 2 ambientes
        - Alquilarse a menos de $6000 por mes

-}

--  A)

cumpleBusqueda :: Depto -> Busqueda -> Bool
cumpleBusqueda dto = all (\ requisito -> requisito dto )
-- Azucar Sintactico : cumpleBusqueda dto = all ($ dto) 

-- B)
buscar :: Busqueda -> (Depto -> Depto -> Bool) -> [Depto] -> [Depto]
buscar busqueda criterio = (ordenarSegun criterio) . filter (`cumpleBusqueda` busqueda)

-- C)
-- ejemplo = buscar [ubicadoEn ["Recoleta", "Palermo"], cumpleRango ambientes 1 2, cumpleRango precio 0 6000] (mayor superficie) datosDeEjemplos

{-
    Ejercicio 4
    
    a)  Definir la función mailsDePersonasInteresadas que a partir de un departamento y una lista de personas retorne
        los mails de las personas que tienen alguna búsqueda que se cumpla para el departamento dado.

-}

-- A)

mailsDePersonasInteresadas :: Depto -> [Persona] -> [Mail]
mailsDePersonasInteresadas dpto = map mail . filter ( any (cumpleBusqueda dpto) . busquedas)