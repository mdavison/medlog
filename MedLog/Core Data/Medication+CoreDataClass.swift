//
//  Medication+CoreDataClass.swift
//  MedLog
//
//  Created by Morgan Davison on 10/6/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//
//  This is the file that does NOT get auto-generated. Put all custom stuff here.

import Foundation
import CoreData

@objc(Medication)
public class Medication: NSManagedObject {

    convenience init?(name: String, coreDataStack: CoreDataStack) {
        self.init(context: coreDataStack.managedContext)
        
        self.name = name
        coreDataStack.saveContext()
    }
    
    static func getAll(with coreDataStack: CoreDataStack) -> [Medication] {
        var medications = [Medication]()
        
        let request: NSFetchRequest<Medication> = Medication.fetchRequest()
        do {
            medications = try coreDataStack.managedContext.fetch(request) as [Medication]
        } catch let error {
            print(error.localizedDescription)
        }
        
        return medications
    }
}
