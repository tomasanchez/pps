# 04 - Objetos

## Temas Vistos

- Herencia (Simple)
  - Superclase
  - Subclase
  - Generalizacion
  - Method LookUp
- Clases Abstractas
- Metodos Abstractos
- Redefinicion
  - Super


## Herencia

Si bien vimos clases, estas se quedan corta cuando el problema escala.

Supongamos el siguiente dominio de tanques, donde un tanque tiene que poder atacar a otro tanque y depende ciertos parametros, disminuye la salud del otro tanque.

```wlk

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
```

Notese como se utiliza "armas" que servira para conceptualizar la herencia.

```wlk
object lanzallamas{

    method dispararA(oObjective){
        oObjective.prendidoFuego(true)
    }
}

class Misil {
    const potencia

    method dispararA(oObjective){
        oObjective.sufrirDanio(potencia)
    }
}
```

Vemos como las *class* nos permite evitar repetir codigo para cada misil, pudiendo instanciar cantidades de misiles.

```wlk
object metrallaChica{
    const property calibre = 12
    method disparar(oObjective)
        //Calibre muy chico! no causa danio
}

object metrallaMediana{
    const property calibre = 16
    method disparar(oObjective){
        oObjective.sufrirDanio(4)
    }
}

object metrallaGrande{
    const property calibre = 22
    method disparar(oObjective){
        oObjective.sufrirDanio(4)
    }
}

```

Si bien esto podemos salvarlo con una class

```wlk
class Metralla {
    const property calibre
    method dispararA(oObjective){
        if(calibre > 50)
        oObjective.sufrirDanio(calibre/4)
    }
}
```

Modificando el dominio para que no disparen infinitamente...

```wlk
class lanzallamas{

    var cargador = 100

    method agotada() = cargador <=0

    method dispararA(oObjective){
        oObjective.prendidoFuego(true)
    }
}

class Metralla {
    const property calibre
    var cargador = 100

    method agotada() = cargador <= 0

    method dispararA(oObjective){
        if(calibre > 50)
        oObjective.sufrirDanio(calibre/4)
    }
}
```

Aqui es cuando notamos que estamos repitiendo ciertos aspectos `cargador` `agodata()` y aqui es cuando entra en juego la **Herencia**, la cual permite relacionar clases, bajo la misma idea que cuando necesitabamos ahorrarnos objetos, creabamos clases.

Con esta idea, tendremos **Superclases** y **Subclases**. Vale aclarar que cada tecnologia permite esto de manera distinta, en este caso, Wollok trabaja con **herencia simple**, donde solo pueden heredar de una unica clase.

Como Premisa, toda clase tiene una unica Superclase, de no aclararse es *Object*.

Una clase abstracta es aquella que permite relacionar clases sin instanciarse nunca. Cabe destacar que la herencia no acaba con el polimorfismo, por lo cual no es necesario que un objeto/clase deba heredar si o si de otra para usar el mismo mensaje.

En nuestro ejemplo

```mlk
class Recargable {
    var cargador = 100

    method recargar() {cargador = 100 }

    method agotada() = cargador <=0
}

class lanzallamas inherits Recargable{

    method dispararA(oObjective){
        cargador -= 20
        oObjective.prendidoFuego(true)
    }
}

class Metralla inherits Recargable{

    const property calibre

    method dispararA(oObjective){
        cargador -= 10
        if(calibre > 50)
        oObjective.sufrirDanio(calibre/4)
    }
```

Vemos como podemos simplificar nuestras clases originales haciendo que hereden de esta clase abstracta Recargable.

## Redefinicion o Sobre-escritura

Pensemos partciularmente en la clase misil. Donde ahora incorporamos un Misil Termico, que se dispara solo si el objetivo emite calor. Este nuevo misil no puede estar a la misma altura que nuestra clase Misil, ya que practicamente implementa lo mismo salvo la nueva restriccion del rastreo de calor.

```wlk

class Misil{
    const potencia
    var agotada = false

    method agotada() = agotada

    method dispararA(oObjective){
        agotada = ture
        oObjective.sufrirDanio(potencia)
    }
}

class MisilTermico inherits Misil {

    override method dispararA(oObjective){
        if (oObjective.emiteCalor()){
            agotada = true
            oObjective.sufrirDanio(potencia)
        }
    }
}

```

Notese que se debe respetar la naturaleza del dominio, seria incorrecto plantear que Misil hereda de MisilTermico, es imprescindible reconocer que objeto es una particularizacion de otro.

Aqui es donde vemos que a pesar de herencia, estamos repitiendo codigo, lo cual conlleva a los problemas anteriormente vistos.

``` wlk
 agotada = true
 oObjective.sufrirDanio(potencia)
```

**Como lo arreglamos?**

### Super

Nos permite volver al metodo que hubiera heredaro. Notese que no se indica a que metodo llama, este se sobre entiende al encontrarse en ejecucion en un method con override.

```wlk
class MisilTermico inherits Misil {

    override method dispararA(oObjective){
        if (oObjective.emiteCalor()){
            super(oObjective)
        }
    }
}
```

Cabe destacar que Super **no** es un mensaje.