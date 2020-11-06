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

/*
	Queremos hacer nuestra propia red social en la cual el contenido publicado por los usuarios pueda ser visible por otros usuarios de la red,
	dependiendo de cómo se haya configurado dicho contenido.

	Cuando se crea una publicación se registra el usuario que creó la publicación y la fecha de publicación.
	La misma puede ser:

	
    	> pública, de modo que pueda verla cualquier usuario de la red

    	> privada, de modo que sea visible sólo por los contactos de quien hizo la publicación

    	> con lista negra, de modo que sea visible sólo por los contactos del creador de la publicación que
		no hayan sido excluídos explícitamente para ver ese contenido
		(es similar pero más restrictivo que el contenido privado). 

	Además algunas publicaciones, a las que denominamos historias, sólo son visibles hasta el día siguiente de su publicación por
	aquellos usuarios que correspondan de acuerdo a si la visibilidad de la misma es pública, privada o con lista negra.

	Independientemente de todo lo anterior, quien creó la publicación o historia siempre puede ver su propio contenido.
*/

/*
	Ejemplos de uso:

	> unaPublicacionPrivada.esVisible(unContacto, unaFecha)
  		=> true
 	> unaHistoriaPublica.esVisible(usuarioDesconocido, unaFechaLejana)
  		=> false
*/

/*
    Considerar que en cualquier momento debería poder cambiarse la visibilidad del contenido.
	Por ejemplo, una publicación pública debería poder limitarse para que sea privada, o con una lista negra.

    Los usuarios ya están programados, y entienden el mensaje tieneContacto(unUsuario).

*/

class Usuario {
    const property contactos = #{}

    method tieneContacto(unUsuario) = contactos.contains(unUsuario)

    method agregarContacto(unUsuario){
        self.contactos().add(unUsuario)
    }
}

/*
	Disenio de modelo
*/

class Publicacion {
	const property oUserOwner
	const property oDate
	const property isStory = false
	var property oType
	
	method esVisible(oUser, dDate){
		if(isStory) {
			// Solo deben ser visibles entre El dia de publicacion y el Siguiente
			return if(oUserOwner == oUser) true else (dDate - oDate == 1 || dDate - oDate == 0) && oType.esVisible(oUserOwner, oUser) 
		}else{
			//Aseguro que no la pueda ver antes de que se publique
			return dDate - oDate >= 0 && oType.esVisible(oUserOwner, oUser)
		}
	}
}

object publica{
	//Todos pueden verla
	method esVisible(oPublication, oUser) = true
}

// Clase para herencia
class Privada{
	// Contactos o el mismo usuario
	method esVisible(oUserOwner, oUser) = oUserOwner.tieneContacto(oUser) || oUserOwner == oUser
}
// Unica instancia
const privada = new Privada()

class ConListaNegra inherits Privada{
	// Lista negra
	const property blackList = #{}
	
	override method esVisible(oUserOwner, oUser) {
		return !blackList.contains(oUser) && super(oUserOwner, oUser)
	}
}

/*
	Adicionalmente, se pide completar los métodos del objeto creacionDeContenido
	de modo que creen y retornen el contenido correspondiente en base a tu modelo, para usarlo desde las pruebas.
*/

object creacionDeContenido {
	method crearPublicacionPublica(oUser, dDate) {
		return new Publicacion(oUserOwner = oUser, oDate = dDate, oType = publica)
	}
	method crearPublicacionPrivada(oUser, dDate) {
		return new Publicacion(oUserOwner = oUser, oDate = dDate, oType = privada )
	}
	method crearHistoriaPublica(oUser, dDate) {
		return new Publicacion(oUserOwner = oUser, oDate = dDate, oType = publica, isStory = true)
	}
	method crearHistoriaPrivada(oUser, dDate) {
		return new Publicacion(oUserOwner = oUser, oDate = dDate, oType = privada, isStory = true)
	}
	method crearPublicacionConListaNegra(oUser, dDate, aUsersBlackList) {
		return new Publicacion(oUserOwner = oUser, oDate = dDate,
			oType = new ConListaNegra(blackList = aUsersBlackList)
		)
	}
	method crearHistoriaConListaNegra(oUser, dDate, aUsersBlackList) {
		return new Publicacion(oUserOwner = oUser, oDate = dDate,
			oType = new ConListaNegra(blackList = aUsersBlackList), isStory = true
		)
	}
}