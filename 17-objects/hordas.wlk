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
==============================================================================   OBJECTS - Lecture 05  ========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

class Personaje{
    var property rol
    const property fuerza = 100
    const property inteligencia = 100
    
    method potencialOfensivo()= 10 * fuerza + rol.potencialOfencivoExtra()
    method esInteligente()
	method esGroso() = self.esInteligente() ||rol.esGroso(self)
}	

class Humano inherits Personaje{
	override method esInteligente() = inteligencia > 50
}

class Orco inherits Personaje{
	override method potencialOfensivo() = super() * 1.1
	override method esInteligente() = false
}

/** Roles */

object guerrero {
	method potencialOfencivoExtra() = 100
	method esGroso(oPersonaje) = oPersonaje.fuerza() > 50
}

object brujo{
	method potencialOfencivoExtra() = 0
	method esGroso(oPersonaje) = true
}
 
class Cazador {
	var mascota
	method potencialOfencivoExtra() = mascota.potencialOfensivo()
	method esGroso(oPersonaje) = mascota.esLonjeva()
}

class Mascota {
	const fuerza
	const property edad
	const tieneGarras
	method potencialOfensivo() = if (tieneGarras) fuerza * 2 else fuerza
	method esLonjeva() = edad > 10
}

/** Zonas */

class Ejercito{
	var property miembros = []
	
	method potencialOfensivo () = miembros.sum({
		oMiembro => oMiembro.potencialOfensivo()
	})
	
	method invdadir(oLocalidad){
		if (oLocalidad.potencialDefensivo() < self.potencialOfensivo()){
			oLocalidad.seOcupada(self)
		}
	}
}

class Localidad{
	var property habitantes
	method potencialDefensivo() = habitantes.potencialOfensivo()
	method seOcupada(oEjercito) { habitantes = oEjercito} // Causa efecto, no retorna nada
}

class Ciudad inherits Localidad{
	override method potencialDefensivo() = super() + 300
}

class Aldea inherits Localidad{
	const maxHabitantes = 50
	override method seOcupada(oEjercito) {
		if ( oEjercito.miembros().size() > maxHabitantes ) {
			const nuevosHabitantes = oEjercito.miembros().sortedBy({ oSoldado, oSoldadoB =>
				oSoldado.potencialOfensivo() > oSoldadoB.potencialOfensivo()
			}).take(10)
			
			super(new Ejercito(miembros = nuevosHabitantes))
			
			oEjercito.miembros().removeAll(nuevosHabitantes)
		} else super(oEjercito)
			
	}
}
