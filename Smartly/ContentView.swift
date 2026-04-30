//
//  ContentView.swift
//  Smartly
//
//  Created by xavier schulz on 29/4/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        // TabView creates the tab bar at the bottom of the screen
        // on macOS this shows as a sidebar instead — SwiftUI handles it
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            TimetableView()                 // the timetable screen (we'll build this)
                .tabItem {                  // what shows in the tab bar
                    Image(systemName: "calendar")   // calendar icon
                    Text("Timetable")               // label
                }

            AssignmentListView()            // the assignments screen
                .tabItem {
                    Image(systemName: "checklist")  // checklist icon
                    Text("Assignments")
                }

            SettingsView()                  // settings screen
                .tabItem {
                    Image(systemName: "gear")       // gear icon
                    Text("Settings")
                }

        }
    }
}
