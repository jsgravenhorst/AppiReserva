//
//  AsignaturaDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class AsignaturaDO {
    var _idAsignatura:     String!
    var _nombreAsignatura: String!
    
    internal var idAsignatura: String {
        get {
            return _idAsignatura
        }
        set {
            _idAsignatura = newValue
        }
    }
    
    internal var nombreAsignatura: String {
        get {
            return _nombreAsignatura
        }
        set {
            _nombreAsignatura = newValue
        }
    }
    
    init () {
    }
    
    init(idAsignatura: String, nombreAsignatura: String) {
        _idAsignatura     = idAsignatura
        _nombreAsignatura = nombreAsignatura
    }
}