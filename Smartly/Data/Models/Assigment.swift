//
//  Assigment.swift
//  Smartly
//
//  Created by xavier schulz on 30/4/2026.
//

import SwiftData
import Foundation
// the Swift Data is for saving the data, and the Foundation is for the date an etc

@Model
class Assigment {
    var type: String
    var title: String
    var details: String
    var dueData: Date
    var isCompleted: Bool
    var notes: String
    var subject: Subject?
    
    init(type: String, title: String, details: String, dueData: Date, isCompleted: Bool, notes: String, subject: Subject? = nil) {
        self.type = type
        self.title = title
        self.details = details
        self.dueData = dueData
        self.isCompleted = isCompleted
        self.notes = notes
        self.subject = subject
    }
}
