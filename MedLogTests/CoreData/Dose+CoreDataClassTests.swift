//
//  Dose+CoreDataClassTests.swift
//  MedLogTests
//
//  Created by Morgan Davison on 10/7/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest
import CoreData
@testable import MedLog

class Dose_CoreDataClassTests: XCTestCase {

    var coreDataStack: MockCoreDataStack?
    var medication: Medication?
    var user: User?
    var dose: Dose?
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = MockCoreDataStack(modelName: "MedLogMock")
        
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        medication = Medication(context: coreDataStack.managedContext)
        user = User(context: coreDataStack.managedContext)
        dose = Dose(context: coreDataStack.managedContext)
        
        clearDatabase()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckEmpty() {
        if let coreDataStack = coreDataStack {
            let doses = Dose.getAll(with: coreDataStack)
            XCTAssertEqual(doses.count, 0)
        } else {
            XCTFail()
        }
    }
    
    // MARK: - Helpers
    
    private func clearDatabase() {
        let doses = Dose.getAll(with: coreDataStack!)
        for dose in doses {
            coreDataStack?.managedContext.delete(dose)
        }
    }
}
