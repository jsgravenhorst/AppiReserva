//
//  AreaDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class AreaDO {
    var _idArea:     String!
    var _nombreArea: String!
    
    internal var idArea: String {
        get {
            return _idArea
        }
        set {
            _idArea = newValue
        }
    }
    
    internal var nombreArea: String {
        get {
            return _nombreArea
        }
        set {
            _nombreArea = newValue
        }
    }
    
    init () {
    }
    
    init(idArea: String, nombreArea: String) {
        _idArea     = idArea
        _nombreArea = nombreArea
    }
}