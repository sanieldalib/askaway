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
    var sessions: [Session?] = []
    
    func getDBReference(){
        self.reference = Database.database().reference()
    }
    func addSessionDB (session: Session){
        getDBReference()
        self.reference?.child("Sessions").childByAutoId().setValue(["Name": session.name, "Owner": session.owner, "Location": session.location, "QuestionsEnabled": session.questionsOn, "QueueEnabled": session.queueOn])
    }
    
    func getSessions(callback: @escaping () -> ()){
        self.sessions.removeAll()
        getDBReference()
        self.reference?.child("Sessions").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snap = snapshot.value as? NSDictionary{
                for (_, value) in snap{
                    if let sessionData = value as? NSDictionary{
                        let session = Session(name: sessionData["Name"] as! String, owner: sessionData["Owner"] as! String, location: sessionData["Location"] as! String, questionsOn: sessionData["QuestionsEnabled"] as! Bool, queueOn: sessionData["QueueEnabled"] as! Bool)
                        self.sessions.append(session)
                    }
                }
                DispatchQueue.main.async {
                    callback()
                }
            }
        })
    }
    

}
