// ------------------------------------------------
// Jugadores
// ------------------------------------------------

object julieta {
    var property tickets = 15
    var property cansancio = 0

    method fueza() = 80 - cansancio // Esto permite el recalculo - Problema que tuvimos en el TP1

    method punteria()= 20 // Hardcoded pero asi es el dominio Notese q es privado y no necesito una constante


    method jugar(oGame){
        tickets = tickets + oGame.ticketsGanados()
        cansancio = cansancio + oGame.cansancioQueProduce()
    }

    method puedeCanjear(oPrize) = oPrize.costo()
}

object gerundio{
    method jugar(oGame) {}

    method puedeCanjear(oPrize) = true
}

// ------------------------------------------------
// Juegos
// ------------------------------------------------

object tiroAlBLanco {
    method ticketsGanados(oPlayer) = (oPlayer.punteria() / 10).roundUp()
    method cansancioQueProduce() = 3


}

object pruebaDeFuerza{
    method ticketsGanados(oPlayer) = if(oPlayer.fuerza() > 75) 20 else 0
    method cansancioQueProduce() = 8
}

object ruedaDeLaFortuna{

    var property aceitada = true // Syntax Sugar -> Genera setter y getter.

    // method aceitada(nuevoEstado) {aceitada = nuevoValor} -> Setter
    // method aceitada() = aceitada -> Getter

    method ticketsGanados(oPlayer) = 0.randomUpTo(20).roundUp() // No guardar mensajes en variable
    method cansancioQueProduce() = if (aceitada) 0 else 1


}

// ------------------------------------------------
// Premios
// ------------------------------------------------

object ositoDePeluche{
    method costo() = 45
}

object taladro{

    var property costo = 200
}