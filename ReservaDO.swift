//
//  ReservaDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class ReservaDO {
    var _idReserva:       String!
    var _idSede:          String!
    var _idBloque:        String!
    var _idArea:          String!
    var _idPrograma:      String!
    var _idAsignatura:    String!
    var _idGrupo:         String!
    var _idTipoActividad: String!
    var _idRecurso:       String!
    var _fechaInicial:    String!
    var _horaInicial:     String!
    var _fechaFinal:      String!
    var _horaFinal:       String!
    
    internal var idReserva: String {
        get {
            return _idReserva
        }
        set {
            _idReserva = newValue
        }
    }
    
    internal var idSede: String {
        get {
            return _idSede
        }
        set {
            _idSede = newValue
        }
    }
    
    internal var idBloque: String {
        get {
            return _idBloque
        }
        set {
            _idBloque = newValue
        }
    }
    
    internal var idArea: String {
        get {
            return _idArea
        }
        set {
            _idArea = newValue
        }
    }

    
    internal var idPrograma: String {
        get {
            return _idPrograma
        }
        set {
            _idPrograma = newValue
        }
    }
    
    
    internal var idAsignatura: String {
        get {
            return _idAsignatura
        }
        set {
            _idAsignatura = newValue
        }
    }
    
    internal var idGrupo: String {
        get {
            return _idGrupo
        }
        set {
            _idGrupo = newValue
        }
    }

    internal var idTipoActividad: String {
        get {
            return _idTipoActividad
        }
        set {
            _idTipoActividad = newValue
        }
    }
    
    internal var idRecurso: String {
        get {
            return _idRecurso
        }
        set {
            _idRecurso = newValue
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
    
    internal var fechaFinal: String {
        get {
            return _fechaFinal
        }
        set {
            _fechaFinal = newValue
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
    
    init( idReserva: String, idSede: String, idBloque: String, idArea: String, idPrograma: String, idAsignatura: String, idGrupo: String, idTipoActividad: String,  idRecurso: String, fechaInicial: String, horaInicial: String, fechaFinal: String, horaFinal: String ){
        self._idReserva       = idReserva
        self._idSede          = idSede
        self._idBloque        = idBloque
        self._idArea          = idArea
        self._idPrograma      = idPrograma
        self._idAsignatura    = idAsignatura
        self._idGrupo         = idGrupo
        self._idTipoActividad = idTipoActividad
        self._idRecurso       = idRecurso
        self._fechaInicial    = fechaInicial
        self._horaInicial     = horaInicial
        self._fechaFinal      = fechaFinal
        self._horaFinal       = horaFinal

    }
    
}