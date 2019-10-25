//
//  User+CoreDataClassTests.swift
//  MedLogTests
//
//  Created by Morgan Davison on 10/6/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest
import CoreData
@testable import MedLog

class User_CoreDataClassTests: XCTestCase {

    var coreDataStack: MockCoreDataStack?
    var user: User?
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = MockCoreDataStack(modelName: "MedLogMock")
        
        guard let coreDataStack = coreDataStack else {
            XCTFail("Expected coreDataStack to be set")
            return
        }
        
        user = User(context: coreDataStack.managedContext)
        
        // Make sure we start with an empty db
        clearDatabase()
    }

    override func tearDown() {
        super.tearDown()
        
        clearDatabase()
    }
    
    func testCheckEmpty() {
        if let coreDataStack = coreDataStack {
            let users = User.getAll(with: coreDataStack)
            XCTAssertEqual(users.count, 0)
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
            User(context: coreDataStack.managedContext),
            User(context: coreDataStack.managedContext),
            User(context: coreDataStack.managedContext)
        ]
        
        coreDataStack.saveContext()
        
        let users = User.getAll(with: coreDataStack)
        
        XCTAssertEqual(users.count, 3)
    }
    
    func testCheckNameExistsTrue() {
        let _ = User(name: "Tester", coreDataStack: coreDataStack!)
        coreDataStack!.saveContext()
        
        XCTAssertEqual(User.checkNameExists("Tester", coreDataStack: coreDataStack!), true)
    }

    func testCheckNameExistsFalse() {
        let _ = User(name: "Tester", coreDataStack: coreDataStack!)
        coreDataStack!.saveContext()
        
        XCTAssertEqual(User.checkNameExists("Tester2", coreDataStack: coreDataStack!), false)
    }
    

    
    // MARK: - Helpers
    
    private func clearDatabase() {
        let users = User.getAll(with: coreDataStack!)
        for user in users {
            coreDataStack?.managedContext.delete(user)
        }
    }
    
}
