# 03 - Paradigma Logico

# Functores y Polimorfismo

Supongamos lo siguiente, en una libreria se precisa una base de datos para consultar sobre la venta de libros

```prolog
% vende(Titulo, Autor, Genero, Editorial, Precio)
vende(elResplandor,         stephenKing,        terror,     debolsillo,     2300).
vende(cronicasDelAngelGris, alejandroDolina,    ficcion,    booket,         1600).
vende(mort,                 terryPratchett,     aventura,   plazaJames,     1300).
```

Ahora si tambien queremos consultar informacion sobre discos de musica:

```prolog
% vende(Titulo,         Autor,      Genero, CantidadDeDiscos, CantidadDeTemas,      Precio).
vende(differentClass,   pulp,       pop,                   2,              24,      1450).
vende(bloodOnTheTracks, bobDylan,   golk,                  1,              12,      2500).
```

No funcionaria pues tendria dos predicados de igual nombre y distinta aridad.

**Corolario:** ninguna de las definiciones anteriores nos servira.

## Soluciones

### Alternativa I:

```prolog
% vende(Titulo,             Autor,              Genero,     Editorial, CantidadDeDiscos, CantidadDeTemas, Precio).
vende(elResplandor,         stephenKing,        terror,     debolsillo,             ???,        ???,      2300).
vende(cronicasDelAngelGris, alejandroDolina,    ficcion,    booket,                 ???,        ???,      1600).
vende(mort,                 terryPratchett,     aventura,   plazaJames,             ???,        ???,      1300).
vende(differentClass,       pulp,                    pop,            ???,             2,         24,      1450).
vende(bloodOnTheTracks,     bobDylan,               golk,           ???,              1,         12,      2500).
```

Enseguida notamos el porblema  de que informacion iria en los campos que no correspondan.

### Alternativa II:

**Functores** equivale a un *data* en funcional, una estructura inmutable, compuesta.

```prolog
% vende(                                 Articulo,                                    Precio).
vende( libro(elResplandor,         stephenKing,        terror,     debolsillo),         2300).
vende( libro(cronicasDelAngelGris, alejandroDolina,    ficcion,    booket),             1600).
vende( libro(mort,                 terryPratchett,     aventura,   plazaJames),         1300).
vende( cd(differentClass,       pulp,                       pop,   2,       24),        1450).
vende( cd(bloodOnTheTracks,     bobDylan,                   golk,  1,       12),        2500).
```

Uno se preguntaria como distingue un functor de un predicado; un **functor solo aparece como parametro**. 
De definirse:

```prolog
libro(elResplandor,         stephenKing,        terror,     debolsillo).
```

*libro* seria un predicado de aridad 4.

Con esto uno podria comsultar:
