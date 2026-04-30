//
//  PeriodTimes.swift
//  Smartly
//
//  Created by xavier schulz on 30/4/2026.
//

import Foundation

// structure for holding the data points for each period of the day
struct PeriodTimes: Codable {
    let label: String
    let startHour: Int
    let startMinute: Int
    let endHour: Int
    let endMinute: Int
}

let mondayPeriods: [PeriodTimes] = [
    PeriodTimes(label: "Pastoral Care", startHour: 8,  startMinute: 25, endHour: 8,  endMinute: 45),
    PeriodTimes(label: "Period 1",      startHour: 8,  startMinute: 45, endHour: 9,  endMinute: 40),
    PeriodTimes(label: "Period 2",      startHour: 9,  startMinute: 40, endHour: 10, endMinute: 35),
    // recess is 10:35 – 10:55 (we just skip it, no slot needed)
    PeriodTimes(label: "Period 3",      startHour: 10, startMinute: 55, endHour: 11, endMinute: 50),
    PeriodTimes(label: "Period 4",      startHour: 11, startMinute: 50, endHour: 12, endMinute: 45),
    // lunch is 12:45 – 13:20
    PeriodTimes(label: "Period 5",      startHour: 13, startMinute: 20, endHour: 14, endMinute: 15),
    PeriodTimes(label: "Period 6",      startHour: 14, startMinute: 15, endHour: 15, endMinute: 10),
]

let tuesdayPeriods: [PeriodTimes] = [
    PeriodTimes(label: "Pastoral Care", startHour: 8,  startMinute: 25, endHour: 8,  endMinute: 45),
    PeriodTimes(label: "Period 1",      startHour: 8,  startMinute: 45, endHour: 9,  endMinute: 40),
    PeriodTimes(label: "Period 2",      startHour: 9,  startMinute: 40, endHour: 10, endMinute: 35),
    PeriodTimes(label: "Period 3",      startHour: 10, startMinute: 55, endHour: 11, endMinute: 50),
    PeriodTimes(label: "Period 4",      startHour: 11, startMinute: 50, endHour: 12, endMinute: 45),
    PeriodTimes(label: "Period 5",      startHour: 13, startMinute: 20, endHour: 14, endMinute: 15),
    PeriodTimes(label: "Period 6",      startHour: 14, startMinute: 15, endHour: 15, endMinute: 10),
]

let wednesdayPeriods: [PeriodTimes] = [
    PeriodTimes(label: "Pastoral Care", startHour: 8,  startMinute: 25, endHour: 8,  endMinute: 45),
    PeriodTimes(label: "Period 1",      startHour: 8,  startMinute: 45, endHour: 9,  endMinute: 40),
    PeriodTimes(label: "Period 2",      startHour: 9,  startMinute: 40, endHour: 10, endMinute: 35),
    PeriodTimes(label: "Period 3",      startHour: 10, startMinute: 55, endHour: 11, endMinute: 50),
    PeriodTimes(label: "Period 4",      startHour: 11, startMinute: 50, endHour: 12, endMinute: 45),
    PeriodTimes(label: "Period 5",      startHour: 13, startMinute: 20, endHour: 14, endMinute: 15),
    PeriodTimes(label: "Period 6",      startHour: 14, startMinute: 15, endHour: 15, endMinute: 10),
]

let thursdayPeriods: [PeriodTimes] = [
    PeriodTimes(label: "Period 1",                       startHour: 8,  startMinute: 25, endHour: 9,  endMinute: 15),
    PeriodTimes(label: "Period 2",                       startHour: 9,  startMinute: 15, endHour: 10,  endMinute: 5),
    PeriodTimes(label: "Social Emotional Learning",      startHour: 10,  startMinute: 5, endHour: 10, endMinute: 35),
    PeriodTimes(label: "Period 3",                       startHour: 10, startMinute: 55, endHour: 11, endMinute: 50),
    PeriodTimes(label: "Period 4",                       startHour: 11, startMinute: 50, endHour: 12, endMinute: 45),
    PeriodTimes(label: "Period 5",                       startHour: 13, startMinute: 20, endHour: 14, endMinute: 15),
    PeriodTimes(label: "Period 6",                       startHour: 14, startMinute: 15, endHour: 15, endMinute: 10),
]

let fridayPeriods: [PeriodTimes] = [
    PeriodTimes(label: "Pastoral Care Extended", startHour: 8,  startMinute: 25, endHour: 9,  endMinute: 15),
    PeriodTimes(label: "Period 1",               startHour: 9,  startMinute: 15, endHour: 10, endMinute: 5),
    PeriodTimes(label: "Period 2",               startHour: 10, startMinute: 5,  endHour: 10, endMinute: 55),
    PeriodTimes(label: "Period 3",               startHour: 11, startMinute: 15, endHour: 12, endMinute: 5),
    PeriodTimes(label: "Period 4",               startHour: 12, startMinute: 5,  endHour: 12, endMinute: 55),
    PeriodTimes(label: "Period 5",               startHour: 13, startMinute: 30, endHour: 14, endMinute: 20),
    PeriodTimes(label: "Period 6",               startHour: 14, startMinute: 20, endHour: 15, endMinute: 10),
]
