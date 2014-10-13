//
//  MessageQuery.swift
//  Help
//
//  Created by LiQihui on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import Foundation

class MessageQuery{
    let messages:[String]
    let oldCounts:[Int]
    let newCount:[Int]
    
    init( messages:[String], oldCounts:[Int], newCount:[Int]){
        self.messages = messages
        self.oldCounts = oldCounts
        self.newCount = newCount
    }
    
    func newMessages() ->[String]{
        
        var resultMessages: [String] = []
        for var index = 0; index < messages.count; ++index {
            resultMessages.append(messages[index])
        }
        for var index = 0; index < oldCounts.count; ++index {
            if oldCounts[index] == newCount[index]{
            resultMessages[index] = ""
            }
        }
        return resultMessages
    }
}