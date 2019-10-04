//
//  Dose.swift
//  MedLog
//
//  Created by Morgan Davison on 10/1/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import Foundation

struct Dose {
    let medication: Medication
    let user: User
    let date: Date
    
    static func getSampleDoses() -> [Dose] {
        let dose1 = Dose(
            medication: Medication(name: "Tylenol"),
            user: User(name: "Jim"),
            date: Date()
        )
        let dose2 = Dose(
            medication: Medication(name: "Advil"),
            user: User(name: "Jim"),
            date: Date()
        )
        
        return [dose1, dose2]
    }
}
