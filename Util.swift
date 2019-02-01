//
//  Util.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/22/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation
class Util {
    
    static let dateEEE_DD_MMM_YYYY = "EEE-dd-MMM-yyyy"
    static let dateHH_MM_AAA   = "hh:mm aaa"
    static let dateEEE_DD_MMM_YYYY_HH_MM_AAA = "EEE-dd-MMM-yyyy-hh:mm aaa"
    static let loginCaller = "Loguin"
    static let idDefault = "0"
    static let nombreDefault = "Seleccionar..."
    static let getJSON  = "G"
    static let sendJSON = "S"
    static let capacidadDefault = 0
    static let exito = "1"
    static let errorTltCoreData = "5"
    static let rowDF = 0
    static let componentDF = 0
    static let boolDF = true
    static let errorTltBD  = "6"
    static let reservaTlt  = "7"
    static let reservaMsg  = "5"

    class func dateFromString(_ date: Date, dateFormat: String) -> String! {
    
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = dateFormat
    
    let dateString = dateformatter.string(from: date)
    
    return dateString
    
    }

}
