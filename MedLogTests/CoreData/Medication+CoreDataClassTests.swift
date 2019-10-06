//
//  Medication+CoreDataClassTests.swift
//  MedLogTests
//
//  Created by Morgan Davison on 10/6/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest
import CoreData
@testable import MedLog

class Medication_CoreDataClassTests: XCTestCase {
    
    var coreDataStack: MockCoreDataStack?
    var medication: Medication?

    override func setUp() {
        super.setUp()
        
        coreDataStack = MockCoreDataStack(modelName: "MedLogMock")
        
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        medication = Medication(context: coreDataStack.managedContext)
        
        clearDatabase()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckEmpty() {
        if let coreDataStack = coreDataStack {
            let meds = Medication.getAll(with: coreDataStack)
            XCTAssertEqual(meds.count, 0)
        } else {
            XCTFail()
        }
    }
    
    func testGetAll() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        let _ = [
            Medication(context: coreDataStack.managedContext),
            Medication(context: coreDataStack.managedContext),
            Medication(context: coreDataStack.managedContext)
        ]
        
        coreDataStack.saveContext()
        
        let meds = Medication.getAll(with: coreDataStack)
        
        XCTAssertEqual(meds.count, 3)
    }
    
    // MARK: - Helpers
    
    private func clearDatabase() {
        let meds = Medication.getAll(with: coreDataStack!)
        for med in meds {
            coreDataStack?.managedContext.delete(med)
        }
    }

}
