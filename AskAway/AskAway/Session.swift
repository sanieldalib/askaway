//
//  Session.swift
//  AskAway
//
//  Created by Daniel Salib on 4/7/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

struct Session {
    var name : String = ""
    var ownerUID : String = ""
    var passwordEnabled: Bool = false
    var locationEnabled: Bool = false
    var passcode : String?
    var location : String = ""
    var lat: Double?
    var long: Double?
    var ownerProf: Profile?
    var members: [String] = []
    var firebaseID: String = ""
//    var members: [String:String] = [:]
//    var queue: [String] = []
//
//    mutating func addMember(person: Profile){
//        members[person.uid] = person.email
//    }
//
//    mutating func removeMember(person: Profile) {
//        members.removeValue(forKey: person.uid)
//    }
//
    //init methods for various types of sessions
    
    // no passcode and no geolocation
    init(name: String, owner: String, location: String) {
        self.name = name
        self.ownerUID = owner
        self.location = location
//        addMember(person: userSignedIn!)
        
    }
    //passcode w/o geolocation
    init(name: String, owner: String, passcode: String, location: String) {
        self.name = name
        self.passwordEnabled = true
        self.passcode = passcode
        self.ownerUID = owner
        self.location = location
        addMember(personUID: ownerUID)
        
    }
    //geolocated w/o passcode
    init(name: String, owner: String, location: String, locationCL: CLLocation) {
        self.name = name
        self.ownerUID = owner
        self.location = location
        self.locationEnabled = true
        self.lat = locationCL.coordinate.latitude
        self.long = locationCL.coordinate.longitude
        addMember(personUID: ownerUID)
        
    }
    //geolocated w/ passcode
    init(name: String, owner: String, passcode: String, location: String, locationCL: CLLocation) {
        self.name = name
        self.passcode = passcode
        self.passwordEnabled = true
        self.ownerUID = owner
        self.location = location
        self.locationEnabled = true
        self.lat = locationCL.coordinate.latitude
        self.long = locationCL.coordinate.longitude
        addMember(personUID: ownerUID)
        
    }
    
    //geolocated manual w/o passcode
    init(name: String, owner: String, location: String, lat: Double, long: Double) {
        self.name = name
        self.ownerUID = owner
        self.locationEnabled = true
        self.location = location
        self.lat = lat
        self.long = long
        addMember(personUID: ownerUID)
        
    }
    //geolocated manual w/ passcode
    init(name: String, owner: String, passcode: String, location: String, lat: Double, long: Double) {
        self.name = name
        self.passcode = passcode
        self.passwordEnabled = true
        self.ownerUID = owner
        self.locationEnabled = true
        self.location = location
        self.lat = lat
        self.long = long
        addMember(personUID: ownerUID)
        
    }
    
    mutating func addMember(personUID: String){
        self.members.append(personUID)
    }
    
    mutating func addID(firebaseID: String){
        self.firebaseID = firebaseID
    }
}

