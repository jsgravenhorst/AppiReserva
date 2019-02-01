//
//  SedeDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class SedeDO {
    var _idSede:     String!
    var _nombreSede: String!
    
    internal var idSede: String {
        get {
            return _idSede
        }
        set {
            _idSede = newValue
        }
    }
    
    internal var nombreSede: String {
        get {
            return _nombreSede
        }
        set {
            _nombreSede = newValue
        }
    }
    
    init(){
    }
    
    init(idSede: String, nombreSede: String) {
        _idSede = idSede
        _nombreSede = nombreSede
    }
}
