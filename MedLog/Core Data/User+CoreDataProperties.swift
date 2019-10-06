//
//  User+CoreDataProperties.swift
//  MedLog
//
//  Created by Morgan Davison on 10/4/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?

}
