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
==============================================================================   OBJECTS - Lecture 08  ========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
// --------------------------------------------------------------------------------------------------
//  S U P E R C O M P U T A D O R A S
// --------------------------------------------------------------------------------------------------
class Equipo{
    var property  oModo = standard
    var property isQuemado = false

    method consumoBase()
    method computoBase()
    method computar(oProblema){
        if(oProblema.complejidad() > self.computo() )
            throw new DomainException(message = "Capacidad de computo excedida")
        oModo.realizarComputo(self)
    }

    method estaActivo() = !isQuemado && self.computo() > 0
    method consumo() = oModo.consumoDe(self)
    method computo() = oModo.conputoDe(self)
    method computoExtraPorOverclock()

}

class A105 inherits Equipo{
    override method consumoBase() = 300
    override method computoBase() = 600
    override method computoExtraPorOverclock() = self.computoBase() * 0.3

    override method computar(oProblema){

        if(oProblema.complejidad() < 5 )
            throw new DomainException(message = "Error de fabrica")
        else
            super(oProblema)
    }
}

class B2 inherits Equipo{
    const microsInstalados

    override method consumoBase() = 10 + 50 * microsInstalados 
    override method computoBase() = 800.min(100 * microsInstalados)
    override method computoExtraPorOverclock() = microsInstalados * 20
}


class SuperComputadora{
    const lEquipos = []
    var totalDeComplejidadComputada = 0

    method estaActivo() = true

    method computo() = self.lEquiposActivos().sum({
        oEquipo => oEquipo.computo()
    })
    
    method consumo() = self.lEquiposActivos().sum({
        oEquipo => oEquipo.consumo()
    })


    method equiposActivos() = lEquipos.filter({
            oEquipo => oEquipo.estaActivo()
        })

    method equipoQueMasConsume() = lEquipos.max({
        oEquipo => oEquipo.consumo()
    })
    method equipoQueMasComputa() = lEquipos.max({
        oEquipo => oEquipo.computa()
    })
    method malConfigurada() = self.lEquiposActivos().equipoQueMasConsume() != self.lEquiposActivos().equipoQueMasComputa()

    method computar(oProblema){

        const oSubProblema = oProblema.complejidad() / self.equiposActivos().size()    
        
        self.equiposActivos().forEach({
            oEquipo => oEquipo.computar( oSubProblema))  
        })

        totalDeComplejidadComputada += oProblema.complejidad()
    }
}
// --------------------------------------------------------------------------------------------------
//  M O D O S
// --------------------------------------------------------------------------------------------------

object standard{
    method consumoDe(oEquipo) = oEquipo.consumoBase()
    method computoDe(oEquipo) = oEquipo.computoBase()
    method realizarComputo(oEquipo) {}
}

class Overclock{
    var usosRestantes

    // Verificacion que usos restantes siempre sea positivo
    override method initialize(){
        if(usosRestantes < 0)
            throw new DomainException(message= "Se debe cumplir que: usosRestantes>= 0")
    }

    method consumoDe(oEquipo) = oEquipo.consumoBase() * 2
    method computoDe(oEquipo) = oEquipo.computoBase() + oEquipo.computoExtraPorOverclock()
    method realizarComputo(oEquipo) {

        if(usosRestantes  == 0){
            oEquipo.estaQumead(true)
            throw new DomainException(message = "Equipo quemado!")
        }

        usosRestantes -= 1
    }

}

class AhorroDeEnergia{
    var computosRealizados = 0

    method periocidadDeError() = 17

    method consumoDe(oEquipo) = 200
    method computoDe(oEquipo) = oEquipo.consumo() / oEquipo.consumoBase() * oEquipo.computoBase()
    method realizarComputo(oEquipo){
        computosRealizados += 1
        if(computosRealizados % self.periocidadDeError()) 
            throw new DomainException(message="Corriendo monitor")
    }
}

class APruebaDeFallos inherits AhorroDeEnergia{
    override method periocidadDeError = 100
    
    override method computoDe(oEquipo) = super(oEquipo) / 2
}

// --------------------------------------------------------------------------------------------------
//  P R O B L E M A S
// --------------------------------------------------------------------------------------------------

class Problema{
    const property complejidad()
}

// --------------------------------------------------------------------------------------------------
//  T E O R I A
// --------------------------------------------------------------------------------------------------