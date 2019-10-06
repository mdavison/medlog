//
//  Medication+CoreDataProperties.swift
//  MedLog
//
//  Created by Morgan Davison on 10/6/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//

import Foundation
import CoreData


extension Medication {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medication> {
        return NSFetchRequest<Medication>(entityName: "Medication")
    }

    @NSManaged public var name: String?

}
