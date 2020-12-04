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
==============================================================================   OBJECTS - EXAM 03  ========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* 
PdeP: Parcial de Plantaciones
PdeP JN - 2020 - Parcial Objetos

Nos piden modelar un software que sirva para registrar el progreso de los cultivos en una granja industrial,
 que dispone de múltiples terrenos en los que se cultivan diversos tipos de cosechas.

La granja dispone de dos tipos diferentes de terreno:
 Campos Abiertos e Invernaderos, de los cuales conocemos el conjunto de Cultivos plantado en cada uno.
*/
class Terreno{
	
	var property cultivos = []
	
	//Punto 1: Depende del tipo de terreno
	method esRico()
	
	//Punto 2: La media nutricional de un terreno es el promedio del valor nutricional de todos sus cultivos.
	method mediaNutricional() = cultivos.sum({
			unCultivo => unCultivo.valorNutricional(self)
		}) / cultivos.size()
	
	//Punto 3 es el valor total de todos sus cultivos menos su costo de mantenimiento.
	method valorNeto() = cultivos.sum({
			unCultivo => unCultivo.valor(self)
		})  - self.costoDeMantenimiento()
	
	
	//Punto 4: Teniendo en cuenta que un terreno no puede exceder su capacidad maxima ni plantar cultivos que no puedan crecer en el
	method plantar(cultivo){
		if(self.puedePlantarse() && cultivo.puedeCrecerEn(self))
			cultivos.add(cultivo)
	}
	method puedePlantarse() = cultivos.size() < self.maximasPlantas()
	
	//Punto 5 -> en Cultivos
	
	method maximasPlantas()
	method costoBase()
	method costoDeMantenimiento()
	
	method admiteArbol() = false
	
}

// Punto 4: Dado planta y terreno, agregar a las  plantaciones del terreno
object plantador{
	method plantar(planta, terreno) = terreno.plantar(planta)
}


/*
    Los Campos Abiertos son, como su nombre indica, parcelas de tierra al aire libre. 
     Cada parcela cuenta con un tamaño distinto (medido en metros cuadrados) y un suelo
    con distinta riqueza mineral que depende de los factores geográficos y climáticos de la zona.
     Cada Campo Abierto tiene un costo de mantenimiento de $500/m2 y permite plantar un máximo de 4 plantas por m2.
*/
class CampoAbierto inherits Terreno{

	const property metro2
	const property suelo
	
	override method costoBase() = 500
	override method costoDeMantenimiento() = self.costoBase() * metro2
	
	override method maximasPlantas() = 4 * metro2
	
	//Punto 1 - A : un Campo Abierto es rico si la riqueza de su suelo es mayor a 100
	override method esRico() = suelo.riqueza() > 100
	
	override method admiteArbol() = true

}
/*
    Por otro lado, los Invernaderos son construcciones artificiales que permiten tener un mayor control de los cultivos,
     utilizando tecnología de punta.
    
    Cada Invernadero se construye a medida (con lo cual, la cantidad máxima de plantas que admite varía) y puede optar por
     uno de tres dispositivos electrónicos disponibles para facilitar el cuidado de las plantas.

    Los dispositivos instalables son un Regulador Nutricional, un Humidificador y un set de Paneles Solares.
    Cada Invernadero instala siempre un único dispositivo pero el diseño modular permite reemplazarlo por otro, de ser necesario.

    Obviamente los Invernaderos son más costosos de mantener que los Campos Abiertos, teniendo un costo base de $50.000
     más el costo de mantenimiento del dispositivo instalado:

    -   Los Reguladores Nutricionales tienen un costo fijo de mantenimiento de $2000.
    -   El costo de los Humidificadores depende de la humedad que tengan configurada: 
        $1000 si la humedad es menor o igual al 30% y $4500 si es mayor.
    -   Los Paneles Solares, por otro lado, permiten ahorrar energía reduciendo el costo de mantenimiento del Invernadero en $25.000.

*/
class Invernadero inherits Terreno{

	var property capacidadMaxima
	var property dispositivo
	
	const property humedadMinima = 0.2
	const property humedadMaxima = 0.4
	
	override method maximasPlantas() = capacidadMaxima
	
	override method costoBase() = 50000
	override method costoDeMantenimiento() = self.costoBase() + dispositivo.costoMantenimiento()
	
	//Punto 1 - B: Es rico si no alcanza la mitad de capacidad o tiene humidificador entre ciertos valores o un regulador nutricional
	override method esRico() = self.mitadDeCapacidad() || dispositivo.humedad().between(humedadMinima, humedadMaxima) || dispositivo.regulaNutricion()
	
	method mitadDeCapacidad() = cultivos.size() < capacidadMaxima * 0.5
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Dispositivos
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

object reguladorNutricional{
	method humedad() = 0
	method regulaNutricion() = true
	method costoMantenimiento() = 2000
	
}

class Humidificador{
	const property humedad
	method regulaNutricion() = false
	method costoMantenimiento() = if(humedad <= 0.3) 1000 else 4500
}

object panelSolar{
	method humedad() = 0
	method regulaNutricion() = false
	method costoMantenimiento() = -25000
}


/*
    En cuanto a los cultivos que la granja trabaja, sabemos que ahora mismo existen 3 (aunque en el futuro podrían incorporarse más):

    - Papa: La papa puede plantarse en cualquier terreno y tiene un valor nutricional de 1500 que se duplica si se la cultiva en un terreno rico.
     El precio de venta del producto de cada planta de papa es la mitad de su valor nutricional.
    
    - Algodón: El algodón no se come, con lo cual su valor nutricional es nulo, pero cada planta de algodón puede venderse a $500.
     Sólo puede plantarse en terreno rico.

    - Árbol Frutal: Los árboles frutales son una inversión a largo plazo. Su valor nutricional es el triple de su edad
     (hasta un máximo de 4000), con lo cual, cuanto más viejo el árbol, más nutritivo!
      Si bien estos son cultivos muy rentables, porque el precio de venta de cada cosecha depende de la fruta que dé el árbol,
      sólo pueden ser plantados en Campo Abierto.

    
    Considerar que un mismo terreno puede tener múltiples plantas de cada tipo.
*/
class Cultivo {

	method valor(terreno)
	method valorNutricional(terreno)
	method puedeCrecerEn(terreno)

}

class Papa inherits Cultivo{

	override method valorNutricional(terreno) = if(terreno.esRico()) 2 * 1500 else 1500
	
	override method valor(terreno) = self.valorNutricional(terreno) * 0.5
	
	override method puedeCrecerEn(terreno) = true

}

class Algodon inherits Cultivo{
	
	override method valorNutricional(terreno) = 0
	
	override method valor(terreno) = 500
	
	override method puedeCrecerEn(terreno) = terreno.esRico()
	
}

class ArbolFrutal inherits Cultivo{
	var property edad
	
	const property fruta
	
	override method valorNutricional(terreno) = 4000.min(3 * edad)
	
	override method valor(terreno) = fruta.valor()
	
	override method puedeCrecerEn(terreno) = terreno.admiteArbol()
	
}

//Punto 5: Aparece un nuevo tipo de Árbol Frutal: Las Palmeras Tropicales.
class Palmera inherits ArbolFrutal{
	
	//El valor nutricional de las palmeras es sólo el doble de su edad (hasta un máximo de 7500).
	override method valorNutricional(terreno) = 7500.min(2 * edad)

	//La fruta de estos árboles frutales tienen un precio 5 veces mayor a los árboles normales
	override method valor(terreno) = 5 * super(terreno)
	
	//Además de los requisitos de los otros árboles, sólo pueden ser plantados en terreno rico. 
	override method puedeCrecerEn(terreno) = terreno.esRico() && super(terreno)
}
/*
    Se pide modelar el problema descripto utilizando los conceptos del Paradigma Orientado a Objetos
     (poniendo especial foco en el uso de Polimorfismo, Encapsulamiento y Delegación y evitando la repetición de lógica siempre que sea posible),
      de forma tal que sea posible realizar las siguientes consultas y operaciones:
*/


/*
    1- Saber si un terreno es rico
    Decimos que un Campo Abierto es rico si la riqueza de su suelo es mayor a 100.
    Los Invernaderos se consideran ricos si los cultivos que tienen plantados no alcanzan la mitad de su capacidad máxima
     o tienen instalado un regulador nutricional o un humidificador configurado entre 20% y 40% de humedad.
*/

/*
    2- Conocer la media nutricional de un terreno
    La media nutricional de un terreno es el promedio del valor nutricional de todos sus cultivos.
*/


/*
    3- Conocer el valor neto de un terreno
    El valor neto de un terreno es el valor total de todos sus cultivos menos su costo de mantenimiento.
*/

/*
    4- Plantar un cultivo en un terreno
    Dada una planta y un terreno, agregarla a las plantaciones del terreno.
    Tener en cuenta que un terreno no puede exceder su capacidad máxima ni plantar cultivos que no puedan crecer en él.
*/

/*
    5- Palmeras
    Aparece un nuevo tipo de Árbol Frutal: Las Palmeras Tropicales.
     La fruta de estos árboles frutales tienen un precio 5 veces mayor a los árboles normales pero,
    además de los requisitos de los otros árboles, sólo pueden ser plantados en terreno rico. 
     El valor nutricional de las palmeras es sólo el doble de su edad (hasta un máximo de 7500).
*/