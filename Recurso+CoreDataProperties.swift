//
//  Recurso+CoreDataProperties.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/14/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Recurso {

    @NSManaged var idRecurso: String?
    @NSManaged var nombreRecurso: String?
    @NSManaged var capacidad: NSNumber?

}
