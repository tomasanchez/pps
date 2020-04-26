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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Ejercicio 1 :

    1- Declarar el tipo de dato Ficha.
    2- Defini{ la función crearFicha que a partir de 2 números retorna una ficha.
    3- Definir la función esLaMismaFicha, que dadas dos fichas se cumple cuando son iguales, o bien la primera tiene los mismos valores que la segunda pero en el orden inverso. 

    Resolver este problema sin pattern matching.

    Se espera poder usar el programa de esta forma:

        esLaMismaFicha (crearFicha 1 4) (crearFicha 1 4)
        > True
        esLaMismaFicha (crearFicha 1 4) (crearFicha 4 1)
        > True
        esLaMismaFicha (crearFicha 1 3) (crearFicha 1 4)
        >False
-}

-- Defining data type Ficha, constructor HAS to have same name
data Ficha = Ficha { 
        primeraFicha :: Int,
        segundaFicha :: Int
    } deriving (Eq, Show)

-- We can have a more specific name with creating a new function that duplicates its behaviour
crearFicha = Ficha

esLaMismaFicha :: Ficha ->  Ficha -> Bool
esLaMismaFicha ficha1 ficha2 | ((primeraFicha ficha1) == (primeraFicha ficha2)) = (segundaFicha ficha1) == (segundaFicha ficha2)
                             | ((primeraFicha ficha1) == (segundaFicha ficha2)) = (segundaFicha ficha1) == (primeraFicha ficha2)
                             | ((segundaFicha ficha1) == (primeraFicha ficha2)) = (primeraFicha ficha1) == (segundaFicha ficha2)
                             | otherwise = False

{-  Ejercicio 2:

    Tenemos el siguiente modelo de datos para trabajar con teléfonos celulares (Celular y Linea)

    Necesitamos definir una función

        promoRecarga :: Int -> Celular -> Celular

    que, a partir del monto pagado y el celular a recargar, realice la recarga considerando que:

    1. Los de "Personal" duplican su carga actual y a eso le suman el monto pagado,
    2. Los de "Movistar" con código de área "011" aumentan el saldo en el triple del monto pagado,
    3. Todos los demás aumentan el saldo solamente en el monto pagado. 
-}

{- Por Consigna -}
data Celular = Celular {
  linea :: Linea,
  saldo :: Int,
  proveedor :: String
} deriving (Show, Eq)

{- Por Consigna -}
data Linea = Linea {
  codigoDeArea :: String,
  numeroTelefonico :: String
} deriving (Show, Eq)

{- Usando ```Guardas```  -}
promoRecarga :: Int -> Celular -> Celular
promoRecarga carga celular | (proveedor celular == "Personal") = celular { saldo = ((saldo celular)* 2) + carga }
                           | (proveedor celular == "Movistar") && (codigoDeArea (linea celular) == "011" ) = celular { saldo = (saldo celular) + (carga * 3)}
                           | otherwise = celular { saldo = (saldo celular) + carga }
                        