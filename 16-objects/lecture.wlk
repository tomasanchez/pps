/*
    MIT License

    Copyright (c) 2020 Tomas Sanchez

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and or sell
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
==============================================================================   OBJECts - Lecture 04  ========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

class A{
    method m2() = 2
    method m4() = self.m5()
    method m5() = 5
}

class B inherits A {
    override method m2() = self.m3()
    method m3() = 8
    override method m4() = super()
}

class C inherits B{
    method m1() = self.m2()
    override method m3() = self.m4()
    override method m5() = 9
}

class D inherits C{
    override method m3() = 26
    override method m4() = 41
    override method m5() = 6
}

/* Que se obtiene con?
    new C().m1()

    m1 -> m2
    m2(B) -> m3
    m3(C) -> m4
    m4(B) -> m4(A)
    m4(A) -> m5(C)
    m5(C) -> 9
*/

/*
    Que pasa si se elimina
    override method m4() = super() en B

    -Nada, recorre lo mismo, ya que de todasa  maneras el lookUp se haria en A al ser heredado
*/

class Tanque{
    const armas = []
    const tripulantes = 2
    var salud = 1000
    var propery prendidoFuego = false

    method emiteCalor() = prendidoFuego || tripulantes > 3

    method sufrirDanio(vDanio){
        salud -= vDanio
    }

    method atacar(oObjective){
        armas.anyOne().dispararA(oObjective)
    }
}

class TanqueBlindado inherits Tanque{

    const blindaje = 200

    override method emiteCalor() = false

    override method sufrirDanio(danio){
        if (danio > blindaje)
        /*Notese como se modifica el parametro*/
        super(danio - blidaje)
    }

}

/*Podemos agrupar nuestro lanzallamas y matafuegos en una super-clase Rociador*/
class Rociador inherits Recargable{

    method dispararA(oObjective){
        cargador -= self.descargaPorRafaga()
        self.causarEfecto(oObjective)
    }

    /*Template Method*/
    method causarEfecto(oObjective)
    method descargaPorRafaga = 20
}

class Matafuego inherits Rociador{
    method causarEfecto(oObjective){
       oObjective.prendidoFuego(false)
   }
}

class Lanzallamas inherits Rociador{
    method causarEfecto(oObjective){
       oObjective.prendidoFuego(true)
   }
}

class Sellador inherits Rociador{
    method causarEfecto(oObjective){
        oObjective.salud(oObjective.salud() * 1.1)
    }

    overide method descargaPorRafaga = 25
}