//
//  ProfesorDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation
class ProfesorDO {
    var _idProfesor:     String!
    var _nombreProfesor: String!
    
    internal var idProfesor: String {
        get {
            return _idProfesor
        }
        set {
            _idProfesor = newValue
        }
    }
    
    internal var nombreProfesor: String {
        get {
            return _nombreProfesor
        }
        set {
            _nombreProfesor = newValue
        }
    }
    
    init () {
    }
    
    init(idProfesor: String, nombreProfesor: String) {
       _idProfesor     = idProfesor
       _nombreProfesor = nombreProfesor
    }
    
}