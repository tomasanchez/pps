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

Ejercicio 1:
    Dadas las funciones:

        f a b c d = b || div a d == c
        g a = length (show a) > 3
 
Reescribir ambas funciones de modo que se definan en base a una composición de funciones en vez de aplicaciones anidadas.

    Resolvelo usando composición y aplicación parcial todo lo que puedas.
-}

-- Reescribir f

--f :: Integral a => a -> Bool -> a -> a -> Bool
f a b c d = ((b ||) . (div a d ==) ) c

--Reescribida:
g :: Show a => a -> Bool
g = (>3) . length . show

{-
    Ejercicio 2:

    Tenemos un programa que cuenta con las siguientes abstracciones:

    data Cafe = Cafe {
        intensidad :: Int,
        temperatura :: Int,
        ml :: Int
    } deriving (Show, Eq)
    
    molerGranos :: Gramos -> Gramos
    prepararCafe :: Agua -> Gramos -> Cafe
    servirEnVaso :: Vaso -> Cafe -> Cafe
    licuar :: Segundos -> Leche -> Cafe -> Cafe
    agregarHielo :: Hielos -> Cafe -> Cafe

    

    Las funciones armarFrapu y armarCafe deben definirse combinando las funciones provistas de modo que se aprovechen los conceptos de composición y aplicación parcial.

    Todos los tipos que se mencionan más allá de Cafe son simplemente un alias de Int, a modo orientantivo.

-}

{-  Resolucion:

    Nota al abstraerse de las funciones lo resuelvo como comentario

    armarCafe :: Vaso -> Gramos -> Cafe
    armarCafe tam g = ((servirEnVaso tam) . (prepararCafe 1000 ) . molerGranos) g

    armarFrapu :: Gramos -> Cafe
    armarFrapu =  (servirEnVaso 400) . (licuar 60 120 ) . (agregarHielo 6) . (prepararCafe 80) . molerGranos

-}