//
//  ProgramaDO.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/19/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class ProgramaDO {
    var _idPrograma:     String!
    var _nombrePrograma: String!
    var _idArea:         String!
    
    internal var idPrograma: String {
        get {
            return _idPrograma
        }
        set {
            _idPrograma = newValue
        }
    }
    
    internal var nombrePrograma: String {
        get {
            return _nombrePrograma
        }
        set {
            _nombrePrograma = newValue
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
    
    init(){
    }
    
    init(idPrograma: String, nombrePrograma: String, idArea: String) {
        _idPrograma     = idPrograma
        _nombrePrograma = nombrePrograma
        _idArea         = idArea
    }
}