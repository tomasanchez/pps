# 02 - Paradigma Logico

## Clase Practica

Nos piden modelar una herramienta para analizar el tablero de un juego de Táctica y Estratégia de Guerra. Para eso ya contamos con los siguientes [predicados](lecture.pl) completamente inversibles.

Se pide modelar los siguientes predicados, de forma tal que sean completamente inversibles:

1. *tienePresenciaEn/2*: Relaciona un jugador con un continente del cual ocupa, al menos, un país.
2. *puedenAtacarse/2*: Relaciona dos jugadores si uno ocupa al menos un país limítrofe a algún país ocupado por el otro.
3. *sinTensiones/2*: Relaciona dos jugadores que, o bien no pueden atacarse, o son aliados.
4. *perdió/1*: Se cumple para un jugador que no ocupa ningún país.
5. *controla/2*: Relaciona un jugador con un continente si ocupa todos los países del mismo.
6. *reñido/1*: Se cumple para los continentes donde todos los jugadores ocupan algún país.
7. *atrincherado/1*: Se cumple para los jugadores que ocupan países en un único continente.
8. *puedeConquistar/2*: Relaciona un jugador con un continente si no lo controla, pero todos los países del continente que le falta ocupar  son limítrofes a alguno que sí ocupa y pertenecen a alguien que no es su aliado.
