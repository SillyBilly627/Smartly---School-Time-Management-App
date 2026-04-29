# Smartly — Build Checklist

Use this to track your progress. Work through each phase in order — later phases depend on earlier ones. Commit to GitHub after every checkbox you complete.

---

## Phase 1: Project Setup
> Do this first. Everything else depends on it.

- [ ] Install Xcode from the Mac App Store
- [ ] Create new Multiplatform App project (SwiftData, SwiftUI, name: "Smartly")
- [ ] Sign into GitHub in Xcode (Settings → Accounts)
- [ ] Create the GitHub remote repo (Source Control → New Remote)
- [ ] Create folder structure (Models, Views, Data, Utilities groups)
- [ ] First commit: "Initial project setup"

---

## Phase 2: Data Models
> Build the blueprints before any screens.

- [ ] Create `Subject.swift` — @Model class with name, teacher, room, colourHex
- [ ] Create `PeriodTimes.swift` — hardcoded period start/end times (standard + Friday)
- [ ] Create `TimetableSlot.swift` — @Model linking subject to day + period
- [ ] Create `Assignment.swift` — @Model with title, details, dueDate, notes, isCompleted, difficulty, subject link
- [ ] Create `StudyLog.swift` — @Model with date, durationMinutes, subject (for streak + reports)
- [ ] Create `ColorExtension.swift` — Color ↔ Hex helper
- [ ] Commit: "Added all data models"

---

## Phase 3: Feature Toggle System (Settings Foundation)
> Build this early so every feature respects user preferences from the start.
> Depends on: Phase 1

- [ ] Create `FeatureSettings.swift` using @AppStorage for each toggle
- [ ] Toggles to include (all with sensible defaults):
  - [ ] Live Activity (default: ON)
  - [ ] Push Notifications (default: ON)
  - [ ] Study Streak tracking (default: ON)
  - [ ] Focus Timer (default: ON)
  - [ ] Quick Capture (default: ON)
  - [ ] Workload Heatmap (default: ON)
  - [ ] Weekly Report (default: ON)
  - [ ] Exam Countdown (default: ON)
  - [ ] Subject Colour Themes (default: OFF)
  - [ ] "What Should I Study?" suggestions (default: ON)
- [ ] Create `FeatureToggleView.swift` — list of toggles in Settings
- [ ] Wire all features to check their toggle before activating
- [ ] Commit: "Feature toggle system"

---

## Phase 4: Subject Management (Settings)
> Need subjects before timetable or assignments.
> Depends on: Phase 2

- [ ] Create `SettingsView.swift` — main settings screen with navigation links
- [ ] Create `SubjectEditorView.swift` — form to add new subjects
- [ ] Show list of existing subjects with colour dot, name, teacher, room
- [ ] Swipe-to-delete on subjects
- [ ] Tap a subject to edit it
- [ ] Test: add subjects, close app, reopen — data persists
- [ ] Commit: "Subject management working"

---

## Phase 5: Timetable Editor (Settings)
> Assign subjects to period slots.
> Depends on: Phase 4

- [ ] Create `TimetableEditorView.swift` — grid/list of all days and periods
- [ ] Dropdown picker to assign a subject to each slot
- [ ] Support "Study" as a built-in option (no subject needed)
- [ ] Auto-create empty slots for all days × all periods on first launch
- [ ] Test: assign subjects, verify they save
- [ ] Commit: "Timetable editor working"

---

## Phase 6: Onboarding (First-Time Setup)
> Welcome flow for new users.
> Depends on: Phase 4 + Phase 5

- [ ] Create `OnboardingView.swift` — multi-step swipeable flow
- [ ] Step 1: Welcome screen with app name and icon
- [ ] Step 2: Add your subjects
- [ ] Step 3: Build your timetable
- [ ] Step 4: "You're all set!" confirmation
- [ ] Track completion with @AppStorage
- [ ] Show onboarding only on first launch
- [ ] Add "Redo Setup" option in Settings
- [ ] Commit: "Onboarding flow complete"

---

## Phase 7: Timetable View (Main Screen)
> Tab 1 — what users see most.
> Depends on: Phase 5

- [ ] Create `TimetableView.swift` — day picker + period list
- [ ] Create `PeriodRow.swift` — one row with time, subject, teacher, room
- [ ] Day picker defaults to today (Monday on weekends)
- [ ] Colour-code each row using subject colour
- [ ] Highlight current period (if viewing today during school hours)
- [ ] Show "Recess" and "Lunch" labels between correct periods
- [ ] Show "Study" or empty for unassigned slots
- [ ] Test on both macOS and iPad simulator
- [ ] Commit: "Timetable view complete"

---

## Phase 8: Assignment System
> Tab 2 — assignment tracker.
> Depends on: Phase 4

- [ ] Create `AssignmentListView.swift` — sorted by due date
- [ ] Create `AddAssignmentView.swift` — form with title, details, due date, subject picker, difficulty rating
- [ ] Create `AssignmentDetailView.swift` — view/edit with notes section
- [ ] Completion toggle (circle tap)
- [ ] Subject tag with colour on each row
- [ ] Strikethrough on completed assignments
- [ ] Red text on overdue assignments
- [ ] Assignment countdown — "Due in 3 days", "Due tomorrow", "Overdue"
- [ ] Commit: "Assignment system complete"

### Search & Filter
- [ ] Search bar (.searchable)
- [ ] Filter by subject
- [ ] Filter by status (All / Active / Completed / Overdue)
- [ ] Commit: "Assignment search and filtering"

### Difficulty Rating
- [ ] Add difficulty field to Assignment model (1–5 scale)
- [ ] Star or slider picker in the add/edit form
- [ ] Show difficulty indicator on assignment rows
- [ ] Commit: "Assignment difficulty rating"

---

## Phase 9: Today Dashboard
> Home screen — overview of the day.
> Depends on: Phase 7 + Phase 8

- [ ] Create `TodayDashboardView.swift`
- [ ] Current period card with time remaining
- [ ] Next period preview card
- [ ] Today's full schedule summary (compact)
- [ ] Upcoming assignments due this week
- [ ] Overdue assignments with warning styling
- [ ] Make this the default/first tab
- [ ] Commit: "Today dashboard complete"

---

## Phase 10: Colour Coding
> Apply subject colours consistently everywhere.
> Depends on: Phase 7 + Phase 8

- [ ] Timetable rows — left colour bar or background tint
- [ ] Assignment list — subject tag in subject colour
- [ ] Assignment detail — header accent
- [ ] Dashboard — current/next period colour
- [ ] Commit: "Colour coding throughout app"

### Subject-Based App Theme (Toggleable — OFF by default)
- [ ] When enabled: app accent colour changes to match current class
- [ ] Check feature toggle before applying
- [ ] Smoothly transitions between colours as periods change
- [ ] Falls back to default blue when disabled or outside school hours
- [ ] Commit: "Subject colour theme (toggleable)"

---

## Phase 11: Quick Capture
> One-tap note that auto-tags to current class.
> Depends on: Phase 7 (needs to know current period)

- [ ] Floating "+" or pencil button on the dashboard/timetable
- [ ] Opens a quick note sheet pre-tagged to the current class
- [ ] User types a note → saved as an assignment note or standalone note
- [ ] Option to attach it to an existing assignment instead
- [ ] Works during school hours only (greyed out otherwise)
- [ ] Check feature toggle before showing
- [ ] Commit: "Quick Capture feature"

---

## Phase 12: Focus Timer (Pomodoro)
> Study timer with structured breaks.
> Depends on: Phase 4 (needs subjects for tagging)

- [ ] Create `FocusTimerView.swift` — accessible from its own tab or dashboard
- [ ] Timer with customisable study/break lengths (default: 25 min study, 5 min break)
- [ ] Pick which subject you're studying (tags the session)
- [ ] Visual countdown (circular progress ring or bar)
- [ ] Sound/notification when timer ends
- [ ] Auto-switch between study and break phases
- [ ] Log completed sessions to StudyLog (for streak tracking)
- [ ] Long break option after 4 sessions (default: 15 min)
- [ ] Check feature toggle before showing
- [ ] Commit: "Focus Timer complete"

---

## Phase 13: Study Streak
> Tracks consecutive days the student logged study time.
> Depends on: Phase 12 (Focus Timer logs study sessions)

- [ ] Calculate current streak from StudyLog entries
- [ ] Display streak count on dashboard (flame icon + number)
- [ ] Show "longest streak" record
- [ ] Streak resets if a weekday is missed (weekends don't break it)
- [ ] Small celebration animation when streak hits milestones (7, 14, 30 days)
- [ ] Check feature toggle before showing
- [ ] Commit: "Study streak tracking"

---

## Phase 14: Exam Countdown
> Dedicated countdown for major tests with study suggestions.
> Depends on: Phase 8 (uses assignment system)

- [ ] Add "isExam" flag to Assignment model
- [ ] Toggle in add/edit form: "This is an exam/test"
- [ ] Exam countdown card on dashboard (big, prominent)
- [ ] Shows days remaining with visual countdown
- [ ] Suggested study plan: "Start revising X days before" based on difficulty
- [ ] Check feature toggle before showing
- [ ] Commit: "Exam countdown feature"

---

## Phase 15: Workload Heatmap
> Visual showing how busy each week is.
> Depends on: Phase 8 (needs assignment due dates)

- [ ] Create `WorkloadHeatmapView.swift`
- [ ] Calendar-style grid (like GitHub contribution graph)
- [ ] Each day coloured by number of things due (green = light, red = heavy)
- [ ] Tappable days show what's due
- [ ] Show current week + next 4 weeks
- [ ] Accessible from dashboard or its own section
- [ ] Check feature toggle before showing
- [ ] Commit: "Workload heatmap"

---

## Phase 16: "What Should I Study?"
> Smart suggestion based on due dates and difficulty.
> Depends on: Phase 8 (needs assignments with difficulty + due dates)

- [ ] Algorithm: prioritise by (closest due date × highest difficulty)
- [ ] Show top 3 suggestions on dashboard
- [ ] Each suggestion shows: assignment name, subject, due date, why it's suggested
- [ ] Example: "Systems Analysis Report — due in 2 days, rated Hard"
- [ ] Refreshes each time dashboard loads
- [ ] Check feature toggle before showing
- [ ] Commit: "What Should I Study suggestions"

---

## Phase 17: Photo Scanner
> Snap a photo of a handout, attach to an assignment.
> Depends on: Phase 8 (needs assignments to attach to)

- [ ] Camera button on assignment detail view
- [ ] Opens camera (iPad) or file picker (macOS)
- [ ] Save photo to app storage
- [ ] Display attached photos in assignment detail view
- [ ] Support multiple photos per assignment
- [ ] Pinch to zoom on photos
- [ ] Delete individual photos
- [ ] Commit: "Photo attachment feature"

---

## Phase 18: Weekly Report
> Summary of the week's activity.
> Depends on: Phase 8 + Phase 13 (needs assignments + study logs)

- [ ] Create `WeeklyReportView.swift`
- [ ] Assignments completed this week (count + list)
- [ ] Assignments added this week
- [ ] Total study time (from Focus Timer logs)
- [ ] Current study streak
- [ ] Upcoming assignments next week
- [ ] Busiest day this week (from workload data)
- [ ] Accessible from dashboard or Settings
- [ ] Check feature toggle before showing
- [ ] Commit: "Weekly report"

---

## Phase 19: Shared Class Finder
> Compare timetables with a friend to find matching classes.
> Depends on: Phase 7 (needs timetable data)

- [ ] Export your timetable as shareable data (JSON)
- [ ] Import a friend's timetable data
- [ ] Compare: highlight which periods you share the same class
- [ ] Display results: "You and [friend] both have Computer Science on Monday P1 and Wednesday P3"
- [ ] Share via AirDrop / Messages
- [ ] Commit: "Shared class finder"

---

## Phase 20: Push Notifications
> Remind students about upcoming assignments.
> Depends on: Phase 8

- [ ] Request notification permission
- [ ] Notification 1 day before assignment due
- [ ] Notification morning of due date
- [ ] Cancel when assignment completed
- [ ] Reschedule if due date changed
- [ ] Notification settings in Settings (toggle, timing)
- [ ] Check feature toggle before scheduling
- [ ] Commit: "Push notifications"

---

## Phase 21: Assignment Sharing
> Share assignments between students.
> Depends on: Phase 8

- [ ] ShareableAssignment struct (Codable)
- [ ] Share button on detail view
- [ ] Formatted text output (title, due date, subject, notes)
- [ ] Share via AirDrop / Messages / Share Sheet
- [ ] Commit: "Assignment sharing"

---

## Phase 22: Timetable Export
> Export timetable as shareable image.
> Depends on: Phase 7

- [ ] Export button in Settings
- [ ] Render timetable as image (ImageRenderer)
- [ ] Share via Share Sheet
- [ ] Commit: "Timetable export"

---

## Phase 23: Live Activity (Lock Screen)
> Persistent lock screen showing current/next class.
> Depends on: Phase 7 (timetable must be fully working)
> This is the hardest feature — save it for last core feature.

- [ ] Add Widget Extension target
- [ ] Create Live Activity layout (current class, time left, next class)
- [ ] Start activity at 8:25 AM
- [ ] Update when periods change (Timer every 60 sec)
- [ ] Handle recess and lunch in display
- [ ] End at 3:10 PM
- [ ] Progress bar for time remaining
- [ ] Check feature toggle before starting
- [ ] Test on iPad simulator
- [ ] Commit: "Live Activity on lock screen"

---

## Phase 24: Final Polish (Optional)
> Nice-to-haves for a professional feel.

- [ ] Design an app icon
- [ ] Add a launch screen
- [ ] Empty state screens ("No assignments yet — tap + to add one")
- [ ] Animations/transitions between views
- [ ] Test everything on iPad simulator
- [ ] Test everything on macOS
- [ ] Final commit: "Smartly v1.0 ready"

---

## Dependency Map

```
Phase 1 (Setup)
  └→ Phase 2 (Models)
  │    └→ Phase 3 (Feature Toggles)
  │
  └→ Phase 4 (Subjects)
       ├→ Phase 5 (Timetable Editor)
       │    ├→ Phase 6 (Onboarding)
       │    ├→ Phase 7 (Timetable View)
       │    │    ├→ Phase 9 (Dashboard)
       │    │    ├→ Phase 11 (Quick Capture)
       │    │    ├→ Phase 19 (Shared Class Finder)
       │    │    ├→ Phase 22 (Timetable Export)
       │    │    └→ Phase 23 (Live Activity)
       │    └→ Phase 10 (Colour Coding)
       │
       ├→ Phase 8 (Assignments)
       │    ├→ Phase 9 (Dashboard)
       │    ├→ Phase 14 (Exam Countdown)
       │    ├→ Phase 15 (Workload Heatmap)
       │    ├→ Phase 16 (What Should I Study)
       │    ├→ Phase 17 (Photo Scanner)
       │    ├→ Phase 20 (Notifications)
       │    └→ Phase 21 (Assignment Sharing)
       │
       └→ Phase 12 (Focus Timer)
            ├→ Phase 13 (Study Streak)
            └→ Phase 18 (Weekly Report)
```

**Priority order suggestion:**
Phases 1–9 = core app (get this working first)
Phases 10–16 = impressive features (makes it stand out)
Phases 17–23 = advanced features (if you have time)
Phase 24 = final polish
