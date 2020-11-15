# 07 - Objetos

## Plataforma de Pago

### Enunciado

La plataforma permite subir distintos tipos de contenidos con el fin de monetizarlos, de los cuales conocemos el título y la cantidad de vistas que tuvieron. Además, cada pieza de contenido podría estar marcada como “contenido ofensivo” por su autor (o debido al pedido de otros usuarios). Ahora mismo, los tipos de contenido disponibles son **videos** e **imágenes** (de las cuales también conocemos los tags con los que el autor las etiquetó) pero en el futuro podrían aparecer más.

Los usuarios de la aplicación ingresan su nombre y email los cuales, pasados cierto tiempo, son verificados (hasta que eso ocurra, se los considera “sin verificar”).

Al subir un contenido, los usuarios eligen para el mismo una forma de monetización, la cual determina la forma en que el contenido se cotiza. El usuario puede cambiar en cualquier momento la forma de monetizar cada uno de sus contenidos, pero sólo puede aplicar una a cada uno. Cambiar la forma de monetizar hace que se pierda todo el dinero ganado por ese contenido en la forma anterior.

Las estrategias de monetización posibles son:

- **Publicidad**: El contenido se muestra al lado de un aviso publicitario. El usuario cobra 5 centavos por cada vista que haya tenido su contenido. Además los contenidos populares cobran un plus de `$2000.00`. Consideramos que un video es popular cuando tiene más de 10000 vistas, mientras que una imagen es popular si está marcada con todos los tags de moda (una lista de tags arbitrarios que actualizamos a mano y puede cambiar en cualquier momento).
Ninguna publicación puede recaudar con publicidades más de cierto máximo que depende del tipo: `$10000.00` para los videos y `$4000.00` para las imágenes (incluyendo el plus).
Sólo las publicaciones no-ofensivas pueden monetizarse por publicidad pero si una publicidad es marcada como ofensiva luego de elegir esta monetización puede conservarla.

- **Donaciones**: El contenido ofrece la posibilidad de hacer una donación al autor. El monto de cada donación depende de cada donador y puede acumularse cualquier cantidad. Todos los contenidos pueden ser monetizados por donaciones.

- **Venta de Descarga**: El contenido puede ser descargado luego de que el comprador pague un precio fijo, elegido por el vendedor. El valor mínimo de venta es de `$5.00` y se cobra por cada vista. Sólo los contenidos populares pueden acceder a esta forma de monetización.

### Consigna

1. Calcular el **total recaudado** por contenido
2. Hacer que el sistema permita realizar las siguientes **consultas**:
   1. Saldo total de un usuario, que es la suma total de lo recaudado por todos sus contenidos.
   2. Email de los 100 usuarios verificados con mayor saldo total.
   3. Cantidad de super-usuarios en el sistema (usuarios que tienen al menos 10 contenidos populares publicados).
3. Permitir que un usuario publique un nuevo contenido, asociándolo a una forma de monetización.
4. Aparece un nuevo tipo de estrategia de monetización: El **Alquiler**. Esta estrategia es muy similar a la venta de descargas, pero los archivos se autodestruyen después de un tiempo. Los alquileres tienen un precio mínimo de $1.00 y, además de tener todas las restricciones de las ventas, los alquileres sólo pueden aplicarse a videos.
5. Responder sin implementar:
   1. ¿Cuáles de los siguientes requerimientos te parece que sería el más fácil y cuál el más difícil de implementar en la solución que modelaste? Responder relacionando cada caso con conceptos del paradigma.
      1. Agregar un nuevo tipo de contenido.
      2. Permitir cambiar el tipo de un contenido (e.j.: convertir un video a imagen).
      3. Agregar un nuevo estado “verificación fallida” a los usuarios, que no les permita cargar ningún nuevo contenido.
   2. ¿En qué parte de tu solución se está aprovechando más el uso de polimorfismo? ¿Porqué?
