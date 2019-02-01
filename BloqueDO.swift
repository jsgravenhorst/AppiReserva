//
//  BloqueDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class BloqueDO {
    var _idBloque:     String!
    var _nombreBloque: String!
    var _idSede:       String!
    
    internal var idBloque: String {
        get {
            return _idBloque
        }
        set {
            _idBloque = newValue
        }
    }
    
    internal var nombreBloque: String {
        get {
            return _nombreBloque
        }
        set {
            _nombreBloque = newValue
        }
    }
    
    internal var idSede:  String {
        get {
            return _idSede
        }
        set {
            _idSede = newValue
        }
    }
    
    
    init(){
    }
    
    init(idBloque: String, nombreBloque: String, idSede: String) {
        _idBloque     = idBloque
        _nombreBloque = nombreBloque
        _idSede       = idSede
    }
}