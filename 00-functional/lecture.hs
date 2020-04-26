{- 
    MIT License

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

--------------------------------------------------------------------------------------------------------------------------------

Ejercicio 1 :

Sabiendo que existe la función mod que dados dos números enteros nos retorna el resto de la división del primero por el segundo,
 definí la función esImpar usando mod de modo que:

    esImpar 7
        > True
    esImpar 2
        > False
    esImpar 0
        > False
 
Además de definir la función, explicitá su tipo de modo que acepte como parámetro valores de tipo Int.

-}

{- Tipado: Retorna bool y mod toma Int, therefore esImpar debe tomar Int    -}
esImpar :: Int -> Bool
esImpar numero = mod numero 2 /= 0

{- Ejercicio 2
Desarrollar una función leGanaA que dados dos strings que pueden ser "piedra", "papel" o "tijera",
 nos dice si el primero le gana al segundo de acuerdo a las bien conocidas reglas de este juego:

    Piedra le gana a tijera
    Tijera le gana a papel
    Papel le gana a piedra 

    "piedra" `leGanaA` "papel"
        > False
    "tijera" `leGanaA` "papel"
        > True
    "papel" `leGanaA` "papel"
        > False

    Resolver por pattern matching
-}

{-  Esta muy claro que toma dos String y returnea un Bool-}
leGana :: String -> String -> Bool
leGana "piedra" "tijera" = True
leGana "papel" "piedra" = True
leGana "tijera" "papel" = True
leGana _ _ = False
{- Por patter-matching tenemos predifinidos y para el resto de los casos tenemos un escape a Falso  -}

{-  Ejercicio 3:

    Queremos saber si una palabra es áurica, que se cumple si la misma tiene entre 3 y 7 letras.

    La cantidad de letras de un String se puede obtener con la función length.

    Para resolver este problema, se pide también definir y usar una función auxiliar estaEntre que dados tres números enteros,
     retorne verdadero si el último es mayor o igual al primero y menor o igual al segundo.
-}

estaEntre :: Ord a => a -> a -> a -> Bool
estaEntre prim seg ult = (prim <= ult) && (seg >= ult)

esAurica :: String -> Bool
esAurica string = estaEntre 3 7 (length string)