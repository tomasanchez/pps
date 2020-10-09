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
==============================================================================   OBJECts - Lecture 04  ========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Enunciado:
    Queremos hacer un sistema para hacer compras online de modo que se puedan agregar productos al carrito de compras,
     y hacer diversas consultas para analizar el estado de la compra.

    Debemos contemplar dos tipos de productos distintos:

        -   De venta unitaria, a los cuales nos interesa poder configurarles su descripción y el precio unitario.
            Por ejemplo, un producto podría tener como descripción "Aceite de girasol" y como precio unitario
            el valor 60.75.
        
        -   De venta por peso, que nos interesa poder configurarles la descripción, el precio por kilo y el peso
            (en kilogramos) que se está comprando. El precio a abonar por estos productos sería el precio por kilo
            multiplicado por el peso del producto. Por ejemplo, podríamos querer tener un producto por peso cuya
            descripción sea "Queso cremoso", el precio por kilo sea 320 y el peso sea 0.3 kilos. Por ende el valor
            que se debería abonar por ese producto debería ser: 320 * 0.3 => 96.
*/

/*  Requerimientos y cosas a tener en cuenta:

    -   Necesitamos poder agregar productos al carrito, considerando que debe ser posible agregar un mismo producto al
        carrito varias veces, lo cual implica que se desea comprar esa cantidad del producto en cuestión.

    -   Queremos poder determinar:
        >   si el carrito está vacío, que se cumple cuando no se le agregó ningún producto.
        >   cuántos productos hay en el carrito en total (si se agrega 2 veces un mismo producto, debe contabilizarse 2
            veces).
        >   cuál es el total a abonar por los productos agregados al carrito.
        >   cuál es el producto más caro de los que se agregaron al carrito. 

    -   Además queremos obtener el detalle de la compra, que debería ser una lista con las descripciones de los productos
        que se agregaron al carrito. La misma no debería tener descripciones repetidas, y se espera que esté en orden alfabético. 
*/

/*  Ejemplos de Uso:
    >>> carrito.agregar(unPoducto)
    >>> carrito.estaVacio()
    >>> carrito.cantidadDeProductos()
    >>> carrito.totalAAbonar()
    >>> carrito.productoMasCaro()
    >>> carrito.detalleDeCompra()
*/

/*  Restricciones:
    Tené en cuenta que para que las pruebas funcionen deben respetarse los siguientes nombres de clases y atributos

        ProductoUnitario, con atributos descripcion y precioUnitario
        ProductoPorPeso, con atributos descripcion, precioPorKilo y peso 
*/

class Producto{
    const property descripcion = ""
    method precio() = 0
}

class ProductoUnitario inherits Producto{
    const precioUnitario
    
    override method precio () = precioUnitario
}

class ProductoPorPeso inherits Producto{
    const peso
    const precioPorKilo

    override method precio() = precioPorKilo * peso
}

class Carrito{
    const productos = []

    method agregar(oProducto){
        productos.add(oProducto)
    }

    method estaVacio() = productos.isEmpty()

    method cantidadDeProductos() = productos.size()

    method detalleDeCompra() {
        const sorted = []
        sorted.addAll(productos)

        sorted.sortBy({
            oItem1, oItem2 => oItem1.descripcion() < oItem2.descripcion()
        })
		
		const ret = []
		ret.addAll(sorted.map{oItem => oItem.descripcion()}.asSet())
        return ret
    }
    
    method totalAAbonar(){
        const total = []

        total.addAll(productos)

        return total.map({
            oItem => oItem.precio()
        }).sum()
    }
    
    method productoMasCaro() = productos.max({
        oItem => oItem.precio()
    })
}


/* Testing Database */
const manzana = new ProductoUnitario(detalle='Manzana', precioUnitario=5)
const pera = new ProductoUnitario(detalle='Pera', precioUnitario=10)
const azucar = new ProductoPorPeso(detalle='Azucar', precioPorKilo=5, peso=3)
const carrito = new Carrito()