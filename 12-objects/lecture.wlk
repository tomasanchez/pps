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
==============================================================================   OBJECTS - Lecture 01  ========================================================================
===============================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*
    Ejercicio 1:

    Queremos estudiar el efecto que produce visitar un spa.

    Cuando el spa atiende una persona pasan dos cosas: l
    1- la persona se da un baño de vapor durante 5 minutos 
    2- y luego recibe masajes.

    Nos interesa modelar a dos personas para que se atiendan en el spa: Felicitas y Esteban.
ñ
De Felicitas sabemos que:

    Cuando recibe masajes, si es feliz, su tranquilidad aumenta 5 unidades, y si no es feliz sólo aumenta 3 unidades.
    Es feliz cuando su tranquilidad es mayor a 7.
    Cuando se da un baño de vapor, su tranquilidad aumenta el doble de la duración del mismo.
    Inicialmente su tranquilidad es 0. 

De Esteban nos interesará conocer su nivel de stress, que dependerá de si está cansado o no y qué tan contracturado está. Sabemos que:

    Inicialmente está cansado y su nivel de contractura es 20.
    Si se da un baño de vapor queda descansado.
    Cada vez que recibe masajes su nivel de contractura baja en 15 unidades, con la consideración de que el nivel mínimo de contractura que puede tener es 0.
    Su nivel de stress equivale a su nivel de contractura cuando está descansado, pero si está cansado es el doble. 

Definir los objetos spa, felicitas y esteban de modo que se puedan usar de esta forma:
    felicitas.tranquilidad()
    felicitas.esFeliz()
    esteban.stress()
    spa.atender(felicitas)
    spa.atender(esteban)
*/

object spa{
    method atender(persona){
        const tiempo = 5
        persona.darBanioVapor(tiempo)
        persona.recibirMasajes()
    }
}

object felicitas{

    var tranquilidad = 0

    method tranquilidad() = tranquilidad

    method tranquilidad(puntos) { tranquilidad = tranquilidad + puntos}
    
    method esFeliz()= tranquilidad >= 7

    method darBanioVapor(tiempo){
        const puntos = tiempo * 2
        tranquilidad(puntos)
    }

    method recibirMasajes(){
        const puntos = if(self.esFeliz()) 5 else 3
        tranquilidad(puntos)
    }

}

object esteban{
    var estaCansado = true
    var contractura = 20
    var stress = if(self.estaCansado()) contractura * 2 else contractura

    method estaCansado() = estaCansado

    method contractura() = contractura

    method esMenor() = contractura < 0

    method stress() = stress

    method darBanioVapor(tiempo){
        estaCansado = false
    }

    method recibirMasajes(){
        contractura = contractura - 15
        contractura = if(self.esMenor()) 0 else contractura
        
        //los campos no se actualizan automaticamente
        stress = if(self.estaCansado()) contractura * 2 else contractura
    }

}