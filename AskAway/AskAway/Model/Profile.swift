//
//  Profile.swift
//  AskAway
//
//  Created by Daniel Salib on 4/18/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import Foundation
import Firebase


struct Profile {
    var firstName: String = ""
    var lastName: String = ""
    var uid: String = ""
    var email: String = ""
    var rooms: [String] = []
    
    init(firstName: String, lastName: String, uid: String, email: String){
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.email = email
    }
    
    init(firstName: String, lastName: String, uid: String, email: String, rooms: [String]){
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.email = email
        self.rooms = rooms
    }

}
