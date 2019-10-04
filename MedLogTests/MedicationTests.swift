//
//  MedicationTests.swift
//  MedLogTests
//
//  Created by Morgan Davison on 10/2/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import XCTest
@testable import MedLog

class MedicationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetMedications() {
        let meds = Medication.getSampleMeds()
        
        XCTAssertEqual(meds.count, 3)
    }

}
