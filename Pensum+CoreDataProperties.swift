//
//  Pensum+CoreDataProperties.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 2/1/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pensum {

    @NSManaged var idPensum: String?
    @NSManaged var idPrograma: String?
    @NSManaged var idAsignatura: String?
    @NSManaged var idArea: String?

}
