//
//  Medication.swift
//  MedLog
//
//  Created by Morgan Davison on 10/1/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import Foundation

struct Medication {
    
    let name: String
    
    static func getSampleMeds() -> [Medication] {
        var meds = [Medication]()
        for i in 0...2 {
            meds.append(Medication(name: "Med_\(i)"))
        }
        
        return meds 
    }
}
