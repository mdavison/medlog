//
//  Dose+CoreDataProperties.swift
//  MedLog
//
//  Created by Morgan Davison on 10/7/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//

import Foundation
import CoreData


extension Dose {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dose> {
        return NSFetchRequest<Dose>(entityName: "Dose")
    }

    @NSManaged public var date: Date?
    @NSManaged public var medication: Medication?
    @NSManaged public var user: User?

}
