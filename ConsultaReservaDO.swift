//
//  ConsultaReservaDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/26/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class ConsultaReservaDO {
    var _nombreProfesor: String!
    var _nombreRecurso: String!
    var _fechaInicial:  String!
    var _horaInicial:   String!
    var _horaFinal:     String!
    
    internal var nombreProfesor: String {
        get {
            return _nombreProfesor
        }
        set {
            _nombreProfesor = newValue
        }
    }

    internal var nombreRecurso: String {
        get {
            return _nombreRecurso
        }
        set {
            _nombreRecurso = newValue
        }
    }
    
    internal var fechaInicial: String {
        get {
            return _fechaInicial
        }
        set {
            _fechaInicial = newValue
        }
    }
    
    internal var horaIncial: String {
        get {
            return _horaInicial
        }
        set {
            _horaInicial = newValue
        }
    }
    
    internal var horaFinal: String {
        get {
            return _horaFinal
        }
        set {
            _horaFinal = newValue
        }
    }
    
    init(){
    }
    
    init(nombreProfesor: String, nombreRecurso: String, fechaInicial: String, horaInicial: String, horaFinal: String ){
        _nombreProfesor = nombreProfesor
        _nombreRecurso  = nombreRecurso
        _fechaInicial   = fechaInicial
        _horaInicial    = horaInicial
        _horaFinal      = horaFinal
        
    }
    
}








