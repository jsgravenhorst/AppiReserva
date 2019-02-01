//
//  TipoActividadDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class TipoActividadDO {
    var _idTipoActividad: String!
    var _nombreTipoAct: String!
    
    internal var idTipoActividad: String {
        get {
            return _idTipoActividad
        }
        set {
            _idTipoActividad = newValue
        }
    }
    
    internal var nombreTipoAct: String {
        get {
            return _nombreTipoAct
        }
        set {
            _nombreTipoAct = newValue
        }
    }
    
    init () {
    }
    
    init(idTipoActividad: String, nombreTipoAct: String) {
        _idTipoActividad = idTipoActividad
        _nombreTipoAct   = nombreTipoAct
    }
}
