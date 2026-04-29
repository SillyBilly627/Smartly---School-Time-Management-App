# Smartly — Xcode + SwiftUI Guide
## Your School Planner App

---

## Part 1: Creating the Project

### First Time Xcode Setup

1. **Install Xcode** from the Mac App Store (free, ~12GB download)
2. Open Xcode, let it install any extra components
3. Go to **Xcode → Settings → Accounts** (or press ⌘,)
4. Click **+**, choose **GitHub**, sign into your GitHub account

### Creating the Project

1. Open Xcode → **Create New Project**
2. Choose **Multiplatform → App** ← this lets it run on both macOS AND iPad
3. Fill in:
   - **Product Name:** SchoolMate (or whatever you name it later)
   - **Team:** Your personal team (shows your name)
   - **Organization Identifier:** com.yourname (e.g. com.xavier)
   - **Storage:** SwiftData ← important! This is how the app saves data
   - **Interface:** SwiftUI
   - **Language:** Swift
4. Tick **"Create Git repository on my Mac"**
5. Save it somewhere on your Mac

### Connecting to GitHub

1. **Source Control → New "SchoolMate" Remote...**
2. Pick your GitHub account
3. Name the repo, set it to **Public** (so your teacher can see it)
4. Click **Create**

### Your Daily Commit Workflow

Every time you finish a chunk of work:

1. Press **⌥⌘C** (Option + Command + C)
2. Write a short commit message like:
   - "Added timetable setup screen"
   - "Created assignment list with due dates"
   - "Fixed period times displaying wrong"
3. Tick **"Push to remote"** at the bottom
4. Click **Commit**

**Tip:** Commit often with clear messages. Small commits like "added subject colour picker" show your teacher you built it step by step — not all at once.

---

## Part 2: Understanding the App Structure

### What You're Building

```
┌─────────────────────────────────────────┐
│              SchoolMate                  │
├──────────┬──────────┬───────────────────┤
│ Timetable│Assignments│    Settings      │
│  (Tab 1) │  (Tab 2)  │    (Tab 3)      │
├──────────┴──────────┴───────────────────┤
│                                         │
│  Tab 1: Shows today's timetable         │
│         Highlights current period       │
│         Switch between days             │
│                                         │
│  Tab 2: List of assignments/tests       │
│         Due dates, class tags           │
│         Notes and file attachments      │
│                                         │
│  Tab 3: Edit timetable, subjects        │
│         App preferences                 │
│                                         │
└─────────────────────────────────────────┘
```

### File Structure

```
SchoolMate/
├── SchoolMateApp.swift              ← App entry point
├── ContentView.swift                ← Main TabView (3 tabs)
├── Models/
│   ├── Subject.swift                ← Subject blueprint (name, teacher, room, colour)
│   ├── TimetableSlot.swift          ← One period slot (day, period number, subject)
│   └── Assignment.swift             ← Assignment blueprint (title, due date, notes, etc.)
├── Views/
│   ├── Timetable/
│   │   ├── TimetableView.swift      ← Main timetable screen
│   │   └── PeriodRow.swift          ← How one period looks in the list
│   ├── Assignments/
│   │   ├── AssignmentListView.swift  ← List of all assignments
│   │   ├── AssignmentDetailView.swift← View/edit one assignment
│   │   └── AddAssignmentView.swift  ← Form to add new assignment
│   └── Settings/
│       ├── SettingsView.swift       ← Settings main screen
│       ├── SubjectEditorView.swift  ← Add/edit subjects
│       └── TimetableEditorView.swift← Assign subjects to period slots
└── Data/
    └── PeriodTimes.swift            ← Hardcoded period start/end times
```

To create new files: **File → New → File → Swift File** (for models/data) or **SwiftUI View** (for screens).
To create folders: Right-click in the file navigator → **New Group**

---

## Part 3: SwiftUI Basics (Quick Reference)

### The Building Blocks

```swift
// --- TEXT ---
Text("Hello")                    // shows text on screen
    .font(.title)                // size: .largeTitle, .title, .headline, .body, .caption
    .bold()                      // makes it bold
    .foregroundColor(.gray)      // changes text colour

// --- IMAGES (SF Symbols — thousands of free built-in icons) ---
Image(systemName: "book.fill")   // shows an icon
    .font(.title2)               // controls the icon size
    .foregroundColor(.blue)      // icon colour
// Download the free "SF Symbols" app from Apple to browse all icons

// --- STACKS (how you arrange things) ---
VStack { }      // Vertical — stacks things top to bottom
HStack { }      // Horizontal — puts things side by side
ZStack { }      // Layers — stacks things on top of each other

// --- LISTS (scrollable content) ---
List { }        // creates a scrollable list with rows

// --- NAVIGATION ---
NavigationStack { }              // enables page titles and drill-down navigation
NavigationLink(destination: ...) // makes something tappable to go to another page

// --- MODIFIERS (styling — chain these after any view) ---
.padding()                       // adds space around something
.padding(.horizontal)            // adds space only on left and right
.background(Color(.systemGray6)) // background colour (adapts to dark mode)
.cornerRadius(10)                // rounds the corners
.frame(maxWidth: .infinity)      // stretches to fill available width
```

### Variables and State

```swift
// --- NORMAL VARIABLE (doesn't change) ---
let schoolName = "My School"     // set once, never changes

// --- @State (changes and updates the screen automatically) ---
@State var searchText = ""       // when this changes, the screen redraws
@State var selectedDay = "Monday" // perfect for things the user interacts with

// --- USING VARIABLES IN TEXT ---
Text("Hello \(schoolName)")      // \() puts a variable inside text
Text("\(speed) Speed")           // works with numbers too
```

---

## Part 4: The Data Models (Blueprints)

### Period Times — PeriodTimes.swift

These are the same for every student, so we hardcode them. Based on your school's schedule:

```swift
import Foundation  // needed for date/time stuff

// this struct holds the start and end time for one period
// "struct" = a blueprint that defines what data something holds
struct PeriodTime {
    let label: String      // what to call it: "Pastoral Care", "Period 1", etc.
    let startHour: Int     // hour in 24hr time (e.g. 8 for 8am, 13 for 1pm)
    let startMinute: Int   // minutes (e.g. 25 for 8:25)
    let endHour: Int
    let endMinute: Int
}

// the actual period times for a standard day (Mon–Thu)
// these are in order from first to last
let standardPeriods: [PeriodTime] = [
    PeriodTime(label: "Pastoral Care", startHour: 8,  startMinute: 25, endHour: 8,  endMinute: 45),
    PeriodTime(label: "Period 1",      startHour: 8,  startMinute: 45, endHour: 9,  endMinute: 40),
    PeriodTime(label: "Period 2",      startHour: 9,  startMinute: 40, endHour: 10, endMinute: 35),
    // recess is 10:35 – 10:55 (we just skip it, no slot needed)
    PeriodTime(label: "Period 3",      startHour: 10, startMinute: 55, endHour: 11, endMinute: 50),
    PeriodTime(label: "Period 4",      startHour: 11, startMinute: 50, endHour: 12, endMinute: 45),
    // lunch is 12:45 – 13:20
    PeriodTime(label: "Period 5",      startHour: 13, startMinute: 20, endHour: 14, endMinute: 15),
    PeriodTime(label: "Period 6",      startHour: 14, startMinute: 15, endHour: 15, endMinute: 10),
]

// friday has slightly different times (extended pastoral care)
let fridayPeriods: [PeriodTime] = [
    PeriodTime(label: "Pastoral Care Extended", startHour: 8,  startMinute: 25, endHour: 9,  endMinute: 15),
    PeriodTime(label: "Period 1",               startHour: 9,  startMinute: 15, endHour: 10, endMinute: 5),
    PeriodTime(label: "Period 2",               startHour: 10, startMinute: 5,  endHour: 10, endMinute: 55),
    PeriodTime(label: "Period 3",               startHour: 11, startMinute: 15, endHour: 12, endMinute: 5),
    PeriodTime(label: "Period 4",               startHour: 12, startMinute: 5,  endHour: 12, endMinute: 55),
    PeriodTime(label: "Period 5",               startHour: 13, startMinute: 30, endHour: 14, endMinute: 20),
    PeriodTime(label: "Period 6",               startHour: 14, startMinute: 20, endHour: 15, endMinute: 10),
]

// helper function: returns the right periods for a given day
// "func" = a function, a reusable block of code
// "-> [PeriodTime]" = this function returns a list of PeriodTime
func periodsForDay(_ day: String) -> [PeriodTime] {
    if day == "Friday" {
        return fridayPeriods    // use friday times
    } else {
        return standardPeriods  // use standard times for Mon–Thu
    }
}
```

### Subject — Subject.swift

This is the blueprint for a subject. Uses SwiftData so it saves automatically.

```swift
import SwiftData    // Apple's framework for saving data to disk
import SwiftUI      // needed for the Color type

// @Model tells SwiftData "save this to the device"
// without @Model, the data would disappear when you close the app
@Model
class Subject {
    var name: String           // e.g. "Computer Science General"
    var teacher: String        // e.g. "Mr Roan Venter"
    var room: String           // e.g. "11F"
    var colourHex: String      // colour stored as hex string e.g. "#FF5733"

    // "init" is the initialiser — it runs when you create a new Subject
    // think of it as filling in the blank template
    init(name: String, teacher: String, room: String, colourHex: String) {
        self.name = name             // "self.name" = the struct's field
        self.teacher = teacher       // "teacher" on the right = the value passed in
        self.room = room
        self.colourHex = colourHex
    }
}
```

### Timetable Slot — TimetableSlot.swift

This connects a subject to a specific day and period.

```swift
import SwiftData

@Model
class TimetableSlot {
    var day: String            // "Monday", "Tuesday", etc.
    var periodIndex: Int       // which period (0 = pastoral care, 1 = period 1, etc.)
    var subject: Subject?      // the subject assigned to this slot
                               // the ? means it can be empty (no class that period)

    init(day: String, periodIndex: Int, subject: Subject? = nil) {
        self.day = day
        self.periodIndex = periodIndex
        self.subject = subject
        // "= nil" means if you don't pass a subject, it defaults to empty
    }
}
```

### Assignment — Assignment.swift

This is the blueprint for assignments and tests.

```swift
import SwiftData
import Foundation   // needed for the Date type

@Model
class Assignment {
    var title: String              // e.g. "Systems Analysis Report"
    var details: String            // longer description of what's involved
    var dueDate: Date              // when it's due
    var isCompleted: Bool          // has it been submitted/done?
    var notes: String              // student's own notes for this assignment
    var subject: Subject?          // which class it's for (optional)

    init(title: String, details: String = "", dueDate: Date, subject: Subject? = nil) {
        self.title = title
        self.details = details
        self.dueDate = dueDate
        self.isCompleted = false   // starts as not completed
        self.notes = ""            // starts with no notes
        self.subject = subject
    }
}
```

### How the Models Connect

```
Subject (e.g. "Computer Science General")
   │
   ├── linked to → TimetableSlot (Monday, Period 1)
   ├── linked to → TimetableSlot (Wednesday, Period 3)
   ├── linked to → TimetableSlot (Friday, Period 1)
   │
   ├── linked to → Assignment ("Systems Analysis Report", due May 15)
   └── linked to → Assignment ("Unit Test: Networking", due June 2)
```

A subject can appear in multiple timetable slots (you have the same class multiple times a week) and can have multiple assignments tagged to it.

---

## Part 5: The Main App Entry Point

### ContentView.swift — The Tab Bar

This is the first screen users see. It has 3 tabs at the bottom.

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {

        // TabView creates the tab bar at the bottom of the screen
        // on macOS this shows as a sidebar instead — SwiftUI handles it
        TabView {

            // --- TAB 1: TIMETABLE ---
            TimetableView()                 // the timetable screen (we'll build this)
                .tabItem {                  // what shows in the tab bar
                    Image(systemName: "calendar")   // calendar icon
                    Text("Timetable")               // label
                }

            // --- TAB 2: ASSIGNMENTS ---
            AssignmentListView()            // the assignments screen
                .tabItem {
                    Image(systemName: "checklist")  // checklist icon
                    Text("Assignments")
                }

            // --- TAB 3: SETTINGS ---
            SettingsView()                  // settings screen
                .tabItem {
                    Image(systemName: "gear")       // gear icon
                    Text("Settings")
                }
        }
    }
}
```

---

## Part 6: Building the Timetable View

### TimetableView.swift

This shows today's timetable and lets you switch between days.

```swift
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
```

### PeriodRow.swift — How One Period Looks

```swift
import SwiftUI

struct PeriodRow: View {
    let period: PeriodTime       // the time info (label, start, end)
    let subject: Subject?        // the subject (if assigned), ? means it might be nil

    var body: some View {
        HStack(spacing: 12) {

            // --- TIME COLUMN (left side) ---
            VStack {
                // format the time as "8:45" etc.
                // %02d means pad with a zero if needed (8:05 not 8:5)
                Text(String(format: "%d:%02d", period.startHour, period.startMinute))
                    .font(.caption)
                    .bold()
                Text(String(format: "%d:%02d", period.endHour, period.endMinute))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .frame(width: 50)    // fixed width so all times line up

            // --- SUBJECT INFO (right side) ---
            // if there's a subject assigned, show it
            if let subject = subject {
                // "if let" safely unwraps the optional
                // it only runs this code if subject is NOT nil

                VStack(alignment: .leading, spacing: 4) {
                    Text(subject.name)
                        .font(.headline)
                    HStack {
                        Text(subject.teacher)
                        Text("·")
                        Text("Room \(subject.room)")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }

            } else {
                // no subject assigned — show the period label
                Text(period.label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()  // push everything to the left

        }
        .padding(.vertical, 4)
    }
}
```

---

## Part 7: Building the Assignment Views

### AssignmentListView.swift

```swift
import SwiftUI
import SwiftData

struct AssignmentListView: View {

    // pulls all assignments from saved data, sorted by due date
    // "sort:" tells SwiftData how to order them
    @Query(sort: \Assignment.dueDate) var assignments: [Assignment]

    // controls whether the "add assignment" sheet is showing
    @State var showingAddSheet = false

    var body: some View {
        NavigationStack {
            List {

                // loop through each assignment
                ForEach(assignments) { assignment in

                    // tapping a row goes to the detail view
                    NavigationLink(destination: AssignmentDetailView(assignment: assignment)) {

                        HStack {
                            // --- COMPLETION CIRCLE ---
                            // shows a filled or empty circle
                            Image(systemName: assignment.isCompleted
                                  ? "checkmark.circle.fill"   // done
                                  : "circle")                 // not done
                                .foregroundColor(assignment.isCompleted ? .green : .gray)

                            // --- ASSIGNMENT INFO ---
                            VStack(alignment: .leading) {

                                Text(assignment.title)
                                    .font(.headline)
                                    // strikethrough if completed
                                    .strikethrough(assignment.isCompleted)

                                HStack {
                                    // show which subject it's tagged to
                                    if let subject = assignment.subject {
                                        Text(subject.name)
                                            .font(.caption)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color(.systemGray5))
                                            .cornerRadius(4)
                                    }

                                    // show the due date
                                    Text("Due \(assignment.dueDate.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundColor(
                                            // red if overdue and not completed
                                            assignment.dueDate < Date() && !assignment.isCompleted
                                                ? .red
                                                : .gray
                                        )
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Assignments")
            .toolbar {
                // the + button in the top right corner
                Button(action: {
                    showingAddSheet = true   // opens the add assignment form
                }) {
                    Image(systemName: "plus")
                }
            }
            // .sheet shows a pop-up form over the current screen
            .sheet(isPresented: $showingAddSheet) {
                AddAssignmentView()
            }
        }
    }
}
```

### AddAssignmentView.swift — The Form to Add an Assignment

```swift
import SwiftUI
import SwiftData

struct AddAssignmentView: View {

    // this gives us access to the SwiftData database to save new items
    @Environment(\.modelContext) var modelContext

    // this lets us close the sheet when we're done
    @Environment(\.dismiss) var dismiss

    // pull in all subjects so the user can pick which class it's for
    @Query var subjects: [Subject]

    // form fields — @State because they change as the user types
    @State var title = ""
    @State var details = ""
    @State var dueDate = Date()          // defaults to right now
    @State var selectedSubject: Subject? = nil  // no subject selected initially

    var body: some View {
        NavigationStack {

            // Form creates a settings-style grouped list
            Form {

                // --- BASIC INFO SECTION ---
                Section("Assignment Info") {

                    // TextField = a text input box
                    // "Title" is the placeholder text shown when empty
                    // $title binds it to the title variable (they stay in sync)
                    TextField("Title", text: $title)

                    // TextEditor = a multi-line text input (bigger text box)
                    TextEditor(text: $details)
                        .frame(height: 100)  // give it a fixed height

                    // DatePicker lets the user pick a date
                    // displayedComponents: .date means just the date, no time
                    DatePicker("Due Date", selection: $dueDate,
                              displayedComponents: .date)
                }

                // --- SUBJECT PICKER SECTION ---
                Section("Class") {

                    // Picker shows a dropdown/selection menu
                    Picker("Subject", selection: $selectedSubject) {

                        // "None" option
                        Text("None").tag(nil as Subject?)

                        // list all subjects as options
                        ForEach(subjects) { subject in
                            Text(subject.name).tag(subject as Subject?)
                            // .tag() links the display text to the actual value
                        }
                    }
                }
            }
            .navigationTitle("New Assignment")
            .toolbar {

                // Cancel button (top left)
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()   // close the sheet without saving
                    }
                }

                // Save button (top right)
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {

                        // create a new Assignment using the form values
                        let newAssignment = Assignment(
                            title: title,
                            details: details,
                            dueDate: dueDate,
                            subject: selectedSubject
                        )

                        // insert it into the database — SwiftData saves it
                        modelContext.insert(newAssignment)

                        dismiss()   // close the sheet
                    }
                    .disabled(title.isEmpty)  // grey out Save if title is empty
                }
            }
        }
    }
}
```

### AssignmentDetailView.swift — View and Edit One Assignment

```swift
import SwiftUI
import SwiftData

struct AssignmentDetailView: View {

    // @Bindable means we can edit this assignment's properties directly
    // changes are saved automatically by SwiftData
    @Bindable var assignment: Assignment

    var body: some View {
        Form {

            // --- STATUS ---
            Section {
                // Toggle = an on/off switch
                Toggle("Completed", isOn: $assignment.isCompleted)
                // $assignment.isCompleted binds directly — changes save automatically
            }

            // --- INFO ---
            Section("Details") {
                TextField("Title", text: $assignment.title)

                if let subject = assignment.subject {
                    HStack {
                        Text("Class")
                        Spacer()
                        Text(subject.name)
                            .foregroundColor(.gray)
                    }
                }

                DatePicker("Due Date", selection: $assignment.dueDate,
                          displayedComponents: .date)
            }

            // --- DESCRIPTION ---
            Section("What's Involved") {
                TextEditor(text: $assignment.details)
                    .frame(minHeight: 100)
            }

            // --- NOTES ---
            Section("My Notes") {
                TextEditor(text: $assignment.notes)
                    .frame(minHeight: 150)
            }
        }
        .navigationTitle(assignment.title)
    }
}
```

---

## Part 8: Settings and Subject Editor

### SettingsView.swift

```swift
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                // each NavigationLink goes to a different settings page
                NavigationLink("Edit Subjects", destination: SubjectEditorView())
                NavigationLink("Edit Timetable", destination: TimetableEditorView())
            }
            .navigationTitle("Settings")
        }
    }
}
```

### SubjectEditorView.swift — Add and Edit Subjects

```swift
import SwiftUI
import SwiftData

struct SubjectEditorView: View {

    @Query var subjects: [Subject]
    @Environment(\.modelContext) var modelContext

    // form fields for adding a new subject
    @State var newName = ""
    @State var newTeacher = ""
    @State var newRoom = ""
    @State var newColour = Color.blue    // default colour

    var body: some View {
        List {

            // --- ADD NEW SUBJECT SECTION ---
            Section("Add Subject") {
                TextField("Subject Name", text: $newName)
                TextField("Teacher", text: $newTeacher)
                TextField("Room", text: $newRoom)

                // ColorPicker lets the user pick any colour
                ColorPicker("Colour", selection: $newColour)

                Button("Add Subject") {
                    // create and save the new subject
                    let subject = Subject(
                        name: newName,
                        teacher: newTeacher,
                        room: newRoom,
                        colourHex: newColour.toHex()  // convert colour to hex string
                    )
                    modelContext.insert(subject)

                    // clear the form fields
                    newName = ""
                    newTeacher = ""
                    newRoom = ""
                }
                .disabled(newName.isEmpty)  // can't add without a name
            }

            // --- EXISTING SUBJECTS ---
            Section("Your Subjects") {
                ForEach(subjects) { subject in
                    HStack {
                        // coloured circle
                        Circle()
                            .fill(Color(hex: subject.colourHex))
                            .frame(width: 12, height: 12)

                        VStack(alignment: .leading) {
                            Text(subject.name)
                                .font(.headline)
                            Text("\(subject.teacher) · Room \(subject.room)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                // .onDelete lets the user swipe to delete
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(subjects[index])
                    }
                }
            }
        }
        .navigationTitle("Subjects")
    }
}
```

---

## Part 9: How SwiftData Saves Everything

### The Key Concept

Without SwiftData, everything would disappear when you close the app. SwiftData saves your data to the device automatically.

The three things that make it work:

1. **@Model on your classes** — tells SwiftData "this is something to save"
```swift
@Model
class Subject { ... }    // SwiftData saves every Subject you create
```

2. **@Query in your views** — tells SwiftData "give me the saved data"
```swift
@Query var subjects: [Subject]   // automatically loads all saved subjects
```

3. **modelContext.insert()** — tells SwiftData "save this new item"
```swift
@Environment(\.modelContext) var modelContext   // access to the database
modelContext.insert(newSubject)                  // saves it
```

### Deleting Data

```swift
modelContext.delete(someSubject)   // removes it from the database
```

### Editing Data

Just change the properties directly — SwiftData auto-saves:

```swift
assignment.isCompleted = true    // this change is saved automatically
assignment.title = "New Title"   // this too
```

---

## Part 10: Useful Keyboard Shortcuts

| Shortcut | What it does |
|----------|-------------|
| ⌘R | Run your app in the simulator |
| ⌘. | Stop the simulator |
| ⌥⌘P | Show/refresh the preview canvas |
| ⌥⌘C | Commit your changes |
| ⌘B | Build (check for errors without running) |
| ⌘⇧O | Quick open any file by name |
| ⌘⇧K | Clean build (fixes weird errors sometimes) |

---

## Part 11: When You Get Stuck

- **Red errors:** Read the error — usually a missing bracket, typo, or wrong variable name
- **"Cannot find X in scope":** You're using a variable or type name that doesn't exist — check spelling
- **Preview not loading:** Press ⌥⌘P or click "Resume" in the canvas
- **Simulator is slow:** First launch is always slow, it speeds up after
- **Data not showing:** Make sure you used `@Query` and `modelContext.insert()` correctly
- **Xcode being weird:** Try ⌘⇧K (clean build) then ⌘R again
- **Ask me:** Screenshot the error or paste the message — just make sure you understand the fix so you can explain it to your teacher

---

## Part 12: Building Order

See the separate **SchoolPlanner_Checklist.md** file for a full build checklist with phases, dependencies, and checkboxes. The short version:

1. Project setup → 2. Data models → 3. Subjects → 4. Timetable editor → 5. Onboarding → 6. Timetable view → 7. Assignments → 8. Dashboard → 9. Colour coding → 10. Notifications → 11. Sharing → 12. Live Activity → 13. Polish

---

## Part 13: Onboarding (First-Time Setup Flow)

When someone opens the app for the first time, they need to set up their subjects and timetable. This is a step-by-step walkthrough that only shows once.

### How to Track "Has the User Done Setup?"

```swift
// @AppStorage saves a simple value that persists forever
// it's like SwiftData but for tiny settings (true/false, numbers, text)
// "hasCompletedOnboarding" is the key — like a label for this setting
// = false means it starts as false (not done yet)

@AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
```

### SchoolMateApp.swift — Show Onboarding or Main App

```swift
import SwiftUI
import SwiftData

@main    // this tells Swift "this is where the app starts"
struct SchoolMateApp: App {

    // check if onboarding has been completed
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            // if onboarding is done, show the main app
            // if not, show the onboarding flow
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: [Subject.self, TimetableSlot.self, Assignment.self])
        // ^ this line tells SwiftData which models to save
    }
}
```

### OnboardingView.swift — The Step-by-Step Flow

```swift
import SwiftUI

struct OnboardingView: View {

    // tracks which step the user is on (0, 1, 2, 3)
    @State var currentStep = 0

    // when we set this to true, the app switches to the main view
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    var body: some View {
        // TabView with .page style creates a swipeable page view
        // like swiping through an intro tutorial
        TabView(selection: $currentStep) {

            // --- STEP 0: WELCOME ---
            VStack(spacing: 20) {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Text("Welcome to SchoolMate")
                    .font(.largeTitle)
                    .bold()
                Text("Let's set up your timetable")
                    .font(.title3)
                    .foregroundColor(.gray)
                Button("Get Started") {
                    currentStep = 1    // go to next step
                }
                .buttonStyle(.borderedProminent)  // makes it a big blue button
            }
            .tag(0)    // identifies this as step 0

            // --- STEP 1: ADD SUBJECTS ---
            VStack {
                Text("Add Your Subjects")
                    .font(.title2)
                    .bold()
                    .padding()
                SubjectEditorView()   // reuse the subject editor we already built
                Button("Next: Set Up Timetable") {
                    currentStep = 2
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .tag(1)

            // --- STEP 2: ASSIGN TIMETABLE ---
            VStack {
                Text("Build Your Timetable")
                    .font(.title2)
                    .bold()
                    .padding()
                TimetableEditorView()  // reuse the timetable editor
                Button("Next: Finish") {
                    currentStep = 3
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .tag(2)

            // --- STEP 3: DONE ---
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                Text("You're All Set!")
                    .font(.largeTitle)
                    .bold()
                Text("Your timetable is ready to go")
                    .font(.title3)
                    .foregroundColor(.gray)
                Button("Open SchoolMate") {
                    hasCompletedOnboarding = true  // marks setup as done
                    // the app will now show ContentView instead
                }
                .buttonStyle(.borderedProminent)
            }
            .tag(3)
        }
        .tabViewStyle(.page)           // swipeable pages instead of tab bar
        .indexViewStyle(.page(backgroundDisplayMode: .always))  // shows the dots
    }
}
```

---

## Part 14: Today Dashboard

This is the home screen — a quick overview of everything relevant for today.

### TodayDashboardView.swift

```swift
import SwiftUI
import SwiftData

struct TodayDashboardView: View {

    @Query var allSlots: [TimetableSlot]
    @Query(sort: \Assignment.dueDate) var assignments: [Assignment]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // --- CURRENT PERIOD CARD ---
                    currentPeriodCard

                    // --- NEXT PERIOD CARD ---
                    nextPeriodCard

                    // --- UPCOMING ASSIGNMENTS ---
                    upcomingAssignmentsSection

                }
                .padding()
            }
            .navigationTitle("Today")
        }
    }

    // --- CURRENT PERIOD ---
    // this is a "computed property" — it builds a view on the fly
    var currentPeriodCard: some View {

        // get the current period based on the time right now
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let todayName = dayName(from: now)
        let periods = periodsForDay(todayName)

        // find which period we're currently in
        // by checking if the current time falls between start and end
        let currentIndex = periods.firstIndex(where: { period in
            let startMinutes = period.startHour * 60 + period.startMinute
            let endMinutes = period.endHour * 60 + period.endMinute
            let nowMinutes = hour * 60 + minute
            return nowMinutes >= startMinutes && nowMinutes < endMinutes
        })

        return VStack(spacing: 8) {
            if let index = currentIndex {
                let period = periods[index]
                let slot = allSlots.first(where: {
                    $0.day == todayName && $0.periodIndex == index
                })

                Text("RIGHT NOW")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .bold()

                if let subject = slot?.subject {
                    Text(subject.name)
                        .font(.title2)
                        .bold()
                    Text("\(subject.teacher) · Room \(subject.room)")
                        .foregroundColor(.gray)

                    // time remaining
                    let endMinutes = period.endHour * 60 + period.endMinute
                    let nowMinutes = hour * 60 + minute
                    let remaining = endMinutes - nowMinutes
                    Text("\(remaining) min remaining")
                        .font(.headline)
                        .foregroundColor(.orange)
                } else {
                    Text(period.label)
                        .font(.title2)
                }
            } else {
                // not during school hours
                Text("No Class Right Now")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }

    // --- NEXT PERIOD ---
    var nextPeriodCard: some View {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let todayName = dayName(from: now)
        let periods = periodsForDay(todayName)
        let nowMinutes = hour * 60 + minute

        // find the next period that hasn't started yet
        let nextIndex = periods.firstIndex(where: { period in
            let startMinutes = period.startHour * 60 + period.startMinute
            return nowMinutes < startMinutes
        })

        return VStack(spacing: 8) {
            Text("UP NEXT")
                .font(.caption)
                .foregroundColor(.green)
                .bold()

            if let index = nextIndex {
                let period = periods[index]
                let slot = allSlots.first(where: {
                    $0.day == todayName && $0.periodIndex == index
                })

                if let subject = slot?.subject {
                    Text(subject.name)
                        .font(.title3)
                        .bold()
                    Text("\(subject.teacher) · Room \(subject.room)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Starts at \(String(format: "%d:%02d", period.startHour, period.startMinute))")
                        .font(.caption)
                } else {
                    Text(period.label)
                        .font(.title3)
                }
            } else {
                Text("No more classes today")
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }

    // --- UPCOMING ASSIGNMENTS ---
    var upcomingAssignmentsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("UPCOMING ASSIGNMENTS")
                .font(.caption)
                .foregroundColor(.gray)
                .bold()

            // filter to only show incomplete assignments due in the next 7 days
            let upcoming = assignments.filter { assignment in
                !assignment.isCompleted &&
                assignment.dueDate > Date() &&
                assignment.dueDate < Calendar.current.date(byAdding: .day, value: 7, to: Date())!
            }

            if upcoming.isEmpty {
                Text("Nothing due this week!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(upcoming) { assignment in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(assignment.title)
                                .font(.headline)
                            if let subject = assignment.subject {
                                Text(subject.name)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        // countdown text
                        Text(countdownText(for: assignment.dueDate))
                            .font(.caption)
                            .bold()
                            .foregroundColor(.orange)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
        }
    }

    // --- HELPER: get day name from a date ---
    func dayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let name = formatter.string(from: date)
        if ["Saturday", "Sunday"].contains(name) { return "Monday" }
        return name
    }

    // --- HELPER: "Due in 3 days", "Due tomorrow", etc. ---
    func countdownText(for dueDate: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
        if days == 0 { return "Due today" }
        if days == 1 { return "Due tomorrow" }
        return "Due in \(days) days"
    }
}
```

Don't forget to update your ContentView.swift to add the dashboard as the first tab:

```swift
// in ContentView.swift, add this as the FIRST tab:
TodayDashboardView()
    .tabItem {
        Image(systemName: "house.fill")   // home icon
        Text("Today")
    }
```

---

## Part 15: Assignment Countdown

The countdown is built into both the dashboard (Part 14) and the assignment list. Here's how the logic works:

```swift
// this function takes a due date and returns a human-readable countdown
func countdownText(for dueDate: Date) -> String {

    // Calendar.current gives us the user's calendar
    // .dateComponents([.day], ...) calculates the difference in days
    let days = Calendar.current.dateComponents([.day],
                from: Date(),       // from right now
                to: dueDate         // to the due date
    ).day ?? 0                       // ?? 0 means "if nil, use 0"

    // return different text based on how many days
    if days < 0 { return "Overdue" }
    if days == 0 { return "Due today" }
    if days == 1 { return "Due tomorrow" }
    return "Due in \(days) days"
}
```

---

## Part 16: Push Notifications

These remind students about upcoming assignments. Uses Apple's UserNotifications framework.

### Requesting Permission

```swift
import UserNotifications

// call this once — e.g. during onboarding or first launch
func requestNotificationPermission() {

    // UNUserNotificationCenter manages all notifications
    UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]   // what types of notifications
    ) { granted, error in
        // "granted" is true if the user said yes
        if granted {
            print("Notifications allowed")
        }
    }
}
```

### Scheduling a Notification for an Assignment

```swift
func scheduleAssignmentReminder(for assignment: Assignment) {

    // don't schedule if it's already completed
    guard !assignment.isCompleted else { return }
    // "guard" is like an "if not" — if the condition is false, it runs the else

    let center = UNUserNotificationCenter.current()

    // --- NOTIFICATION: Day before it's due ---
    let content = UNMutableNotificationContent()
    content.title = "Assignment Due Tomorrow"           // notification title
    content.body = "\(assignment.title) is due tomorrow" // notification body
    content.sound = .default                             // default sound

    // calculate the day before the due date
    let dayBefore = Calendar.current.date(
        byAdding: .day, value: -1, to: assignment.dueDate
    )!

    // create a trigger that fires at 8:00 AM the day before
    var components = Calendar.current.dateComponents(
        [.year, .month, .day], from: dayBefore
    )
    components.hour = 8      // 8:00 AM
    components.minute = 0

    let trigger = UNCalendarNotificationTrigger(
        dateMatching: components,
        repeats: false       // only fire once
    )

    // unique identifier so we can cancel it later
    let request = UNNotificationRequest(
        identifier: "assignment-\(assignment.title)-dayBefore",
        content: content,
        trigger: trigger
    )

    center.add(request)      // schedule it
}

// --- CANCEL NOTIFICATIONS (when assignment is completed) ---
func cancelAssignmentReminder(for assignment: Assignment) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(
        withIdentifiers: ["assignment-\(assignment.title)-dayBefore"]
    )
}
```

---

## Part 17: Assignment Sharing (AirDrop / Share Sheet)

This lets students share an assignment (with all their notes) to another student.

### Making Assignment Data Shareable

```swift
// "Codable" means Swift can convert this to/from JSON text
// we create a separate struct for sharing (not the @Model one)

struct ShareableAssignment: Codable {
    let title: String
    let details: String
    let dueDate: Date
    let notes: String
    let subjectName: String?   // just the name, not the full Subject

    // create from a real Assignment
    init(from assignment: Assignment) {
        self.title = assignment.title
        self.details = assignment.details
        self.dueDate = assignment.dueDate
        self.notes = assignment.notes
        self.subjectName = assignment.subject?.name
    }
}
```

### Share Button on the Detail View

```swift
// add this button inside AssignmentDetailView

Button(action: {
    // create a formatted text version
    let text = """
    📚 \(assignment.title)
    📅 Due: \(assignment.dueDate.formatted(date: .long, time: .omitted))
    📖 \(assignment.subject?.name ?? "No subject")

    Details:
    \(assignment.details)

    Notes:
    \(assignment.notes)
    """
    // """ is a multi-line string in Swift

    // open the share sheet
    #if os(iOS)
    let activityVC = UIActivityViewController(
        activityItems: [text],
        applicationActivities: nil
    )
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
        window.rootViewController?.present(activityVC, animated: true)
    }
    #elseif os(macOS)
    // macOS — copy to clipboard
    NSPasteboard.general.setString(text, forType: .string)
    #endif
}) {
    Label("Share Assignment", systemImage: "square.and.arrow.up")
}
```

---

## Part 18: Timetable Export as Image

Renders your timetable as a shareable image using ImageRenderer.

```swift
import SwiftUI

func exportTimetableAsImage(slots: [TimetableSlot]) {

    // create a view that looks like the timetable
    let timetableImage = TimetableExportView(slots: slots)

    // ImageRenderer converts a SwiftUI view into an image
    let renderer = ImageRenderer(content: timetableImage)
    renderer.scale = 2.0    // 2x resolution for crisp image

    #if os(iOS)
    if let image = renderer.uiImage {
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    #elseif os(macOS)
    if let image = renderer.nsImage {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.writeObjects([image])
    }
    #endif
}
```

---

## Part 19: Live Activity (Lock Screen Notification)

The persistent lock screen display showing your current class. This is the most advanced feature — build everything else first.

### Step 1: Add a Widget Extension

1. In Xcode: **File → New → Target**
2. Choose **Widget Extension**
3. Name it "SchoolMateWidget"
4. Check **"Include Live Activity"**
5. Click Finish

### Step 2: Define the Live Activity Data

Put this in a shared file both the app and widget can access:

```swift
import ActivityKit
import Foundation

// ActivityAttributes = the blueprint for the lock screen notification
struct SchoolActivityAttributes: ActivityAttributes {

    // ContentState = the data that CHANGES over time
    public struct ContentState: Codable, Hashable {
        var currentSubject: String      // "Computer Science General"
        var currentRoom: String         // "11F"
        var currentTeacher: String      // "Mr Roan Venter"
        var minutesRemaining: Int       // 23
        var periodLabel: String         // "Period 3"
        var nextSubject: String?        // "English General" (nil if last period)
        var nextRoom: String?           // "10B"
        var isBreak: Bool              // true if recess or lunch
        var breakLabel: String?        // "Recess" or "Lunch"
    }

    // static data that doesn't change during the activity
    var schoolDayStart: Date
    var totalPeriods: Int
}
```

### Step 3: The Lock Screen Layout (in the Widget Extension)

```swift
import WidgetKit
import SwiftUI
import ActivityKit

struct SchoolActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SchoolActivityAttributes.self) { context in

            // --- LOCK SCREEN LAYOUT ---
            VStack(spacing: 8) {

                if context.state.isBreak {
                    // during recess or lunch
                    HStack {
                        Image(systemName: "fork.knife")
                        Text(context.state.breakLabel ?? "Break")
                            .font(.headline)
                        Spacer()
                        Text("\(context.state.minutesRemaining) min left")
                            .font(.subheadline)
                    }
                } else {
                    // during a class
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(context.state.currentSubject)
                                .font(.headline)
                                .bold()
                            Text("\(context.state.currentTeacher) · Room \(context.state.currentRoom)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(context.state.minutesRemaining)")
                                .font(.title)
                                .bold()
                            Text("min left")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }

                    // progress bar
                    ProgressView(value: Double(context.state.minutesRemaining),
                                total: 55.0)
                        .tint(.blue)
                }

                // next class preview
                if let next = context.state.nextSubject {
                    HStack {
                        Text("Next:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(next)
                            .font(.caption)
                            .bold()
                        if let room = context.state.nextRoom {
                            Text("· Room \(room)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding()

        } dynamicIsland: { context in
            // Dynamic Island — needed even for iPad
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.currentSubject).font(.caption)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.minutesRemaining) min").font(.caption)
                }
            } compactLeading: {
                Image(systemName: "book.fill")
            } compactTrailing: {
                Text("\(context.state.minutesRemaining)m")
            } minimal: {
                Text("\(context.state.minutesRemaining)")
            }
        }
    }
}
```

### Step 4: Starting and Updating (in the main app)

```swift
import ActivityKit

// --- START at beginning of school day ---
func startSchoolDayActivity(firstSubject: String, teacher: String, room: String,
                            minutesRemaining: Int, nextSubject: String?, nextRoom: String?) {

    guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

    let attributes = SchoolActivityAttributes(
        schoolDayStart: Date(),
        totalPeriods: 7
    )

    let initialState = SchoolActivityAttributes.ContentState(
        currentSubject: firstSubject,
        currentRoom: room,
        currentTeacher: teacher,
        minutesRemaining: minutesRemaining,
        periodLabel: "Pastoral Care",
        nextSubject: nextSubject,
        nextRoom: nextRoom,
        isBreak: false,
        breakLabel: nil
    )

    do {
        let activity = try Activity<SchoolActivityAttributes>.request(
            attributes: attributes,
            content: .init(state: initialState, staleDate: nil)
        )
        print("Live Activity started: \(activity.id)")
    } catch {
        print("Error: \(error)")
    }
}

// --- UPDATE when period changes ---
func updateSchoolActivity(newState: SchoolActivityAttributes.ContentState) {
    for activity in Activity<SchoolActivityAttributes>.activities {
        Task {
            await activity.update(ActivityContent(state: newState, staleDate: nil))
        }
    }
}

// --- END when school finishes ---
func endSchoolDayActivity() {
    for activity in Activity<SchoolActivityAttributes>.activities {
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
```

### Important Notes

- Requires **iPadOS 16.1+** minimum
- Auto-ends after **8 hours** if not manually ended
- User must grant permission in Settings
- The main app uses a Timer (every 60 seconds) to check the time and update the activity when periods change
- Build and test everything else first — this is the final feature

---

## Part 20: Colour ↔ Hex Helper

Add this as `ColorExtension.swift` — needed for saving subject colours:

```swift
import SwiftUI

// "extension" adds new abilities to an existing type

extension Color {

    // create a Color from a hex string like "#FF5733"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double((rgbValue & 0x0000FF)) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    // convert a Color to a hex string like "#FF5733"
    func toHex() -> String {
        let components = NSColor(self).cgColor.components ?? [0, 0, 0]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
```

This is needed because SwiftData can save Strings but can't directly save Color objects — so we convert to hex text for storage and back to Color for display.

---

## Part 21: Feature Toggle System

Every toggleable feature checks a setting before it appears. This uses @AppStorage — simple key-value storage that persists forever.

### FeatureSettings.swift

```swift
import SwiftUI

// this struct holds all feature toggles in one place
// any view can read these to check if a feature is enabled

struct FeatureSettings {
    // @AppStorage reads/writes to UserDefaults (permanent simple storage)
    // the string in quotes is the storage key
    // the value after = is the default

    @AppStorage("feature_liveActivity") static var liveActivityEnabled = true
    @AppStorage("feature_notifications") static var notificationsEnabled = true
    @AppStorage("feature_studyStreak") static var studyStreakEnabled = true
    @AppStorage("feature_focusTimer") static var focusTimerEnabled = true
    @AppStorage("feature_quickCapture") static var quickCaptureEnabled = true
    @AppStorage("feature_workloadHeatmap") static var workloadHeatmapEnabled = true
    @AppStorage("feature_weeklyReport") static var weeklyReportEnabled = true
    @AppStorage("feature_examCountdown") static var examCountdownEnabled = true
    @AppStorage("feature_subjectTheme") static var subjectThemeEnabled = false  // OFF by default
    @AppStorage("feature_whatToStudy") static var whatToStudyEnabled = true
}
```

### FeatureToggleView.swift (in Settings)

```swift
import SwiftUI

struct FeatureToggleView: View {

    // each @AppStorage here syncs with the same keys as FeatureSettings
    // changes here instantly affect the whole app
    @AppStorage("feature_liveActivity") var liveActivity = true
    @AppStorage("feature_notifications") var notifications = true
    @AppStorage("feature_studyStreak") var studyStreak = true
    @AppStorage("feature_focusTimer") var focusTimer = true
    @AppStorage("feature_quickCapture") var quickCapture = true
    @AppStorage("feature_workloadHeatmap") var workloadHeatmap = true
    @AppStorage("feature_weeklyReport") var weeklyReport = true
    @AppStorage("feature_examCountdown") var examCountdown = true
    @AppStorage("feature_subjectTheme") var subjectTheme = false
    @AppStorage("feature_whatToStudy") var whatToStudy = true

    var body: some View {
        Form {
            Section("Core Features") {
                Toggle("Live Activity (Lock Screen)", isOn: $liveActivity)
                Toggle("Push Notifications", isOn: $notifications)
            }

            Section("Productivity") {
                Toggle("Focus Timer", isOn: $focusTimer)
                Toggle("Quick Capture", isOn: $quickCapture)
                Toggle("Study Streak", isOn: $studyStreak)
            }

            Section("Insights") {
                Toggle("Workload Heatmap", isOn: $workloadHeatmap)
                Toggle("Weekly Report", isOn: $weeklyReport)
                Toggle("Exam Countdown", isOn: $examCountdown)
                Toggle("\"What Should I Study?\"", isOn: $whatToStudy)
            }

            Section("Appearance") {
                Toggle("Subject Colour Theme", isOn: $subjectTheme)
                // helper text below the toggle
                Text("Changes the app's accent colour to match your current class")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Features")
    }
}
```

### How to Check a Toggle in Any View

```swift
// in any view that should be conditional:
@AppStorage("feature_focusTimer") var focusTimerEnabled = true

var body: some View {
    VStack {
        // only show the focus timer button if the feature is enabled
        if focusTimerEnabled {
            NavigationLink("Focus Timer", destination: FocusTimerView())
        }
    }
}
```

---

## Part 22: Focus Timer (Pomodoro)

A structured study timer: 25 min study → 5 min break → repeat. After 4 sessions, take a longer 15 min break.

### FocusTimerView.swift

```swift
import SwiftUI
import SwiftData

struct FocusTimerView: View {

    @Environment(\.modelContext) var modelContext
    @Query var subjects: [Subject]

    // timer state
    @State var timeRemaining = 25 * 60      // 25 minutes in seconds
    @State var isRunning = false              // is the timer ticking?
    @State var isStudyPhase = true            // true = studying, false = break
    @State var sessionsCompleted = 0          // how many study sessions done
    @State var selectedSubject: Subject? = nil

    // settings
    let studyDuration = 25 * 60              // 25 min in seconds
    let shortBreak = 5 * 60                  // 5 min
    let longBreak = 15 * 60                  // 15 min

    // Timer object — fires every 1 second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // .publish(every: 1) = fires every 1 second
    // .main = runs on the main thread (needed for UI updates)
    // .autoconnect() = starts automatically

    var body: some View {
        VStack(spacing: 30) {

            // --- STATUS LABEL ---
            Text(isStudyPhase ? "Study Time" : "Break Time")
                .font(.title2)
                .foregroundColor(isStudyPhase ? .blue : .green)

            // --- TIMER DISPLAY ---
            // format seconds into MM:SS
            let minutes = timeRemaining / 60
            let seconds = timeRemaining % 60
            Text(String(format: "%02d:%02d", minutes, seconds))
                .font(.system(size: 72, weight: .bold, design: .monospaced))
                // .monospaced means all digits are the same width
                // so the display doesn't jump around as numbers change

            // --- SUBJECT PICKER ---
            Picker("Studying", selection: $selectedSubject) {
                Text("General").tag(nil as Subject?)
                ForEach(subjects) { subject in
                    Text(subject.name).tag(subject as Subject?)
                }
            }
            .pickerStyle(.menu)   // dropdown style

            // --- CONTROLS ---
            HStack(spacing: 20) {
                // start/pause button
                Button(action: {
                    isRunning.toggle()   // flips true ↔ false
                }) {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(isStudyPhase ? .blue : .green)
                }

                // reset button
                Button(action: {
                    isRunning = false
                    timeRemaining = studyDuration
                    isStudyPhase = true
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                }
            }

            // --- SESSION COUNTER ---
            Text("Sessions completed: \(sessionsCompleted)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle("Focus Timer")
        // --- TIMER TICK ---
        // .onReceive listens to the timer and runs this code every second
        .onReceive(timer) { _ in
            // only tick if the timer is running
            guard isRunning else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1    // subtract 1 second
            } else {
                // timer finished!
                if isStudyPhase {
                    // study phase ended — log it and start a break
                    sessionsCompleted += 1
                    logStudySession()

                    // long break every 4 sessions, short break otherwise
                    isStudyPhase = false
                    timeRemaining = sessionsCompleted % 4 == 0
                        ? longBreak       // 15 min after 4 sessions
                        : shortBreak      // 5 min normally
                } else {
                    // break ended — back to studying
                    isStudyPhase = true
                    timeRemaining = studyDuration
                }
            }
        }
    }

    // --- LOG THE SESSION (for study streak) ---
    func logStudySession() {
        let log = StudyLog(date: Date(), durationMinutes: 25, subject: selectedSubject)
        modelContext.insert(log)
    }
}
```

### StudyLog.swift (Data Model for tracking)

```swift
import SwiftData
import Foundation

@Model
class StudyLog {
    var date: Date                 // when the session happened
    var durationMinutes: Int       // how long (in minutes)
    var subject: Subject?          // which subject (optional)

    init(date: Date, durationMinutes: Int, subject: Subject? = nil) {
        self.date = date
        self.durationMinutes = durationMinutes
        self.subject = subject
    }
}
```

---

## Part 23: Study Streak

Tracks consecutive days the student used the Focus Timer.

```swift
import SwiftUI
import SwiftData

struct StudyStreakView: View {

    @Query(sort: \StudyLog.date) var studyLogs: [StudyLog]

    var body: some View {
        HStack {
            Image(systemName: "flame.fill")
                .foregroundColor(.orange)
                .font(.title2)
            VStack(alignment: .leading) {
                Text("\(currentStreak) day streak")
                    .font(.headline)
                    .bold()
                Text("Longest: \(longestStreak) days")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // --- CALCULATE CURRENT STREAK ---
    var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var checkDate = Date()   // start from today

        while true {
            // check if there's a study log on this date
            let hasLog = studyLogs.contains { log in
                calendar.isDate(log.date, inSameDayAs: checkDate)
            }

            if hasLog {
                streak += 1
                // go back one day
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else {
                // check if it's a weekend — weekends don't break the streak
                let weekday = calendar.component(.weekday, from: checkDate)
                // 1 = Sunday, 7 = Saturday
                if weekday == 1 || weekday == 7 {
                    checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
                    continue    // skip weekends
                } else {
                    break       // weekday with no log = streak broken
                }
            }
        }
        return streak
    }

    // --- CALCULATE LONGEST STREAK (same logic but check all history) ---
    var longestStreak: Int {
        // simplified: just return current streak or track separately
        // for a proper implementation, iterate through all dates in studyLogs
        return max(currentStreak, 0)
    }
}
```

---

## Part 24: Quick Capture

A one-tap button that opens a note sheet pre-tagged to whatever class is happening right now.

```swift
import SwiftUI
import SwiftData

struct QuickCaptureButton: View {

    @State var showingSheet = false
    @Query var allSlots: [TimetableSlot]

    var body: some View {
        // floating button — add this to your dashboard or timetable view
        Button(action: {
            showingSheet = true
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .shadow(radius: 4)
        }
        .sheet(isPresented: $showingSheet) {
            QuickCaptureSheet(currentSubject: getCurrentSubject())
        }
    }

    // figure out what subject is happening right now
    func getCurrentSubject() -> Subject? {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let nowMinutes = hour * 60 + minute

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let todayName = formatter.string(from: now)

        let periods = periodsForDay(todayName)

        // find current period index
        guard let index = periods.firstIndex(where: { period in
            let start = period.startHour * 60 + period.startMinute
            let end = period.endHour * 60 + period.endMinute
            return nowMinutes >= start && nowMinutes < end
        }) else { return nil }

        // find the slot for this period
        return allSlots.first(where: {
            $0.day == todayName && $0.periodIndex == index
        })?.subject
    }
}

struct QuickCaptureSheet: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    let currentSubject: Subject?     // auto-detected current class
    @State var noteText = ""

    var body: some View {
        NavigationStack {
            VStack {
                // show which class this is tagged to
                if let subject = currentSubject {
                    Text("Note for: \(subject.name)")
                        .font(.headline)
                        .padding()
                } else {
                    Text("Quick Note")
                        .font(.headline)
                        .padding()
                }

                TextEditor(text: $noteText)
                    .padding()
            }
            .navigationTitle("Quick Capture")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // save as a new assignment/note
                        let note = Assignment(
                            title: "Quick Note — \(Date().formatted(date: .abbreviated, time: .shortened))",
                            details: noteText,
                            dueDate: Date(),  // today
                            subject: currentSubject
                        )
                        modelContext.insert(note)
                        dismiss()
                    }
                    .disabled(noteText.isEmpty)
                }
            }
        }
    }
}
```

---

## Part 25: Workload Heatmap

A visual calendar grid showing how busy each day is based on assignment due dates. Like the GitHub contribution graph but for schoolwork.

```swift
import SwiftUI
import SwiftData

struct WorkloadHeatmapView: View {

    @Query var assignments: [Assignment]

    // show 5 weeks (current + next 4)
    let weeksToShow = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("Workload")
                .font(.headline)

            // day labels across the top
            HStack(spacing: 4) {
                ForEach(["M", "T", "W", "T", "F"], id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
            }

            // grid of coloured squares
            let weeks = generateWeeks()

            ForEach(0..<weeks.count, id: \.self) { weekIndex in
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { dayIndex in
                        // 5 days per week (Mon–Fri)
                        let date = weeks[weekIndex][dayIndex]
                        let count = assignmentsDue(on: date)

                        // coloured square
                        RoundedRectangle(cornerRadius: 4)
                            .fill(heatmapColor(for: count))
                            .frame(height: 30)
                            // show the day number
                            .overlay(
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.caption2)
                                    .foregroundColor(count > 0 ? .white : .gray)
                            )
                    }
                }
            }

            // legend
            HStack {
                Text("Light").font(.caption2).foregroundColor(.gray)
                ForEach([0, 1, 2, 3], id: \.self) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(heatmapColor(for: level))
                        .frame(width: 14, height: 14)
                }
                Text("Heavy").font(.caption2).foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // count incomplete assignments due on a specific date
    func assignmentsDue(on date: Date) -> Int {
        assignments.filter { assignment in
            !assignment.isCompleted &&
            Calendar.current.isDate(assignment.dueDate, inSameDayAs: date)
        }.count
    }

    // colour based on how many things are due
    func heatmapColor(for count: Int) -> Color {
        switch count {
        case 0: return Color(.systemGray5)     // nothing due — light grey
        case 1: return Color.green.opacity(0.6) // light load
        case 2: return Color.orange.opacity(0.7) // medium
        default: return Color.red.opacity(0.8)   // heavy
        }
    }

    // generate date arrays for each week
    func generateWeeks() -> [[Date]] {
        var weeks: [[Date]] = []
        let calendar = Calendar.current

        // find this Monday
        var startOfWeek = calendar.date(from: calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear], from: Date()
        ))!

        for _ in 0..<weeksToShow {
            var week: [Date] = []
            for day in 0..<5 {   // Mon–Fri
                let date = calendar.date(byAdding: .day, value: day, to: startOfWeek)!
                week.append(date)
            }
            weeks.append(week)
            startOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
        }
        return weeks
    }
}
```

---

## Part 26: "What Should I Study?"

Ranks assignments by urgency (closest due date × highest difficulty) and suggests what to work on.

```swift
import SwiftUI
import SwiftData

struct WhatToStudyView: View {

    @Query var assignments: [Assignment]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("WHAT SHOULD I STUDY?")
                .font(.caption)
                .foregroundColor(.gray)
                .bold()

            // get top 3 suggestions
            let suggestions = topSuggestions()

            if suggestions.isEmpty {
                Text("No upcoming assignments — you're all caught up!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(suggestions) { assignment in
                    HStack {
                        // priority indicator
                        Circle()
                            .fill(priorityColor(for: assignment))
                            .frame(width: 10, height: 10)

                        VStack(alignment: .leading) {
                            Text(assignment.title)
                                .font(.headline)
                            HStack {
                                if let subject = assignment.subject {
                                    Text(subject.name)
                                        .font(.caption)
                                }
                                Text("· \(countdownText(for: assignment.dueDate))")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Text("· Difficulty: \(assignment.difficulty)/5")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
        }
    }

    // --- PRIORITY ALGORITHM ---
    func topSuggestions() -> [Assignment] {
        // filter: only incomplete, not yet overdue
        let active = assignments.filter { !$0.isCompleted && $0.dueDate > Date() }

        // sort by priority score (higher = more urgent)
        let sorted = active.sorted { a, b in
            priorityScore(for: a) > priorityScore(for: b)
        }

        // return top 3
        return Array(sorted.prefix(3))
    }

    func priorityScore(for assignment: Assignment) -> Double {
        // days until due (fewer days = more urgent)
        let daysUntilDue = max(
            Calendar.current.dateComponents([.day], from: Date(), to: assignment.dueDate).day ?? 0,
            1  // avoid division by zero
        )

        // difficulty (1–5 scale, higher = harder = needs more time)
        let difficulty = Double(assignment.difficulty)

        // score: difficulty divided by days remaining
        // high difficulty + few days = high score = top suggestion
        return difficulty / Double(daysUntilDue)
    }

    func priorityColor(for assignment: Assignment) -> Color {
        let score = priorityScore(for: assignment)
        if score > 2.0 { return .red }      // urgent
        if score > 1.0 { return .orange }   // medium
        return .green                        // can wait
    }

    func countdownText(for dueDate: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
        if days == 0 { return "Due today" }
        if days == 1 { return "Due tomorrow" }
        return "Due in \(days) days"
    }
}
```

**Note:** You'll need to add a `difficulty` field to the Assignment model:

```swift
// in Assignment.swift, add:
var difficulty: Int    // 1 (easy) to 5 (hard)

// and in the init, add:
// difficulty: Int = 3    (defaults to medium)
```

---

## Part 27: Subject Colour Theme (Toggleable)

When enabled, the app's accent colour changes to match the current class. Off by default.

```swift
import SwiftUI
import SwiftData

struct SmartlyApp: App {

    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("feature_subjectTheme") var subjectThemeEnabled = false

    // track the current accent colour
    @State var currentAccentColour: Color = .blue

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    ContentView()
                } else {
                    OnboardingView()
                }
            }
            // apply the dynamic accent colour if the feature is enabled
            .tint(subjectThemeEnabled ? currentAccentColour : .blue)
            // .tint() changes the app's accent colour globally
            .onAppear {
                updateAccentColour()
            }
        }
        .modelContainer(for: [Subject.self, TimetableSlot.self, Assignment.self, StudyLog.self])
    }

    func updateAccentColour() {
        // only run if the feature is enabled
        guard subjectThemeEnabled else { return }

        // figure out the current subject and use its colour
        // (same logic as the dashboard's current period detection)
        // set currentAccentColour = Color(hex: subject.colourHex)
    }
}
```

The key line is `.tint()` — this changes every button, link, and accent colour across the entire app in one go. When the feature is off, it uses the default blue.

---

## Part 28: Photo Scanner

Attach photos of handouts to assignments. Uses the device camera (iPad) or file picker (macOS).

```swift
import SwiftUI
import PhotosUI   // Apple's built-in photo picker

struct PhotoAttachmentView: View {

    @Bindable var assignment: Assignment

    // PhotosPickerItem is Apple's built-in photo selection
    @State var selectedPhoto: PhotosPickerItem? = nil
    @State var attachedImages: [Data] = []   // store images as raw data

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Attachments")
                .font(.headline)

            // show attached photos
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<attachedImages.count, id: \.self) { index in
                        if let nsImage = NSImage(data: attachedImages[index]) {
                            Image(nsImage: nsImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                                .clipped()  // crops to the frame
                        }
                    }
                }
            }

            // photo picker button
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label("Add Photo", systemImage: "camera.fill")
            }
            // when a photo is selected, load it
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    // load the photo data
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        attachedImages.append(data)
                    }
                }
            }
        }
    }
}
```

**Note:** For full photo persistence, you'd store the image data in SwiftData by adding an `attachments: [Data]` field to the Assignment model. Images stored as `Data` (raw bytes) can be saved and loaded by SwiftData.
