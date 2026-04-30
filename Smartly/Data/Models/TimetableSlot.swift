//
//  TimetableSlot.swift
//  Smartly
//
//  Created by xavier schulz on 30/4/2026.
//

import SwiftData

@Model
class TimetableSlot {
    var day: Int
    var periodindex: Int
    var subject: Subject? // the ? is that it could be empty
    
    init(day: Int, periodindex: Int, subject: Subject? = nil) {
        self.day = day
        self.periodindex = periodindex
        self.subject = subject
    }
}
