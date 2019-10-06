//
//  User+CoreDataClass.swift
//  MedLog
//
//  Created by Morgan Davison on 10/4/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//  This is the file that does NOT get auto-generated. Put all custom stuff here.

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    convenience init?(name: String, coreDataStack: CoreDataStack) {
        self.init(context: coreDataStack.managedContext)
        
        self.name = name
        coreDataStack.saveContext()
    }
    
    static func getAll(with coreDataStack: CoreDataStack) -> [User] {
        var users = [User]()
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            users = try coreDataStack.managedContext.fetch(request) as [User]
        } catch let error {
            print(error.localizedDescription)
        }
        
        return users
    }
}
