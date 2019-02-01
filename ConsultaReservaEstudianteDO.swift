//
//  ConsultaReservaEstudianteDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 2/15/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation
class ConsultaReservaEstudianteDO: ReservaDO {
    var _nombreProfesor: String!
    
    internal var nombreProfesor : String {
        get {
            return _nombreProfesor
        }
        set {
            _nombreProfesor = newValue
        }
    }
    
    override init(){
        super.init()
    }
    
     init( idReserva: String, idSede: String, idBloque: String, idArea: String, idPrograma: String, idAsignatura: String, idGrupo: String, idTipoActividad: String,  idRecurso: String, fechaInicial: String, horaInicial: String, fechaFinal: String, horaFinal: String, nombreProfesor: String){
        _nombreProfesor = nombreProfesor
        super.init(idReserva: idReserva, idSede: idSede, idBloque: idBloque, idArea: idArea, idPrograma: idPrograma, idAsignatura: idAsignatura, idGrupo: idGrupo, idTipoActividad: idGrupo,  idRecurso: idRecurso, fechaInicial: fechaInicial, horaInicial: horaInicial, fechaFinal: fechaFinal, horaFinal: horaFinal)
    }


    
    
}
