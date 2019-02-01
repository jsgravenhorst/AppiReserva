//
//  PensumDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/21/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class PensumDO {
    var _idPensum:     String!
    var _idArea:       String!
    var _idPrograma:   String!
    var _idAsignatura: String!
    
    internal var idPensum: String {
        get {
            return _idPensum
        }
        set {
            _idPensum = newValue
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
    
    internal var idPrograma:  String {
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
    
    
    init () {
    }
    
    init(idPensum: String, idArea: String, idPrograma: String, idAsignatura: String!) {
        _idPensum     = idPensum
        _idPrograma    = idPrograma
        _idArea       = idArea
        _idAsignatura = idAsignatura
    }

}