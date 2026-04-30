//
//  Subject.swift
//  Smartly
//
//  Created by xavier schulz on 30/4/2026.
//

import SwiftData
import SwiftUI
// Swift data is for saving the data, and the SwiftUI is for the colour Hex

@Model
class Subject {
    var name:String
    var teacher:String
    var room:String
    var colourHex:String
    
    init(name: String, teacher: String, room: String, colourHex: String) {
        self.name = name
        self.teacher = teacher
        self.room = room
        self.colourHex = colourHex
    }
}

