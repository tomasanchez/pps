# 06 - Objetos

## Temas Vistos

- Manejo de Errores: "Hacer lo que promete o explotar"

- Excepciones
  - Motivacion
  - Son objetos!
  - Domain vs System
  
- Try - Catch - Then allways
  - Cuando hay que lanzar/atrapar?
  - Malas Practicas

## Errores y Excepciones

Vamos a tomar un dominio de impresoras para poder explicar este concepto.

```wlk
class Impresora{
   const cabezal
   method trazar(recorrido){...}
   method mostrarEnPantalla(mensaje){...}

   method imprimir(oDoc){
      cabezal.eyectar(oDoc.tinta())
      self.trazar(oDoc.recorrido())
   }
}
```

```wlk
class Cabezak{
   const eficiencia
   const cartucho

   method liberar() {...}

   method eyectar(nCantidad){
      cartucho.extraer(1/ eficiencia * nCantidad)
      self.liberar()
   }
}
```

```wlk
class Cartucho{
   var carga

   method extrar(cantidad){
      carga -= cantidad
   }
}
```

Suponiendo que tenemos

```wlk
> const documento = ...
> const impresoras = [...]
> impresoras.anyOne().imprimir(documento)
```

Si mi conjunto de impresoras esta vacio, obtendriamos error. Si bien uno podria:

```wollok
if(!impresoras.isEmpty()) impresoras.anyOne().imprimir(documento)
???
```

No sabriamos si enrealidad se ejecuta o no, resultando mas traicionero que aquel que lanza error.

Por que hace falta un **manejo de errores**? Volvamos a ver el cartucho:

```
class Cartucho{
   var carga

   /*Irregularidad*/
   method extrar(cantidad){
      carga -= cantidad
   }
}
```

Podemos notar la irregularidad donde no se puede realizar la extraccion cuando la carga baja de 0, pues no existe carga negativa. Si uno quisiera solucionar con un `if (carga > cantidad)` esto resulta ineficaz. Existen varios metodos que se ejecutarian asumiendo que "todo salio bien" como `liberar()` y `trazar()`. Principalmente no cumple con lo que promete, `extrar()` cuando no siempre *extrae*. No **absorbamos problemas**, esto dificulta detecar los problemas.

Otra solucion podria ser añadir metodos preguntado si es posible realizar el metodo "irregular" como pre-condicion. En este ejemplo; `puedeImprimir()`, `puedeEyectar()`, `tieneCarga()`. Sin embargo esto resulta insatisfactorio, ya que obliga al usuario a llamar en una manera ordenada a los metodos y no resuelve que `eyectar()` pueda no eyectar.

Tomando la idea anterior, podemos implementar esto, pero r ealizando `returns` de *booleans*. Ej:

```wlk
method extraer(cantidad){
   if( carga > cantindad){
      carga -= cantindad
      return true
   } else return false
}
```

Aun asi, si los calls escalan, terminariamos llenando nuestros metodos con controles, con nuestro codigo volviendose paranoico.

## Throw

Las **Excepciones** vienen a salvarnos. Nos permiten *burbujear* los errores, subiendo la cadena de calls, interrumpiendo en todos los niveles la ejecucion.

```wlk
method extraer(cantidad){
   if( carga > cantindad){
      carga -= cantindad
      return true
   } else throw new Exception(message="Sin carga")
}
```

Esto nos permite programar solo para el caso feliz, donde todo sale bien. Y ademas nos asegura que la ejecucion se corta y no debemos preocuparnos por mecanismos de control.

## Try - Catch

Supongamos que ahora nuestra impresora tiene dos cabezal, uno de repuesto, puesto que si el primero  falla, utilizar el segundo. Como nuestra ejecucion es frenada, necesitamos un handler, para poder continuar con el segundo cabezal. Para ello utilizaremos la construccion `try{...}catch error{...}`

```wlk
class Impresora{
   const cabezal
   const cabezalAux
   method trazar(recorrido){...}
   method mostrarEnPantalla(mensaje){...}

   method imprimir(oDoc){
      try{
         cabezal.eyectar(oDoc.tinta())
      } catch error{
         cabezalAux.eyectar(oDoc.tinta())
      }
      self.trazar(oDoc.recorrido())
   }
}
```

Sin embargo con `catch error` estamos capturando *TODOS* los errores, y tratandolos a todos con ese metodo, para ello:

Utilizaremos un discriminante `catch error: SinCargaException`. Para ello necesitaremos

```wlk
method extraer(cantidad){
   if( carga > cantindad){
      carga -= cantindad
      return true
   } else throw new SinCargaException(carga = carga)
}


```wlk
class SinCargaException inherits DomainException{
   const property carga
}
```

Tambien podemos *catchear* varios errores, donde funcionaria como pattern-matching

```wlk
class Impresora{
   const cabezal
   const cabezalAux
   method trazar(recorrido){...}
   method mostrarEnPantalla(mensaje){...}

   method imprimir(oDoc){
      try{
         cabezal.eyectar(oDoc.tinta())
      } catch error: SinCargaExceptipn{
         cabezalAux.eyectar(oDoc.tinta())
      } catch error{
         self.mostrarEnPantalla(error.message())
      }
      self.trazar(oDoc.recorrido())
   }
}
```

## Practica

Impresoras ocupadas

- Una impresora "ocupada" no puede imprimir
- Una impresora permanece ocupada mientras imprime (u otras causas)
- Si algo saliera mal durante una impresion, la impresora se desocupa

```wlk
class Impresora{
   const cabezal
   const cabezalAux
   var property ocupada

   method trazar(recorrido){...}
   method mostrarEnPantalla(mensaje){...}

   method imprimir(oDoc){
      if(ocupada) throe new NoPuedoImprimirException()
      ocupada = true
      try{
         cabezal.eyectar(oDoc.tinta())
         self.trazar(oDoc.recorrido())
      } catch error: SinCargaException{
         cabezalAux.eyectar(oDoc.tinta())
      } then always{
         /* Pase lo que pase se ejecuta*/
         ocupada = false
      }
   }
}

class NoPuedoImprimirException inherits DomainException(){

}
```