# [02] - Objetos

## Temas

- **Clases**
  - Definicion y Proposito
  - Sintaxis Basica
  - Seguimos pensando en objetos!
- **Instanciacion** (con y sin parametros)
- **Garbage Collector**

<hr/>

Retomamos con el ejemplo de "Pepita", la golondrina.

Introducimos el caso donde se quiera tratar otra golondria, con las mismas caracteristicas que pepita. Si bien podrimos copiar y pegar cambiandole el nombre, "Pepito". Si bien esto suena mal de por si, la inconvencia principal surge cuando se necesita modificar algun metodo, para todas las golondrinas.

**Como encaramos este problema?**

Si bien existe muchas formas, vamos a presentar una variante, que consideraremos dominante. A esta tecnica llamaremos **clase**.

## Clases

Las clases no son objetos. Podemos pensarlos como moldes, que nos permitiran "crear" varios objetos con las mismas propiedades.

- Permite **instanciar objetos**: nace asociado a una clase y no puede cambiar de ella.
- Definen **atributos**: suplanta la definicion objeto por objeto. Si un objeto se crea a partir de una clase, estos atributos seran provistos al objeto.
- Proveen **metodos**:  cuando un objeto recibe un mensaje, en vez de preguntarle al objeto, le preguntara a la clase si existe una respuesta a ese mensaje.

Como no son objetos, no puedo enviar mensajes a una clase.

Este metodo permite el polimorfimo entre los objetos de la misma clase.

<hr/>

**Bajando a tierra en Wollok...**

```wlk
class Golondrina{
    var property energia = 100

    method vola(kilometros){
        energia = self.energia() - kilometros * 2
    }

    method come(gramos){
        energia = self.energia() + gramos * 10
    }
}
```

Si quisiera crear una nueva instancia de esta clase...

```wlk
> const pepita = new Golondrina()

> pepita.energia()
100
```

Tambien podemos realizar lo siguiente...

```wlk
> const pepito = new Golondrina(energia = 180)
```

Podremos modificar los valores *default* de sus atributos.

## Referencias y Garbage Collector

Si bien vimos como los objetos nacen, no mencionamos nada de donde residen en memoria y que sucede con aquellos objetos que no sirven mas.

Veamos esta referencia por nombre propio

```wlk
const pepita = new Golondrina()
```

En cambio,

```wlk
new Golondrina()
```

no guarda referencia al objeto. Al no guardar referencia, no podemos enviarle ningun mensaje, ergo no sirven en el programa. Cabe mencionar, que es imposible recuperar la referencia si se perdiesen todas.

**Que sucede con ellos?** existe un **Garbage Collector** que, de encontrar un objeto sin referencia alguna, un objeto es destruido, liberandose la memoria.

La moraleja es, los objetos se mueren solos. **NO preocuparse** por **desreferenciar** un **objeto**, sino por **mantener** la **referencia**.
