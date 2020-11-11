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
==============================================================================   OBJECTS - Lecture 06  ========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*
    Necesitamos modelar la forma en que algunos criaderos de perros se comportan a la hora de cruzar sus animales.

    Ya tenemos representados a los perros, de los cuales nos interesa saber:
        -   si esHembra, 
        -   su velocidad,
        -   su peso
        -   si es adulto 
        -   y su status, 
    como puede verse en la biblioteca.
*/

class Perro {
    const property esHembra = 0.randomUpTo(2).roundUp() > 1
    var property velocidad
    var property fuerza
    var property adulto = false

    method status() = self.fuerza() + self.velocidad()
}


/*
    Sabemos que los criaderos pueden cruzar perros en base a estrategias diversas, lo cual impacta,
    entre otras cosas, en las características que tendrá la cría de ambos perros en caso de que la cruza sea exitosa.

    No todos los criaderos trabajan igual, en particular queremos modelar a los criaderos responsables y a los criaderos irresponsables,
    que se diferencian principalmente en cómo eligen los perros a cruzar y cómo reaccionan en caso de no poder cruzarlos exitosamente.

    Se espera que todos los criaderos entiendan los siguientes mensajes:

    -   recibirPerro(perro), que incorpora al perro al criadero. 
    -   perros(), que retorna el conjunto de perros que tiene el criadero.
    -   cruzar(estrategia), que recibe una estrategia de cruza para luego producir el efecto que corresponda.
*/

/*
    Criaderos

    En general para la cruza de perros, los criaderos usan la estrategia de cruza
    indicada para obtener la cría de dos de sus perros (una hembra y un macho).
    La cría en cuestión debería incorporarse a los perros del criadero.

    Para elegir a la madre, los criaderos irresponsables sólo eligen una de las hembras que hay en el criadero,
    y para el padre uno de los machos.  En cambio los criaderos responsables además aseguran, tanto para el padre como para la madre,
    que sean el macho y hembra con más status de entre los adultos que tienen.

    Otra cosa a tener en cuenta respecto a los criaderos irresponsables es que en caso de que fallen al intentar cruzar los dos perros elegidos
    con la estrategia de cruza indicada, abandona a ambos perros (dejando de formar parte de los perros del criadero) y vuelve a intentar con otros
    perros (hasta que tenga éxito o se quede sin perros para cruzar).
*/

/* Los criaderos tienen y reciben perros, pueden realizar el cruce de ellos, y para esto utilizan distintos criterios de seleccion*/
class Criadero{
    /*Metodos obligatorios por consigna*/
	var property perros = []
	method recibirPerro(oDog) = perros.add(oDog)
	
	method cruzar(oEstrategia) = oEstrategia.cruzar(self)
	
	/* Los siguientes metodos permitirian una facil adicion de otro tipo de criadero*/
	method criterioDeSeleccion() = perros.sortedBy({
			oPerro1, oPerro2 => oPerro1.status() > oPerro2.status()
		}).take(2)

	method tratarPerrosIncompatilbes(oEstrategia, lPerros){
        throw new PerrosIncompatiblesException(message="Perros Incompatibles", perros = lPerros)
    }
}

class CriaderoIrresponsable inherits Criadero{

	override method criterioDeSeleccion(){
		const oPerro = perros.anyOne()

		return [oPerro, perros.filter({
			a => a != oPerro
		}).anyOne()]
	}

	override method tratarPerrosIncompatilbes(oEstrategia, lPerros){
		perros.remove(lPerros.get(0))
		perros.remove(lPerros.get(1))
		self.cruzar(oEstrategia)
	}
}

/* Controlador de seleccion de perros permite liberar la responsabilidad de seleccionar perros de las estrategias y criaderos*/
object oControllerPerros{
	
	method hembra(lPerros) 	= lPerros.find({ oPerro => oPerro.esHembra() })
	method macho(lPerros) 	= lPerros.find({ oPerro => not oPerro.esHembra()})
	
    /*Es necesario el Criadero y no la lista de Perros ya que varia la seleccion de perros segun el criadero*/
	method tomarPerros (oCriadero){
		if(oCriadero.perros().size() >= 2){
			return oCriadero.criterioDeSeleccion()
		}else throw new SinPerrosException(message =
			"No hay suficientes perros", totalPerros = oCriadero.perros().size())
            /*Como el resto de las operaciones dependen de que se obtuvieron ambos perros,
            se lanza una exception si no los consigue*/
	}
	
	method aparear(oEstrategia, lPerros){
        /*La compatibilidad de los perros depende de la estrategia*/
		if(oEstrategia.perrosCompatibles(lPerros.get(0), lPerros.get(1))){
			return new Perro(velocidad= oEstrategia.velocidad(lPerros), fuerza = oEstrategia.fuerza(lPerros))
		}else throw new PerrosIncompatiblesException(message="Perros Incompatibles", perros = lPerros)
	}
}
/*
    Estrategias de Cruza

    Existe más de una forma de cruzar animales, en particular se pide representar las siguientes:

    -   cruzaPareja: la cría resultante de la cruza debería ser un perro cuyos valores para velocidad y fuerza equivalgan a la suma de los valores correspondientes de sus padres dividido 2.
            Por ejemplo, si la madre tiene velocidad 8 y el padre tiene velocidad 6, la cría tendrá velocidad 7.

    -   hembraDominante: la cría resultante de la cruza debería ser un perro cuyos valores para velocidad y fuerza equivalgan al valor
            correspondiente de la madre sumado al 5% del valor correspondiente del padre. Por ejemplo, si la madre tiene velocidad 8 y el padre tiene velocidad 10, la cría tendrá velocidad 8.5.
    
    -   underdog: la cría resultante de la cruza debería ser un perro cuyos valores para velocidad y fuerza equivalgan al mínimo valor
            correspondiente de sus padres, multiplicado por 2. Por ejemplo, si la madre tiene velocidad 8 y el padre tiene velocidad 5, la cría tendrá velocidad 10.

    También debe tenerse en cuenta que para que la cruza sea exitosa, los perros deben ser compatibles.
    En general esto se cumple cuando son de distinto sexo y ambos son adultos,
    pero además en el caso de la estrategia de hembra dominante, la fuerza de la hembra debería superar a la fuerza del macho. 
*/

/* La idea de las estrategias es que varien la fuerza, velocidad y compatibilidad de los perros*/
class Estrategia{

    /*Por norma general, deberan ser adultos y de distinto sexo*/
	method perrosCompatibles(oPerro1, oPerro2){
		return (oPerro1.esHembra() != oPerro2.esHembra()) && oPerro1.adulto() && oPerro2.adulto()
	} 
	
    /*Estos atributos varian de acuerdo a la estrategia*/
	method velocidad(lPerros)
	method fuerza(lPerros)
	
    /*Para obtener un nuevo perro se lo delega al Controlador*/
	method cruzar(oCriadero){
		try{
			oCriadero.recibirPerro(
                oControllerPerros.aparear(
                    self, oControllerPerros.tomarPerros(oCriadero)
                )
            )
		} catch error: PerrosIncompatiblesException{
			oCriadero.tratarPerrosIncompatilbes(self, error.perros())
		}
	}
}

object cruzaPareja inherits Estrategia{
	override method velocidad(lPerros) = lPerros.sum({
		oPerro => oPerro.velocidad()
	}) / 2
	override method fuerza(lPerros) = lPerros.sum({
		oPerro => oPerro.fuerza()
	}) / 2
}

object hembraDominante inherits Estrategia{
	
	override method perrosCompatibles(oPerro1, oPerro2) {
		if(oPerro1.esHembra()) return oPerro1.fuerza() > oPerro2.fuerza() && super(oPerro1, oPerro2)
		else return oPerro2.fuerza() > oPerro1.fuerza()
	}
	
	override method velocidad(lPerros) = 
	oControllerPerros.hembra(lPerros).velocidad() + 0.05 * oControllerPerros.macho(lPerros).velocidad()
	override method fuerza(lPerros)	=
	oControllerPerros.hembra(lPerros).fuerza() + 0.05 * oControllerPerros.macho(lPerros).fuerza()
}

object underdog inherits Estrategia{
	override method velocidad(lPerros) = lPerros.min({
		oPerro => oPerro.velocidad()
	}).velocidad() * 2
	override method fuerza(lPerros) = lPerros.min({
		oPerro => oPerro.fuerza()
	}).fuerza() * 2
}

class SinPerrosException inherits DomainException {
	const property totalPerros
}

class PerrosIncompatiblesException inherits DomainException{
	var property perros
}


/*
    No debería importar el orden en el que se parametricen el macho y la hembra a la estrategia de cruza, el resultado debería ser equivalente.
    El sexo de la cría no es determinístico (va a ser aleatorio independientemente de la estrategia usada), y lógicamente no se espera que sean adultos al nacer.
*/

/*
    Además de lo anterior, se pide definir los métodos crearCriaderoIrresponsable y crearCriaderoResponsable en el objeto creadorDeCriaderos
    que retornen el criadero correspondiente en base a tu modelo para su uso desde las pruebas.
*/

object creadorDeCriaderos {
	method crearCriaderoIrresponsable() = new Criadero()
	method crearCriaderoResponsable() = new CriaderoIrresponsable()
}

/* Objetos de prueba */
const lucas = new Perro(fuerza= 10, velocidad= 10, adulto = true, esHembra = false, nombre = "Lucas")
const laya = new Perro(fuerza= 2, velocidad= 6, adulto = true, esHembra = false, nombre = "Laya")
const laucha = new Perro(fuerza= 7, velocidad= 10, adulto = true, esHembra = false, nombre = "Laucha")
const mPerros = [laya, lucas, laucha]

const criadero1 = new Criadero(perros = mPerros)
const criadero2 = new CriaderoIrresponsable(perros = mPerros)
