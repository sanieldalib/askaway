
//
//  db.swift
//  AskAway
//
//  Created by Daniel Salib on 4/7/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class db {
    
    var reference: DatabaseReference?
    static var current: Session?
    var sessions: [Session?] = []
    var profiles: [Profile] = []
    var userSessions: [Session] = []
    var queue: [String] = []
    var queueProfile: [Profile] = []
    var answered: [Question] = []
    var unanswered: [Question] = []
    
    func getDBReference(){
        self.reference = Database.database().reference()
    }
    
    static func getCurrentSession() -> Session{
        return current!
    }
    
    static func setCurrentSession(session: Session){
        current = session
    }
    
    func initGeofire(){
        
    }
    
    func addGeofire(){
        
    }
    
    func addSessionDB (session: Session, callback: (String) -> ()){
        getDBReference()
        let id = self.reference?.child("Sessions").childByAutoId()
        let stringData = ["Name": session.name, "Owner": session.ownerUID, "Location": session.location, "Passcode": session.passcode]
        let doubleData = ["Lat": session.lat, "Long": session.long]
        let boolData = ["passwordEnabled": session.passwordEnabled, "locationEnabled": session.locationEnabled]
        let ref = self.reference?.child("Sessions").child(id!.key)
        ref?.child("Strings").setValue(stringData)
        ref?.child("Doubles").setValue(doubleData)
        ref?.child("Bools").setValue(boolData)
        ref?.child("Members").setValue([currentUser?.uid])
        ref?.child("id").setValue(id!.key)
        addRoom(roomId: id!.key)
        
        callback(id!.key)
    }
    
    func addUser(person: Profile, callback: () -> ()){
        getDBReference()
        self.reference?.child("Users").child(person.uid).child("info").setValue(["firstName": person.firstName, "lastName": person.lastName, "email": person.email])
        self.reference?.child("Users").child(person.uid).child("Rooms").setValue([])
        callback()
    }
    
    func addRoom(roomId: String){
        getDBReference()
        self.reference?.child("Users").child(currentUser!.uid).child("Rooms").observeSingleEvent(of: .value) { (snapshot) in
            if var rooms = snapshot.value as? [String]{
                rooms.append(roomId)
                self.reference?.child("Users").child(currentUser!.uid).child("Rooms").setValue(rooms)
            } else {
                var rooms: [String] = []
                rooms.append(roomId)
                self.reference?.child("Users").child(currentUser!.uid).child("Rooms").setValue(rooms)
            }
        }
    }
    
    func getMySessions(callback: @escaping () -> ()){
        self.userSessions.removeAll()
        getDBReference()
        self.reference?.child("Sessions").observeSingleEvent(of: .value, with: { (snapshot) in
            for room in currentUser!.rooms{
                if let sessionData = snapshot.childSnapshot(forPath: room).value as? NSDictionary{
                    if let bools = sessionData["Bools"] as? NSDictionary, let members = sessionData["Members"] as? [String], let strings = sessionData["Strings"] as? NSDictionary, let id = sessionData["id"] as? NSString {
                        if bools["locationEnabled"] as! Bool {
                            if let doubles = sessionData["Doubles"] as? NSDictionary{
                                //location enabled rooms
                                switch bools["passwordEnabled"] as! Bool{
                                case true:
                                    var session = Session(name: strings["Name"] as! String, owner: strings["Owner"] as! String, passcode: strings["Passcode"] as! String, location: strings["Location"] as! String, lat: doubles["Lat"] as! Double, long: doubles["Long"] as! Double)
                                    session.members = members
                                    session.ownerProf = currentUser
                                    session.firebaseID = id as String
                                    self.userSessions.append(session)
                                default:
                                    var session = Session(name: strings["Name"] as! String, owner: strings["Owner"] as! String, location: strings["Location"] as! String, lat: doubles["Lat"] as! Double, long: doubles["Long"] as! Double)
                                    session.members = members
                                    session.ownerProf = currentUser
                                    session.firebaseID = id as String
                                    self.userSessions.append(session)
                                }}} else {
                            switch bools["passwordEnabled"] as! Bool{
                            //location disabled rooms
                            case true:
                                var session = Session(name: strings["Name"] as! String, owner: strings["Owner"] as! String, passcode: strings["Passcode"] as! String, location: strings["Location"] as! String)
                                session.members = members
                                session.ownerProf = currentUser
                                session.firebaseID = id as String
                                self.userSessions.append(session)
                            default:
                                var session = Session(name: strings["Name"] as! String, owner: strings["Owner"] as! String, location: strings["Location"] as! String)
                                session.members = members
                                session.ownerProf = currentUser
                                session.firebaseID = id as String
                                self.userSessions.append(session)
                            }
                        }
                    }
                }
            }
            callback()
        })
    }
    
    func getSessions(callback: @escaping () -> ()){
        self.sessions.removeAll()
        getDBReference()
        self.reference?.child("Sessions").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snap = snapshot.value as? NSDictionary{
                for (_, value) in snap{
                    if let sessionData = value as? NSDictionary{
                        if let bools = sessionData["Bools"] as? NSDictionary, let members = sessionData["Members"] as? [String], let strings = sessionData["Strings"] as? NSDictionary, let id = sessionData["id"] as? NSString {
                            if bools["locationEnabled"] as! Bool {
                                if let doubles = sessionData["Doubles"] as? NSDictionary{
                                    //location enabled rooms
                                    switch bools["passwordEnabled"] as! Bool{
                                    case true:
                                        var session = Session(name: strings["Name"] as! String, owner: strings["Owner"] as! String, passcode: strings["Passcode"] as! String, location: strings["Location"] as! String, lat: doubles["Lat"] as! Double, long: doubles["Long"] as! Double)
                                        session.members = members
                                        session.firebaseID = id as String
                                        self.sessions.append(session)
                                    default:
                                        var session = Session(name: strings["Name"] as! String, owner: strings["Owner"] as! String, location: strings["Location"] as! String, lat: doubles["Lat"] as! Double, long: doubles["Long"] as! Double)
                                        session.members = members
                                        session.firebaseID = id as String
                                        self.sessions.append(session)
                                    }}} else {
                                switch bools["passwordEnabled"] as! Bool{
                                //location disabled rooms
                                case true:
                                    var session = Session(name: strings["Name"] as! String, owner: strings["Owner"] as! String, passcode: strings["Passcode"] as! String, location: strings["Location"] as! String)
                                    session.members = members
                                    session.firebaseID = id as String
                                    self.sessions.append(session)
                                default:
                                    var session = Session(name: strings["Name"] as! String, owner: strings["Owner"] as! String, location: strings["Location"] as! String)
                                    session.members = members
                                    session.firebaseID = id as String
                                    self.sessions.append(session)
                                }
                            }}
                    }
                }
            }
            var i = 0
            self.reference?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                for session in self.sessions {
                    if let snap = snapshot.value as? NSDictionary{
                        if let user = snap[session!.ownerUID] as? NSDictionary{
                            if let info = user["info"] as? NSDictionary{
                                if let rooms = user["Rooms"] as? [String]{
                                    let ownerProf = Profile(firstName: info["firstName"] as! String, lastName: info["lastName"] as! String, uid: session!.ownerUID, email: info["email"] as! String, rooms: rooms)
                                    self.sessions[i]!.ownerProf = ownerProf
                                    i = i + 1
                                } else {
                                    let ownerProf = Profile(firstName: info["firstName"] as! String, lastName: info["lastName"] as! String, uid: session!.ownerUID, email: info["email"] as! String, rooms: [])
                                    self.sessions[i]!.ownerProf = ownerProf
                                    i = i + 1
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    callback()
                }
            })
        })
    }
    
    func addMembertoSession(session: Session, personUID: String, callback: @escaping () -> ()){
        self.reference?.child("Sessions").child(session.firebaseID).child("Members").observeSingleEvent(of: .value, with: { (snapshot) in
            if var members = snapshot.value as? [String]{
                members.append(personUID)
                self.reference?.child("Sessions").child(session.firebaseID).child("Members").setValue(members)
                self.reference?.child("Users").child(personUID).child("Rooms").observeSingleEvent(of: .value, with: { (snapshot) in
                    if var rooms = snapshot.value as? [String]{
                        rooms.append(session.firebaseID)
                    }
                    callback()
                })
            }
        })
    }
    
    func getUserRooms(callback: @escaping () -> ()){
        self.getDBReference()
        self.reference?.child("Users").child(currentUser!.uid).child("Rooms").observeSingleEvent(of: .value, with: { (snapshot) in
            if let rooms = snapshot.value as? [String]{
                currentUser!.rooms = rooms
            }
            self.getMySessions(callback: {
                callback()
            })
        })
    }
    
    func getUser(uid: String){
        self.getDBReference()
        self.reference?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snap = snapshot.value as? NSDictionary{
                if let userInfo = snap["info"] as? NSDictionary{
                    let userProfile =  Profile(firstName: userInfo["firstName"]! as! String, lastName: userInfo["lastName"]! as! String, uid: uid, email: userInfo["email"]! as! String)
                    self.setCurrentUser(user: userProfile)
                }
            }
        })
    }
    
    func getQueueUsers(callback: @escaping () -> ()){
        self.getDBReference()
        self.queueProfile.removeAll()
        self.reference?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            for user in self.queue{
                if let snap = snapshot.childSnapshot(forPath: user).value as? NSDictionary{
                    if let userInfo = snap["info"] as? NSDictionary{
                        let userProfile =  Profile(firstName: userInfo["firstName"]! as! String, lastName: userInfo["lastName"]! as! String, uid: user, email: userInfo["email"]! as! String)
                        self.queueProfile.append(userProfile)
                    }
                }
            }
            callback()
        })
    }
    
    
    func getSessionProfiles(callback: () -> ()){
        var i = 0
        for session in self.sessions {
            self.reference?.child("Users").child(session!.ownerUID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snap = snapshot.value as? NSDictionary{
                    if let info = snap["info"] as? NSDictionary{
                        if let rooms = snap["Rooms"] as? [String]{
                            let ownerProf = Profile(firstName: info["firstName"] as! String, lastName: info["lastName"] as! String, uid: session!.ownerUID, email: info["email"] as! String, rooms: rooms)
                            self.sessions[i]!.ownerProf = ownerProf
                            i = i + 1
                        } else {
                            let ownerProf = Profile(firstName: info["firstName"] as! String, lastName: info["lastName"] as! String, uid: session!.ownerUID, email: info["email"] as! String, rooms: [])
                            self.sessions[i]!.ownerProf = ownerProf
                            i = i + 1
                        }
                    }
                }
            })
            //        print(self.sessions)
            //        callback()
        }
    }
    
    func addProfilestoSessions(callback: () -> ()){
        var i = 0
        print(self.profiles.count)
        for profile in self.profiles{
            self.sessions[i]!.ownerProf = profile
            i = i + 1
            print(self.sessions[i]!.ownerProf!.email)
        }
        callback()
    }
    
    func addUsertoQueue(user: String, session: String, callback: @escaping () -> ()){
        self.getDBReference()
        self.reference!.child("Queue").child(session).observeSingleEvent(of: .value, with: { (snapshot) in
            if var queue = snapshot.value as? [String]{
                queue.append(user)
                self.queue = queue
            } else {
                self.queue = [user]
            }
            self.reference?.child("Queue").child(session).setValue(self.queue)
            self.getQueueUsers(callback: {
            })
        })
    }
    
    func getQueue(session: String, callback:@escaping () -> ()){
        self.getDBReference()
        self.reference!.child("Queue").child(session).observeSingleEvent(of: .value, with: { (snapshot) in
            if let queue = snapshot.value as? [String]{
                self.queue = queue
            } else {
                self.queue = []
            }
            self.getQueueUsers(callback: {
                callback()
            })
        })
    }
    
    func addQuestion(question: Question, session: String, callback: (String) -> ()){
        self.getDBReference()
        let qRef = self.reference!.child("Questions").child(session).childByAutoId()
        qRef.child("isAnswered").setValue(question.isAnswered)
        qRef.child("Messages").setValue(question.messages)
        qRef.child("questionID").setValue(qRef.key)
        qRef.child("title").setValue(question.title)
        qRef.child("owner").setValue(question.ownerID)
        callback(qRef.key)
    }
    
    func getQuestions(session: String, callback: @escaping () -> ()){
        self.getDBReference()
        self.answered.removeAll()
        self.unanswered.removeAll()
        let qRef = self.reference!.child("Questions").child(session)
        let uRef = self.reference!.child("Users")
        qRef.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? NSDictionary{
                for question in snap{
                    if let body = question.value as? NSDictionary{
                        if let isAnswered = body["isAnswered"] as? Bool,let title = body["title"] as? String,let owner = body["owner"] as? String, let messages = body["Messages"] as? NSArray{
                            var messageArray: [[String: String]] = []
                            for message in messages{
                                if let messageData = message as? [String: String]{
                                    messageArray.append(messageData)                            }
                            }
                            let question = Question(questionID: question.key as! String, title: title, isAnswered: isAnswered, owner: owner, messages: messageArray)
                            if question.isAnswered{
                                self.answered.append(question)
                            } else {
                                self.unanswered.append(question)
                            }
                        }
                    }
                }
            } else {
                self.answered = []
                self.unanswered = []
            }
                var i = 0
                var j = 0
                uRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    for question in self.answered {
                        if let snap = snapshot.value as? NSDictionary{
                            if let user = snap[question.ownerID] as? NSDictionary{
                                if let info = user["info"] as? NSDictionary{
                                    if let firstName = info["firstName"] as? String, let lastName = info["lastName"] as? String {
                                        self.answered[i].firstName = firstName
                                        self.answered[i].lastName = lastName
                                        i = i + 1
                                    }
                                }
                            }
                        }
                    }
                    for question in self.unanswered {
                        if let snap = snapshot.value as? NSDictionary{
                            if let user = snap[question.ownerID] as? NSDictionary{
                                if let info = user["info"] as? NSDictionary{
                                    if let firstName = info["firstName"] as? String, let lastName = info["lastName"] as? String {
                                        self.unanswered[j].firstName = firstName
                                        self.unanswered[j].lastName = lastName
                                        j = j + 1
                                    }
                                }
                            }
                        }
                    }
                    callback()
                })
            }
        }
    
    func removeQuestion(session: String, question: String, callback: @escaping () -> ()){
        self.getDBReference()
        self.reference!.child("Questions").child(session).child(question).setValue(nil)
        getQuestions(session: session) {
            callback()
        }
    }
    
    func updateQueue(session: String, callback: () -> ()){
        self.reference!.child("Queue").child(session).setValue(queue)
        callback()
    }
    
    func setCurrentUser(user: Profile){
        currentUser = user
        print(currentUser!.firstName)
    }
    
    func setSessionUser(session: Session){
        self.reference?.child("Users").child(session.ownerUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snap = snapshot.value{
                print(snap)
            }
        })
    }
    
    
}
