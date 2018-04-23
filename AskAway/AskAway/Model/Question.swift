//
//  Question.swift
//  AskAway
//
//  Created by Daniel Salib on 4/23/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import Foundation

struct Question{
    var questionID: String = ""
    var title: String = ""
    var isAnswered: Bool = false
    var ownerID: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var messages: [[String: String]] = [[:]]
    
    init(title: String, owner: String, message: String){
        self.title = title
        self.ownerID = owner
        self.messages.append([owner : message])
    }
    
    init(questionID: String, title: String, isAnswered: Bool, owner: String, messages: [[String: String]]){
        self.questionID = questionID
        self.title = title
        self.ownerID = owner
        self.isAnswered = isAnswered
        self.messages = messages
    }
}
