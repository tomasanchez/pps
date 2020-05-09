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

    Ejercicio 1:

    Definir una función esMejorAplicado que dado un criterio de comparación, una función y un valor retorne
        True si el resultado de aplicar la función con el valor es mejor (basado en lo que el criterio determine) que el valor original.

    También explicitar el tipo de esMejorAplicado.

        esMejorAplicado (>) (*2) 5
            >   True
        esMejorAplicado (<) (*2) 5
            >   False


-}


esMejorAplicado :: ( a -> a -> Bool) -> (a -> a) -> a -> Bool
esMejorAplicado criterio funcion valor = ((`criterio` valor) . funcion) valor


{-
    Ejercicio 2:

    El sistema de recursos humanos de una empresa tiene representados a los empleados de la siguiente forma:

        data Empleado = Empleado {
            rol :: String,
            edad :: Int,
            tareas :: [String]
        } deriving (Show, Eq)
 

También tenemos disponibles algunos empleados de ejemplo para poder probar la solución.

Necesitamos desarrollar una función para conocer, a partir de un conjunto de empleados, cuáles son roles atareados.
Se considera que un rol es atreado cuando la persona con dicho rol realiza dos tareas o más.

 rolesAtareados [victoria, lautaro, ruben, pancracio, laura]
    >   ["contador", "legales"]
 
 Resolver este problema usando composición, aplicación parcial y orden superior.

-}

{- ==============================================================================================================================
                                                    Datos cargados en ejercico
   ==============================================================================================================================
-}

data Empleado = Empleado {
            rol :: String,
            edad :: Int,
            tareas :: [String]
        } deriving (Show, Eq)

victoria    = Empleado{rol = "rrhh", edad = 45, tareas = ["entrevistar"]}
lautaro     = Empleado {rol = "contador", edad = 26, tareas = ["liquidar sueldos","presentar ganancias","cargar facturas"]}
ruben       = Empleado {rol = "legales", edad = 70, tareas = ["resolver litigios"]}
pancracio   = Empleado {rol = "contador", edad = 70, tareas = []}
laura       = Empleado {rol = "legales", edad = 35, tareas = ["resolver litigios","papeleo"]}
juan = Empleado {rol = "rrhh", edad = 25, tareas = []}
{- ==============================================================================================================================
                                                  Fin Datos cargados en ejercico
   ==============================================================================================================================
-}

rolesAtareados :: [Empleado] -> [String]
rolesAtareados = ((map rol) . filtradoDeRoles)

filtradoDeRoles :: [Empleado] -> [Empleado]
filtradoDeRoles = filter (\empleado -> length (tareas empleado) >= 2)

{-

    Ejercicio 3:

    Siguiendo con el mismo modelo de dominio, necesitamos saber a partir de un conjunto de empleados si hay empleados que se jubilaron.

    Decimos que hay jubilados si, de entre aquellos empleados que no tienen ninguna tarea, existe alguno que haya cumplido los 65 años.

    hayJubilados [lautaro, victoria, ruben, pancracio, laura, juan]
        >   True
    hayJubilados [lautaro, victoria, ruben, laura, juan]
        >   False

    Resolver este problema usando composición, aplicación parcial y orden superior.

-}

hayJubilados :: [Empleado] -> Bool
hayJubilados = ((any null) . (map tareas) . filter (\empleado -> edad empleado >= 65))

{-
    Ejercicio 4:

    Necesitamos desarrollar una función para efectuar una serie de transacciones sobre una cuenta bancaria.

        El modelo con el que trabajamos es el siguiente:

            data Cuenta = Cuenta {
            saldo :: Int,
            saldoMaximo :: Int
            } deriving (Show, Eq)

            data Transaccion = Transaccion {
            id :: String,
            monto :: Int
            } deriving (Show, Eq)
 
    Ya se dispone de una función

            modificarSaldo :: Int -> Cuenta -> Cuenta

    que se encarga de manipular el saldo de la cuenta, respetando las normas de negocio
    requeridas por el banco relativa a los límites de cuentas (si se deposita más del límite de la cuenta, el excedente se pierde).

    Se pide desarrollar una función

    realizarTransacciones :: [Transaccion] -> Cuenta -> Cuenta

    que modifique el saldo de la cuenta en base a los montos indicados, respetando el orden en el que se reciben.

-}


data Cuenta = Cuenta {
    saldo :: Int,
    saldoMaximo :: Int
    } deriving (Show, Eq)

data Transaccion = Transaccion {
    idx :: String,
    monto :: Int
    } deriving (Show, Eq)

modificarSaldo :: Int -> Cuenta -> Cuenta
modificarSaldo n cuenta = cuenta {saldo = (saldo cuenta) + n}

realizarTransacciones :: [Transaccion] -> Cuenta -> Cuenta
realizarTransacciones transacciones cta | null transacciones = cta
                                        | otherwise = (foldl1 sumarSaldos . map ajustarSaldos . map (`modificarSaldo` cta). map monto) transacciones

ajustarSaldos :: Cuenta -> Cuenta
ajustarSaldos cta = cta {saldo = min (saldo cta) (saldoMaximo cta)}

sumarSaldos :: Cuenta -> Cuenta -> Cuenta
sumarSaldos ct1 ct2 = ct1 {saldo = min (saldoMaximo ct1) (saldo ct1 + saldo ct2)}


{-========================== T E S T ==========================-}
viki = Cuenta { saldo = 0, saldoMaximo = 1000}
t1 = Transaccion {idx = "test1", monto = 100 }
t2 = Transaccion {idx = "test2", monto = 200 }
t3 = Transaccion {idx = "test3", monto = -300 }
t4 = Transaccion {idx = "test4", monto = 10000 }
t5 = Transaccion {idx = "test5", monto = -500 }
