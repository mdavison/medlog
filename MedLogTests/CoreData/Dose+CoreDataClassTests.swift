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
//    var medication: Medication?
//    var user: User?
//    var dose: Dose?
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = MockCoreDataStack(modelName: "MedLogMock")
        
//        guard let coreDataStack = coreDataStack else {
//            XCTFail("Expected coreDataStack to be set")
//            return
//        }
        
//        medication = Medication(name: "Test Med", coreDataStack: coreDataStack)
//        user = User(name: "Test User", coreDataStack: coreDataStack)
//        dose = Dose(context: coreDataStack.managedContext)
    }

    override func tearDown() {
        clearDatabase()
        
        coreDataStack = nil
//        medication = nil
//        user = nil
//        dose = nil
    }

    func testCheckEmpty() {
        if let coreDataStack = coreDataStack {
            let doses = Dose.getAll(with: coreDataStack)
            XCTAssertEqual(doses.count, 0)
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
            Dose(context: coreDataStack.managedContext),
            Dose(context: coreDataStack.managedContext),
            Dose(context: coreDataStack.managedContext)
        ]
        
        coreDataStack.saveContext()
        
        let doses = Dose.getAll(with: coreDataStack)
        
        XCTAssertEqual(doses.count, 3)
    }
    
    func testGetAllForUser() {
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        guard
        
        let user1 = User(name: "TestUser1", coreDataStack: coreDataStack),
        let user2 = User(name: "TestUser2", coreDataStack: coreDataStack),
        let med1 = Medication(name: "TestMed1", coreDataStack: coreDataStack),
        let med2 = Medication(name: "TestMed2", coreDataStack: coreDataStack) else {
            XCTFail("Unable to set up users and medications")
            return
        }
        
        let _ = [
            Dose(date: Date(), medication: med1, user: user1, coreDataStack: coreDataStack),
            Dose(date: Date(), medication: med2, user: user2, coreDataStack: coreDataStack),
            Dose(date: Date(), medication: med2, user: user2, coreDataStack: coreDataStack)
        ]
        let doses = Dose.getAll(for: user2, coreDataStack: coreDataStack)
        
        XCTAssertEqual(doses.count, 2)
    }
    
    // MARK: - Helpers
    
    private func clearDatabase() {
        let doses = Dose.getAll(with: coreDataStack!)
        for dose in doses {
            coreDataStack?.managedContext.delete(dose)
        }
    }
}
