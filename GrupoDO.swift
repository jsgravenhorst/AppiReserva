//
//  GrupoDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class GrupoDO {
    var _idGrupo: String!
    var _nombreGrupo: String!
    
    internal var idGrupo: String {
        get {
            return _idGrupo
        }
        set {
            _idGrupo = newValue
        }
    }
    
    internal var nombreGrupo: String {
        get {
            return _nombreGrupo
        }
        set {
            _nombreGrupo = newValue
        }
    }
    
    init () {
    }
    
    init(idGrupo: String, nombreGrupo: String) {
        _idGrupo     = idGrupo
        _nombreGrupo = nombreGrupo
    }
}