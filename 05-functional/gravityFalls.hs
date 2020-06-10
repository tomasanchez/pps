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
==============================================================================   Parcial Gravity Falls   ======================================================================
===============================================================================================================================================================================
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------}

{-=============================================================== PARTE I =====================================================================-}

{-
    Ejercicio 1:
                Modelar a las personas, de las cuales nos interesa la edad, cuáles son los ítems que tiene y la cantidad de experiencia que tiene;
                y a las criaturas teniendo en cuenta lo descrito anteriormente, y lo que queremos hacer en el punto siguiente.
-}

data Persona = Persona {
    edad :: Int,
    items :: [String],
    experiencia :: Int
} deriving (Show, Eq)

data Criatura = Criatura {
    nombre :: String,
    categoria :: Int,
    peligrosidad :: Int,
    agrupados  :: Int,
    asuntos :: [Asunto]
}

type Asunto = (Persona -> Bool)
--------------------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 2:
    
    Hacer que una persona se enfrente a una criatura, que implica que si esa persona puede deshacerse de ella gane
    tanta experiencia como la peligrosidad de la criatura, o que se escape (que le suma en 1 la experiencia,
    porque de lo visto se aprende) en caso de que no pueda deshacerse de ella.
-}

enfrentamiento :: Persona -> Criatura -> Persona
enfrentamiento person creature | deshace creature person = person {experiencia = experiencia person + expObtenidaDe creature}
                               | otherwise = person { experiencia = ((+1) . experiencia) person}

deshace ::  Criatura -> Asunto
deshace criat pers | criaturaEs "gnomo" criat = personaTieneItem "soplador de hojas" pers
                   | criaturaEs "fantasma" criat = (cumpleAsuntos pers . asuntos) criat
                   | otherwise = False

cumpleAsuntos :: Persona -> [Asunto] -> Bool
cumpleAsuntos p = all (== True) . map (flip id p)

criaturaEs :: String -> Criatura -> Bool
criaturaEs name = (== name ) . nombre

personaTieneItem :: String -> Asunto
personaTieneItem it = any (== it) . items

expObtenidaDe :: Criatura -> Int
expObtenidaDe criat | criaturaEs "gnomo" criat = 2 ^ (agrupados criat)
                    | criaturaEs "fantasma" criat =  20 * categoria criat
                    | otherwise = 0

-----------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 3:
-}

-- a) Determinar cuánta experiencia es capaz de ganar una persona luego de enfrentar sucesivamente a un grupo de criaturas.

expSucesivosEnfrentamientos :: Persona -> [Criatura] -> Int
expSucesivosEnfrentamientos per =  experiencia . foldl enfrentamiento per

-- b) Mostrar un ejemplo de consulta para el punto anterior incluyendo las siguientes criaturas: 
-- al siempredetras, a un grupo de 10 gnomos, un fantasma categoría 3 que requiere que la persona tenga menos de 13 años y un disfraz de oveja entre sus ítems para que se vaya
-- y un fantasma categoría 1 que requiere que la persona tenga más de 10 de experiencia.

-- Persona
mati :: Persona
mati = Persona {edad = 10, items = ["disfraz de oveja"], experiencia = 0 }

-- Criaturas
unSiempreDetras :: Criatura
unSiempreDetras = Criatura {nombre = "siempredetras", categoria = 0, peligrosidad = 0, agrupados = 0, asuntos = [] }

grupoDeGnomos ::  Criatura
grupoDeGnomos = Criatura {nombre = "gnomo", categoria = 0, peligrosidad = 2, agrupados = 10, asuntos = [] }

fantasmon :: Criatura
fantasmon = Criatura {nombre = "fantasma", categoria = 3, peligrosidad = 60, agrupados = 0, asuntos = [tieneMenosDe13, tieneDisfrazOveja] }

fantasmin :: Criatura
fantasmin = Criatura {nombre = "fantasma", categoria = 1, peligrosidad = 20, agrupados = 0, asuntos = [tieneMasExp10] }

-- Asuntos Fantasmales
tieneMenosDe13 :: Asunto
tieneMenosDe13 = (<= 13 ). edad
tieneDisfrazOveja :: Asunto
tieneDisfrazOveja = personaTieneItem "disfraz de oveja"
tieneMasExp10 :: Asunto
tieneMasExp10 = (>= 10 ). experiencia 

-- Ejemplo
monstruos :: [Criatura]
monstruos = [fantasmin, fantasmon, grupoDeGnomos, unSiempreDetras]

-- Consulta = expSucesivosEnfrentamientos mati monstruos


{-=============================================================== PARTE II =====================================================================-}

{-
    Ejercicio 1:
            Definir recursivamente la función:

                zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]

            que a partir de dos listas retorne una lista donde cada elemento:

                - se corresponda con el elemento de la segunda lista, en caso de que el mismo no cumpla con la condición indicada
                - en el caso contrario, debería usarse el resultado de aplicar la primer función con el par de elementos de dichas listas

            Sólo debería avanzarse sobre los elementos de la primer lista cuando la condición se cumple. 
            > zipWithIf (*) even [10..50] [1..7]

            [1,20,3,44,5,72,7] ← porque [1, 2*10, 3, 4*11, 5, 6*12, 7]
-}

zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
zipWithIf _ _ [] _ = []
zipWithIf _ _ _ [] = []
zipWithIf conv criterio (a:a2) (b:b2)
 | criterio b = conv a b : zipWithIf conv criterio a2 b2
 | otherwise = b : zipWithIf conv criterio (a:a2) b2

----------------------------------------------------------------------------------------------------------------------------------------------------------

{-
    Ejercicio 2:
    Notamos que la mayoría de los códigos del diario están escritos en código César,
    que es una simple sustitución de todas las letras por otras que se encuentran a la misma distancia en el abecedario.
    Por ejemplo, si para encriptar un mensaje se sustituyó la a por la x, la b por la y, la c por la z, la d por la a, la e por la b, etc.. 
    Luego el texto "jrzel zrfaxal!" que fue encriptado de esa forma se desencriptaría como "mucho cuidado!".
-}

-- a) Hacer una función que retorne las letras del abecedario empezando por la letra indicada. 
--    O sea, abecedarioDesde 'y' debería retornar 'y':'z':['a' .. 'x'].

abecedarioDesde :: Char -> [Char]
abecedarioDesde letra =  [letra..'z'] ++ filter (/= letra)['a'..letra]

-- b) Hacer una funcion que a partir una letra clave (la que reemplazaría a la a)
--  y la letra que queremos desencriptar, retorna la letra que se corresponde con esta última en el abecedario que empieza con la letra clave.
--  Por ejemplo: desencriptarLetra 'x' 'b' retornaría 'e'.

desencriptarLetra :: Char -> Char -> Char
desencriptarLetra nuevaA encriptado = (head . head . filter (tengaEncriptado encriptado) . zipWith (concatenarLetras) (abecedarioDesde 'a') . abecedarioDesde) nuevaA
-- Hint: se puede resolver este problema sin tener que hacer cuentas para calcular índices

concatenarLetras :: Char -> Char -> [Char]
concatenarLetras a b = a : [b]

tengaEncriptado :: Char -> [Char] -> Bool
tengaEncriptado char (c1:c2:_) = c2 == char

-- c) Definir la función que recibe la letra clave y un texto encriptado y retorna todo el texto desencriptado, 
-- teniendo en cuenta que cualquier caracter del mensaje encriptado que no sea una letra (por ejemplo '!') se mantiene igual.
-- Usar zipWithIf para resolver este problema.

cesar :: Char -> String -> String 
cesar nuevaA palabra = zipWithIf (encriptarLetra) seaLetra (replicate (length palabra) nuevaA) palabra

encriptarLetra :: Char -> Char -> Char
encriptarLetra nuevaA encrip = (head . head . filter (tengaEncriptado encrip) . zipWith (concatenarLetras) (abecedarioDesde nuevaA) . abecedarioDesde) 'a'
-- Estoy repitiendo la logica de encriptar, pero 

desCesar :: Char -> String -> String
desCesar nuevaA str = cesar (desencriptarLetra nuevaA 'a') str

seaLetra :: Char -> Bool
seaLetra c = any (== c) $ abecedarioDesde 'a'

-- d) Realizar una consulta para obtener todas las posibles desencripciones (una por cada letra del abecedario)
--    usando cesar para el texto "jrzel zrfaxal!".

todasLasPosibles :: String -> [String]
todasLasPosibles str = map (`desCesar` str) ['a'..'z']

{-
    [!] [BONUS] EJERCICIO 3:

    Un problema que tiene el cifrado César para quienes quieren ocultar el mensaje es que es muy fácil de desencriptar,
    y por eso es que los mensajes más importantes del diario están encriptados con cifrado Vigenére,
    que se basa en la idea del código César, pero lo hace a partir de un texto clave en vez de una sola letra.
    Supongamos que la clave es "pdep" y el mensaje encriptado es "wrpp, irhd to qjcgs!".

    Primero repetimos la clave para poder alinear cada letra del mensaje con una letra de la clave:
    pdep  pdep pd eppde
    wrpp, irhd to qjcgs!

    Después desencriptamos cada letra de la misma forma que se hacía en el código César (si p es a, w es h...).
    pdep  pdep pd eppde
    wrpp, irhd to qjcgs!
    -------------------
    hola, todo el mundo!

-}