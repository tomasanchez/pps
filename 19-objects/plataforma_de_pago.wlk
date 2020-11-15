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
==============================================================================   OBJECTS - Lecture 07  ========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
// --------------------------------------------------------------------------------------------------
//  C O N T E N I D O
// --------------------------------------------------------------------------------------------------

class Contenido{
    const property titulo
    var property vistas = 0
    const property isOfensivo = false
    var property oMonetizacion

    method oMonetizacion(oNewMonetizacion){
        if(oNewoMonetizacion().puedeAplicarse(self))
            throw new DomainException(message="El contenido no soporta la monetizacion aplicada")
        
        monetizacion = oNewMonetizacion
    }

    /*Metodo que se llama a la hora de tirar un new */
    override method initialize(){
        if(!oMonetizacion.puedeAplicarse(self))
            throw new DomainException(message="El contenido no soporta la monetizacion aplicada")
    }

    method puedeVenderse = self.esPopular()
    method puedeAlquilarse()
    method esPopular()
    method recaudacion() = oMonetizacion.recaudacion(self)
    
    method recaudacionMaximaParaPublicidad()

}

class Video inherits Contenido{
    override method esPopular() =  vistas > 10000
    override method puedeAlquilarse() = true
    override method recaudacionMaximaParaPublicidad() = 10000
}

class Imagen inherits Contenido{
    const property tags = []

    override method puedeAlquilarse = falses

    override method esPopular() = tagsDeModa.all({
        tagModa => tags.contains(tagModa)
    })

    override method recaudacionMaximaParaPublicidad() = 4000
}

const tagsDeModa = []

// --------------------------------------------------------------------------------------------------
//  M O N E T I Z A C I O N E S
// --------------------------------------------------------------------------------------------------

object Publicidad{

    method recaudacion(oContenido) = (0.05 * oContenido.vistas() + if(oContenido.esPopular()) 2000 else 0).min(oContenido
                                    .recaudacionMaximaParaPublicidad())
    
    method puedeAplicarse(oContenido) = ! oContenido.isOfensivo()
}

class Donacion{
    var property donaciones = 0
    method recaudacion(oContenido) = donaciones
}

class Descarga{
    const property precio

    method recaudacion(oContenido) = oContenido.vistas() * precio

    method puedeAplicarseA(oContenido) = oContenido.puedeVenderse()
}

/*Monetizacion agregada*/
class Alquler inherits Descarga{
    override precio() = 1.max(super())

    override method puedeAplicarse(oContenido) = super(oContenido) && oContenido.puedeAlquilarse()
}

// --------------------------------------------------------------------------------------------------
//  U S U A R I O S
// --------------------------------------------------------------------------------------------------
object userManager{
    const property aUsuarios = []

    method emailUsuariosRicos() = aUsuarios.filter({
        oUser => oUser.isVerificado()
    }).sortedBy({
        a, b => a.saldoTotal() > b.saldoTotal()
    }).take(100).map({
        oUser => oUser.email()
    })

    method cantidadSuperUsuarios() = aUsuarios.count({
        oUsuario => oUsuario.isSuperUsuario()
    })
        
}

class Usuario{
    const property nombre
    const property email
    var property isVerificado = false
    const property aContenidos = []

    method isSuperUsuario() = aContenidos.count({
        oContent => oContent.esPopular()
    }) >= 10

    method saldoTotal = aContenidos.sum({
        contenido => contenidp.recaudacion()
    })

    method publicar (oContenenido) = aContenidos.add(oContent)
}

// --------------------------------------------------------------------------------------------------
//  T E O R I A
// --------------------------------------------------------------------------------------------------

/*
    1. ¿Cuáles de los siguientes requerimientos te parece que sería el más fácil y cuál el más difícil de implementar en la solución que modelaste? Responder relacionando cada caso con conceptos del paradigma.
      1. Agregar un nuevo tipo de contenido.
      2. Permitir cambiar el tipo de un contenido (e.j.: convertir un video a imagen).
      3. Agregar un nuevo estado “verificación fallida” a los usuarios, que no les permita cargar ningún nuevo contenido.

    Agregar un nuevo tipo de contenido es muy sencillo. Esto se da por la forma en que esta programada, donde hay clases absatractas y se utilizan metodos dependientes del conetnido.

    Cambiar el tipo de contenido es una adaptacion mas dificil por la herencia, deberia crear una clase abstracta que haga de interfaz entre los "tipos de contenido".

    Agregar un nuevo estado, deberia pasarse de booleano a un objeto

*/

/*
    2. ¿En qué parte de tu solución se está aprovechando más el uso de polimorfismo? ¿Porqué?

    En el calculo de Saldo Total y Recaudacion. Donde no importa que tipo de contenido y monetizacion son, y simplemente se suman.
*/