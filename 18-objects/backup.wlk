/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* Los criaderos tienen y reciben perros, pueden realizar el cruce de ellos, y para esto utilizan distintos criterios de seleccion*/
class Criadero{
	/*Metodos obligatorios por consigna */
	var property perros = []
	method recibirPerro(oPerro) = perros.add(oPerro)
	method cruzar (oEstrategia) {
		oEstrategia.cruzar(self)
		}
	
	/*Metodos que permitirian anadir mas tipos de criaderos*/
	
	//Devuelve dos perros
	method criterioDeSeleccion()
}

//Este criadero primero no abandona perros
class CriaderoResponsable inherits Criadero{
	
  override method criterioDeSeleccion(){
			const lPerros = perros.sortedBy({
					oPerro1, oPerro2 => oPerro1.status() > oPerro2.status()
				})
				
			if (lPerros.any({ oPerro => oPerro.esHembra()})){
				return [oControllerPerros.macho(lPerros), oControllerPerros.hembra(lPerros)]
			} else return lPerros.take(2)
		}
}

// Si no se puede cruzar a los perros, los abandona
class CriaderoIrresponsable inherits Criadero{
	
	override method criterioDeSeleccion(){
		const oPerro = perros.anyOne()

		return [oPerro, perros.filter({
			a => a != oPerro
		}).anyOne()]
	}
	
	override method cruzar(oEstrategia){
			try{
				oEstrategia.cruzar(self)
			} catch error: PerrosIncompatiblesException{
				self.descartarPerros(error.perros())
				self.cruzar(oEstrategia)
			}
	}
	
	/*Abandona a los perros incomptibles */
	method descartarPerros(aPerros){
		perros.remove(aPerros.get(0))
		perros.remove(aPerros.get(1))
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* Controlador de seleccion de perros permite liberar la responsabilidad de seleccionar perros de las estrategias y criaderos*/
object oControllerPerros{
	
	/*Obtiene el primer perro hembra */
	method hembra(lPerros) 	= lPerros.find({ oPerro => oPerro.esHembra() })
	/*Obtiene el primer perro macho */
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
	
	/*Dada una estrategia y dos perros crea un nuevo perro de ser comatibles */
	method aparear(oEstrategia, lPerros){
        /*La compatibilidad de los perros depende de la estrategia*/
		if(oEstrategia.perrosCompatibles(lPerros.get(0), lPerros.get(1))){
			return new Perro(velocidad= oEstrategia.velocidad(lPerros), fuerza = oEstrategia.fuerza(lPerros))
		}else throw new PerrosIncompatiblesException(message="Perros Incompatibles", perros = lPerros)
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
			oCriadero.recibirPerro(oControllerPerros.aparear(self, oControllerPerros.tomarPerros(oCriadero)))
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
		else return oPerro2.fuerza() > oPerro1.fuerza() && super(oPerro1, oPerro2)
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*Excepcion de que no hay suficientes perros para cruzar*/
class SinPerrosException inherits DomainException {
	const property totalPerros
}

/*Excepcion de perros incompatibles segun la estrategia */
class PerrosIncompatiblesException inherits DomainException{
	var property perros
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Completar acá los métodos para crear los criaderos en base a tu modelo

/*Controlador para la creacion de criaderos*/
object creadorDeCriaderos {
	method crearCriaderoIrresponsable() = new CriaderoIrresponsable()
	method crearCriaderoResponsable() = new CriaderoResponsable()
}
