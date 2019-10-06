//
//  MockCoreDataStack.swift
//  MedLogTests
//
//  Created by Morgan Davison on 10/6/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest
import CoreData
@testable import MedLog

class MockCoreDataStack: CoreDataStack {
    
    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        return managedObjectModel
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName, managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (description, error) in
            // Check if the data store is in memory
            precondition(description.type == NSInMemoryStoreType)
            
            // Check if creating container wrong
            if let error = error {
                fatalError("In-memory coordinator creation failed. \(error)")
            }
        })
        return container
    }()
    
    override func getManagedContext() -> NSManagedObjectContext {
        return self.storeContainer.viewContext
    }

}
