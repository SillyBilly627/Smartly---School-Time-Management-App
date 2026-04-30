//
//  TimetableView.swift
//  Smartly
//
//  Created by xavier schulz on 30/4/2026.
//

import SwiftUI
import SwiftData

struct TimetableView: View {

    // this pulls all TimetableSlots from the saved data
    // SwiftData automatically keeps this up to date
    @Query var allSlots: [TimetableSlot]

    // the days of the school week
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

    // @State = this value changes when the user taps a different day
    // we start with today's day name
    @State var selectedDay: String = {
        // this figures out what day of the week it is right now
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"          // "EEEE" = full day name
        let today = formatter.string(from: Date())
        // if it's Saturday or Sunday, default to Monday
        if ["Saturday", "Sunday"].contains(today) {
            return "Monday"
        }
        return today
    }()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // --- DAY PICKER (the row of day buttons at the top) ---
                ScrollView(.horizontal, showsIndicators: false) {
                    // .horizontal makes it scroll sideways
                    // showsIndicators: false hides the scroll bar
                    HStack(spacing: 8) {

                        // ForEach loops through each day
                        ForEach(weekdays, id: \.self) { day in

                            // each day is a tappable button
                            Button(action: {
                                selectedDay = day   // update the selected day
                            }) {
                                // show just the first 3 letters (Mon, Tue, etc.)
                                Text(String(day.prefix(3)))
                                    .font(.headline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        // highlight the selected day
                                        selectedDay == day
                                            ? Color.blue        // selected = blue
                                            : Color(.systemGray5) // not selected = grey
                                    )
                                    .foregroundColor(
                                        selectedDay == day ? .white : .primary
                                    )
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }

                // --- PERIOD LIST ---
                // get the correct period times for the selected day
                let periods = periodsForDay(selectedDay)

                List {
                    // loop through each period with its index number
                    ForEach(Array(periods.enumerated()), id: \.offset) { index, period in

                        // find the timetable slot for this day and period
                        // .first(where:) searches the array and returns the first match
                        let slot = allSlots.first(where: {
                            $0.day == selectedDay && $0.periodIndex == index
                        })

                        // show one row for this period
                        PeriodRow(
                            period: period,
                            subject: slot?.subject  // pass the subject if one is assigned
                        )
                    }
                }

            }
            .navigationTitle("Timetable")
        }
    }
}
