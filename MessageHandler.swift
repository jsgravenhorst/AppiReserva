//
//  MessageHandler.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/22/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import Foundation

class MessageHandler {
    var reservaTlt:       String!
    var errorTltLog:      String!
    var errorTltConn:     String!
    var errorTlDesrlz:    String!
    var errorTltJsonVlr:  String!
    var errorTltJsonNil:  String!
    var errorTltImagen:   String!
    var errorLoguin:      String!
    var erroConn:         String!
    var errorJsonDesrlz:  String!
    var errorJsonVlr:     String!
    var errorJsonNil:     String!
    var errorTltCoreData: String!
    var errorTltBD:       String!
    var reservaMsg:       String!
    var reservaVacia:     String!
    var errorReservaTlt:  String!
    var reservaElim:      String!
    var reservaCons:      String!
    var errorImagen:      String!
    
    init(){
        self.reservaTlt        = "Reserva Recurso"
        self.errorTltLog       = "Error Login"
        self.errorLoguin       = "Por favor ingresar el usuario y su clave"
        self.errorTltConn      = "Error conexión Internet"
        self.errorTlDesrlz     = "Error Deserializando JSON"
        self.errorTltJsonVlr   = "Error JSON datos"
        self.errorTltJsonNil   = "Error JSON nil"
        self.errorTltCoreData  = "Error CoreData"
        self.errorTltBD        = "Error Base de Datos"
        self.errorTltImagen    = "Error Imagen"
        self.erroConn          = "Por favor conectarce a Internet"
        self.errorJsonDesrlz   = "Un error ha ocurrido mientras se deserializa objeto JSON."
        self.errorJsonVlr      = "No se retorno valor"
        self.errorJsonNil      = "El objeto JSON deserilaizando es nil"
        self.reservaMsg        = "Reserva generada con éxito"
        self.reservaVacia      = "No existen reservas para el usuario"
        self.reservaElim       = "Reserva eliminada con éxito"
        self.errorReservaTlt   = "Error reserva"
        self.errorImagen       = "Error cargando la Imagen"
        self.reservaCons       = "No existen reservas para la consulta"
    }
    
    func getTitle(_ numTlt: String!) -> String {
        
        switch numTlt {
        case "0":
            return self.errorTltLog
        case "1":
            return self.errorTltConn
        case "2":
            return self.errorTlDesrlz
        case "3":
            return self.errorTltJsonVlr
        case "4":
            return self.errorJsonNil
        case "5":
            return self.errorTltCoreData
        case "6":
            return self.errorTltBD
        case "7":
            return self.reservaTlt
        case "8":
            return self.errorReservaTlt
        case "9":
            return self.errorTltImagen
        default :
            return "Título"
        }
        
    }
   
    func getMessage(_ numMsg: String!) -> String {
        switch numMsg {
        case "0":
            return self.errorLoguin
        case "1":
            return self.erroConn
        case "2":
            return self.errorJsonDesrlz
        case "3":
            return self.errorJsonVlr
        case "4":
            return self.errorJsonNil
        case "5":
            return self.reservaMsg
        case "6":
            return self.errorImagen
        case "7":
            return self.reservaVacia
        case "8":
            return self.reservaElim
        case "9":
            return self.reservaCons
        default :
            return numMsg
        }
    }
    
}
