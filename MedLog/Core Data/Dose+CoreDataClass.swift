//
//  Dose+CoreDataClass.swift
//  MedLog
//
//  Created by Morgan Davison on 10/7/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//  This is the file that does NOT get auto-generated. Put all custom stuff here.

import Foundation
import CoreData

@objc(Dose)
public class Dose: NSManagedObject {
    
    convenience init?(date: Date, medication: Medication, user: User, coreDataStack: CoreDataStack) {
        self.init(context: coreDataStack.managedContext)
        
        self.date = date
        self.medication = medication
        self.user = user
        
        coreDataStack.saveContext()
    }
    
    static func getAll(with coreDataStack: CoreDataStack) -> [Dose] {
        var doses = [Dose]()
        
        let request: NSFetchRequest<Dose> = Dose.fetchRequest()
        do {
            doses = try coreDataStack.managedContext.fetch(request) as [Dose]
        } catch let error {
            print(error.localizedDescription)
        }
        
        return doses
    }
    
    static func getAll(for user: User, coreDataStack: CoreDataStack) -> [Dose] {
        var doses = [Dose]()
        
        guard let userName = user.name else { return doses }
        
        let request: NSFetchRequest<Dose> = Dose.fetchRequest()
        request.predicate = NSPredicate(format: "user.name == %@", userName)
        do {
            doses = try coreDataStack.managedContext.fetch(request) as [Dose]
        } catch let error {
            print(error.localizedDescription)
        }
        
        return doses
    }

}
