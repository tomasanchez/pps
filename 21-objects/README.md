# 09 - Objetos

## Plantaciones

PdeP JN - 2020 - Parcial Objetos

Nos piden modelar un software que sirva para registrar el progreso de los cultivos en una granja industrial, que dispone de múltiples terrenos en los que se cultivan diversos tipos de cosechas.

La granja dispone de dos tipos diferentes de terreno:

- **Campos Abiertos**
- **Invernaderos**

de los cuales conocemos el conjunto de **Cultivos** plantado en cada uno.

Los Campos Abiertos son, como su nombre indica, parcelas de tierra al aire libre. Cada parcela cuenta con un tamaño distinto (medido en metros cuadrados) y un suelo con distinta riqueza mineral que depende de los factores geográficos y climáticos de la zona.
Cada Campo Abierto tiene un costo de mantenimiento de $500/m2 y permite plantar un máximo de 4 plantas por m2.

Por otro lado, los Invernaderos son construcciones artificiales que permiten tener un mayor control de los cultivos, utilizando tecnología de punta. Cada Invernadero se construye a medida (con lo cual, la cantidad máxima de plantas que admite varía) y puede optar por uno de **tres dispositivos** electrónicos disponibles para facilitar el cuidado de las plantas. Los dispositivos instalables son un **Regulador Nutricional**, un **Humidificador** y un **set de Paneles Solares**. Cada Invernadero instala siempre un único dispositivo, pero el diseño modular permite reemplazarlo por otro, de ser necesario.
Obviamente los Invernaderos son más costosos de mantener que los Campos Abiertos, teniendo un costo base de $50.000 más el costo de mantenimiento del dispositivo instalado:

- Los Reguladores Nutricionales tienen un costo fijo de mantenimiento de $2000.
- El costo de los Humidificadores depende de la humedad que tengan configurada: $1000 si la humedad es menor o igual al 30% y $4500 si es mayor.
- Los Paneles Solares, por otro lado, permiten ahorrar energía reduciendo el costo de mantenimiento del Invernadero en $25.000.

En cuanto a los cultivos que la granja trabaja, sabemos que ahora mismo existen 3 (aunque en el futuro podrían incorporarse más):

- **Papa**: La papa puede plantarse en cualquier terreno y tiene un valor nutricional de 1500 que se duplica si se la cultiva en un terreno rico. El precio de venta del producto de cada planta de papa es la mitad de su valor nutricional.
- **Algodón**: El algodón no se come, con lo cual su valor nutricional es nulo, pero cada planta de algodón puede venderse a $500. Sólo puede plantarse en terreno rico.
- **Árbol Fruta**l: Los árboles frutales son una inversión a largo plazo. Su valor nutricional es el triple de su edad (hasta un máximo de 4000), con lo cual, cuanto más viejo el árbol, más nutritivo! Si bien estos son cultivos muy rentables, porque el precio d e venta de cada cosecha depende de la fruta que dé el árbol, sólo pueden ser plantados en Campo Abierto.

Considerar que un mismo terreno puede tener múltiples plantas de cada tipo.

Se pide modelar el problema descripto utilizando los conceptos del **Paradigma Orientado a Objetos** (poniendo especial foco en el uso de **Polimorfismo**, **Encapsulamiento** y **Delegación** y evitando la repetición de lógica siempre que sea posible), de forma tal que sea posible realizar las siguientes consultas y operaciones:

1. **Saber si un terreno es rico**
Decimos que un Campo Abierto es rico si la riqueza de su suelo es mayor a 100.
Los Invernaderos se consideran ricos si los cultivos que tienen plantados no alcanzan la mitad de su capacidad máxima o tienen instalado un regulador nutricional o un humidificador configurado entre 20% y 40% de humedad.
2. **Conocer la media nutricional de un terreno**
La media nutricional de un terreno es el promedio del valor nutricional de todos sus cultivos.
3. **Conocer el valor neto de un terreno**
El valor neto de un terreno es el valor total de todos sus cultivos menos su costo de mantenimiento.
4. **Plantar un cultivo en un terreno**
Dada una planta y un terreno, agregarla a las plantaciones del terreno. Tener en cuenta que un terreno no puede exceder su capacidad máxima ni plantar cultivos que no puedan crecer en él.
5. **Palmeras**
Aparece un **nuevo tipo de Árbol Frutal**: Las Palmeras Tropicales. La fruta de estos árboles frutales tienen un precio 5 veces mayor a los árboles normales pero, además de los requisitos de los otros árboles, sólo pueden ser plantados en terreno rico. El valor nutricional de las palmeras es sólo el doble de su edad (hasta un máximo de 7500).
