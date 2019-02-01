//
//  Reserva+CoreDataProperties.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 2/9/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Reserva {

    @NSManaged var fechaFinal: String?
    @NSManaged var fechaInicial: String?
    @NSManaged var horaFinal: String?
    @NSManaged var horaInicial: String?
    @NSManaged var idArea: String?
    @NSManaged var idAsignatura: String?
    @NSManaged var idBloque: String?
    @NSManaged var idGrupo: String?
    @NSManaged var idPrograma: String?
    @NSManaged var idRecurso: String?
    @NSManaged var idReserva: String?
    @NSManaged var idSede: String?
    @NSManaged var idTipoActividad: String?

}
