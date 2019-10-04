//
//  User.swift
//  MedLog
//
//  Created by Morgan Davison on 10/1/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import Foundation

struct User {
    
    let name: String
    
    static func getSampleUsers() -> [User] {
        var users = [User]()
        for i in 0...2 {
            users.append(User(name: "User_\(i)"))
        }
        
        return users
    }
}
