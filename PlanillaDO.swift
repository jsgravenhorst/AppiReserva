//
//  PlanillaDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class PlanillaDO  {
    var _idPlanilla:   String!
    var _idGrupo:      String!
    var _idPrograma:   String!
    var _idArea:       String!
    var _idAsignatura: String!
    var _cantidad:     Int!
    
    internal var idPlanilla: String {
        get {
            return _idPlanilla
        }
        set {
            _idPlanilla = newValue
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
    
    internal var idPrograma: String {
        get {
            return _idPrograma
        }
        set {
            _idPrograma = newValue
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
    
    internal var idAsignatura: String {
        get {
            return _idAsignatura
        }
        set {
            _idAsignatura = newValue
        }
    }
    
    internal var cantidad: Int {
        get {
            return _cantidad
        }
        set {
            _cantidad = newValue
        }
    }
    
    init(){
    }
    
    init(idPlanilla: String, idGrupo: String, idPrograma: String, idArea: String, idAsignatura: String, cantidad: Int ){
        _idPlanilla   = idPlanilla
        _idGrupo      = idGrupo
        _idPrograma   = idPrograma
        _idArea       = idArea
        _idAsignatura = idAsignatura
        _cantidad     = cantidad
    }
}
