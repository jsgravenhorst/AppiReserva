//
//  RecursoDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class RecursoDO {
    var _idRecurso:     String!
    var _nombreRecurso: String!
    var _capacidad:     Int?
    
    internal var idRecurso: String {
        get {
            return _idRecurso
        }
        set {
            _idRecurso = newValue
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
    
    internal var capacidad: Int? {
        get {
            return _capacidad
        }
        set {
            _capacidad = newValue
        }
    }

    
    init () {
    }
    
    init(idRecurso: String, nombreRecurso: String, capacidad: Int) {
        _idRecurso     = idRecurso
        _nombreRecurso = nombreRecurso
        _capacidad     = capacidad
    }
}