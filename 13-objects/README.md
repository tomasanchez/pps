# [01] - Objetos

## Práctica 1: Julieta en la Feria | PdeP JN - 2020 - Objetos

Queremos hacer un sistema para registrar la visita de Julieta a la feria que llegó al pueblo.

En la feria hay varios juegos, todos distintos y, cada vez que Julieta juega a uno, gana algún número de tickets, que luego puede cambiar por fabulosos premios. Algunos de los juegos que hay en la feria son:

### Tiro al Blanco

 En este juego los chicos le disparan a patitos de madera usando un rifle de aire comprimido. La cantidad de tickets que otorga depende de cuántos patos tire (para ser más exactos, se entrega un ticket por cada 10 puntos de puntería del participante, redondeando para arriba). Jugar este juego tensa un poco a los chicos, causandoles 3 puntos de cansancio.

### Prueba de Fuerza

Este juego está equipado con un balancín y una plomada instalada en una corredera vertical, que termina en una campana. Los chicos golpean el balancín con una maza de madera y, si hacen sonar la campana, reciben 20 tickets (y si no, nada). Para poder hacer sonar la campana hace falta una fuerza de, al menos, 75 puntos. De más estå decir que este juego es agotador (produce 8 puntos de cansancio cada vez que se juega).

### Rueda de la Fortuna

 Este es un juego puramente de azar. Los participantes hacen girar una rueda gigante que, al detenerse, indica cuántos tickets ganó. La rueda premia un número aleatorio de tickets entre 1 y 20. Cuando está bien aceitada la rueda gira suavemente y sin esfuerzo, pero cuando pasa mucho tiempo sin mantenimiento empieza a hacer fricción y causa un 1 punto de cansancio al girarla.


### Julieta

De Julieta sabemos que es una chica muy fuerte (tiene 80 puntos de fuerza, menos el cansancio que acumule), pero su puntería no es muy buena (apenas 20 puntos). También sabemos que llega a la feria completamente descansada y con 15 tickets que guardó del año anterior.

## Objetivos

- Modelar a Julieta y los juegos mencionados, de forma tal que podamos hacer que Julieta juegue y nos informe cuántos tickets tiene.
- Extender el programa para saber si Julieta puede canjear alguno de los premios disponibles. La mano viene dura y en la feria quedan solamente dos premios disponibles: Un osito de peluche que cuesta 45 tickets y un taladro rotopercutor Bosch de 750w y mandril de 13mm, cuyo costo el dueño de la feria ajusta todos los días en base al precio del dólar.
- Agregar al sistema a Gerundio, otro chico más que visita la feria. Geru es el hijo del dueño así que no necesita juntar tickets y puede canjear el premio que quiera cuando quiera. Para pensar: ¿Qué mensajes necesita entender Gerundio?
