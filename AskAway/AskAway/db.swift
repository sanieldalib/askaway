//
//  db.swift
//  AskAway
//
//  Created by Daniel Salib on 4/7/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import Foundation
import FirebaseDatabase

class db {
    var reference: DatabaseReference?
    
    func getDBReference(){
        self.reference = Database.database().reference()
    }
    func addSessionDB (session: Session){
        getDBReference()
        self.reference?.child("Sessions").childByAutoId().setValue(["Name": session.name, "Owner": session.owner, "Location": session.location, "QuestionsEnabled": session.questionsOn, "QueueEnabled": session.queueOn])
    }
    
//    func getSessions(){
//        getDBReference()
//        self.reference?.child("Sessions").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let item = snapshot.value {
//                print(item)
//            }
//        })
//    }
}
