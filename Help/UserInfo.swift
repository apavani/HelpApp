//
//  UserInfo.swift
//  Help
//
//  Created by Adarshkumar Pavani on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import Foundation

class UserInfo{
    
    var name: String
    var macID: String
    var distance: Float
    var timeStamp : String
    var messageText : String
    var latitude : Float
    var longitude : Float
    var oldTimeStamp : String = ""
    
    init(name: String, macID: String, distance: Float, oldTimeStamp : String, timeStamp: String, messageText: String, latitude: Float, longitude: Float)
    {
        self.name = name
        self.macID = macID
        self.distance = distance
        self.timeStamp = timeStamp
        self.oldTimeStamp = oldTimeStamp
        self.messageText = messageText
        self.latitude = latitude
        self.longitude = longitude
    }

}