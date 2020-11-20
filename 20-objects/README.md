# 08 - Objetos

## Procesamiento

Nos piden modelar un sistema que permita llevar registro del trabajo de las Super-Computadoras de un laboratorio.

[Solucion en video](https://www.youtube.com/watch?v=5TayX_Iql2s)

### Enunciado

Las **super-computadoras** que tenemos que modelar son conjuntos de **equipos** independientes que se conectan entre sí para hacerse más poderosos. Tenemos, de momento, dos tipos de equipos para conectar: **A105** y **B2**.

Los equipos tipo A105 son los modelos más viejos de equipo. Tienen un consumo eléctrico base de 300 watts y producen 600 unidades de cómputo (base) cada uno.

Los equipos Tipo B2 son más modernos y están pensados para escalar. Cada uno de estos equipos se fabrica para permitir la instalación de microchips que aumentan el poder de cómputo y el consumo del equipo. El equipo tiene un consumo base de 50 watts por cada microchip instalado (más 10 watts para hacer funcionar la placa madre) y produce 100 unidades de cómputo base por microchip, hasta un máximo de 800. La cantidad de micros que cada equipo tiene instalado puede variar y, como se fabrican a pedido, depende de cada equipo.

Además de estos dos tipos de equipos, las super-computadoras también pueden conectarse a super-computadoras más pequeñas, que siempre se consideran activas y cuya capacidad de computo y consumo se calcula a partir de los equipos instalados (ver punto 1).

Cada equipo se conecta a la super-computadora configurado para trabajar en uno de tres posibles **modos: Standard, Overclock y Ahorro de Energía**.

El modo de funcionamiento Standard es, como su nombre lo indica, el modo normal de trabajo. Los equipos en este modo consumen y producen sus valores base, sin más ni menos.

Los equipos en modo Overclock se configuran para forzar un mayor desempeño, a cambio de un mayor consumo y corriendo el riesgo de romper el equipo. Los equipos en este modo consumen el doble de energía, pero producen un extra de cómputo que depende del tipo de equipo: Los A105 incrementan su capacidad un 30%, mientras que los B2 la incrementan en 20 unidades por micro. Sin embargo, overclockear es peligroso: al pasar a modo overclock un equipo sólo podrá usarse  cierta cantidad de veces antes de quemarse (el número exacto es arbitrario y varía cada vez se overclockea). Cada vez que la super-compudora computa, sus equipos en modo overclock son usados, si esto ocurre las veces necesarias el equipo pasa a estar **quemado**.

Por otro lado, el modo Ahorro de Energía hace que el equipo, no importa su tipo, sólo consuma 200 watts, pero su capacidad de cómputo se ve afectada de forma proporcional a la pérdida de energía (por ejemplo, un equipo con un consumo base de 400 watts pierde la mitad de su energía, por lo tanto producirá la mitad de cómputo).

El modo de cada equipo puede cambiarse a gusto en cualquier momento para adecuar a la super-computadora a una nueva tarea.

### Consigna

Se pide modelar el dominio descripto y desarrollar los siguientes puntos:

1. Dada una Super-Computadora, se quiere poder responder a las siguientes consultas:
   1. **equipos activos**: son los equipos conectados a la SC que no están quemados y tienen una capacidad de cómputo mayor a cero.
   2. **capacidad de computo y consumo**: este es el total de computo y consumo de todos los equipos activos.
   3. **malConfigurada**: esto ocurre cuando el equipo de la SC que más consume NO es el que más computa.

2. **computarProblema**: Dado un problema de complejidad N (o sea, que requiere N unidades de cómputo para ser resuelto), utilizar una SC para computarlo. Cuando esto ocurre la computadora divide el problema en problemas más chicos, tantos como equipos activos tenga conectados, de igual complejidad (Si la computadora tiene M equipos, cada subproblema tendrá una complejidad de N/M).

Cada equipo activo intenta procesar un sub-problema de acuerdo a los siguientes criterios:

-  Un equipo que intenta computar más que su capacidad de cómputo, falla.
-  Por un error de construcción, los equipos A105 no pueden computar problemas de complejidad menor a 5. Si lo intentan, hacen mal el cálculo y fallan
-  Los equipos en modo overclock pueden quemarse al tratar de computar (ver más arriba). Si el equipo pasa a estar quemado al computar el problema el cómputo falla.
-  Los equipos en modo ahorro de energía corren un monitor de consumo periodicamente y esto causa que fallen 1 de cada 17 intentos de computar.

Luego de resolver el problema, la computadora incrementa un contador interno que recuerda la cantidad total de complejidad que ha resuelto, con fines de auditoría.

3. Aparece ahora un nuevo tipo de modo: **A Prueba de Fallos**. Este modo es una versión mejor del modo Ahorro de Energía, que ofrece la mitad de capacidad de cómputo pero sólo falla por monitorear consumo una vez cada 100 computos.
