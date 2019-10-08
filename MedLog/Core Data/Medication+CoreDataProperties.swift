//
//  Medication+CoreDataProperties.swift
//  MedLog
//
//  Created by Morgan Davison on 10/7/19.
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
    @NSManaged public var doses: NSSet?

}

// MARK: Generated accessors for doses
extension Medication {

    @objc(addDosesObject:)
    @NSManaged public func addToDoses(_ value: Dose)

    @objc(removeDosesObject:)
    @NSManaged public func removeFromDoses(_ value: Dose)

    @objc(addDoses:)
    @NSManaged public func addToDoses(_ values: NSSet)

    @objc(removeDoses:)
    @NSManaged public func removeFromDoses(_ values: NSSet)

}
