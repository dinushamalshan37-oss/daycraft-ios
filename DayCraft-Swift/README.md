# ☀️ DayCraft — SwiftUI Daily Planner

> A clean, offline-first iPhone app for tasks, daily habits, and focus sessions.

**Repository:** `daycraft-ios`  
**GitHub description:** Offline-first iOS daily planner built with SwiftUI and SwiftData, featuring tasks, habit streaks and a Pomodoro focus timer.

## Implemented features

- **Tasks** — create, check off, delete, prioritize, schedule and add notes
- **Habits** — add a habit, complete it once per calendar day, calculate daily streaks, delete habits
- **Focus** — 15/25/45-minute Pomodoro countdown, pause/reset, session history, today's stats
- **Local persistence** — SwiftData saves tasks, habits and completed focus sessions on the device
- Native SwiftUI interface with system light/dark mode, accessibility labels, tab navigation

## Requirements

- **macOS with Xcode 15 or newer** (Xcode 16+ recommended)
- iOS 17 or newer simulator or physical iPhone
- Swift / SwiftUI / SwiftData

**Important for Windows users:** You can view and edit these `.swift` files on Windows, but to compile and run a native iOS app you need macOS + Xcode or a remote Mac build service.

## Run in Xcode

1. Unzip the archive on a Mac.
2. Open `DayCraft-Swift/DayCraft.xcodeproj`.
3. Choose an iOS 17+ simulator in Xcode.
4. Select the **DayCraft** scheme and press **⌘R** (Run).
5. For a physical iPhone, set your signing team and a unique bundle identifier under *Signing & Capabilities*.

The project is configured for automatic Info.plist generation and has no external dependencies.

## Structure

```text
DayCraft-Swift/
  DayCraft.xcodeproj/
  DayCraft/
    DayCraftApp.swift
    Models/TaskItem.swift
    Models/HabitItem.swift
    Models/FocusSession.swift
    Components/StatPill.swift
    Components/TaskRow.swift
    Views/RootView.swift
    Views/TodayView.swift
    Views/HabitsView.swift
    Views/FocusView.swift
  README.md
```

## Technical notes / limitations

- Offline-only: this MVP does not use iCloud sync, user accounts, push notifications or external APIs.
- Focus timers are tracked against an actual end timestamp (so elapsed time remains accurate when the app is briefly backgrounded), but **there is no background notification** when the app is closed.
- Focus-session history saves only completed sessions. Paused or reset sessions are not recorded.
- Habit streaks use device-local calendar days; changing time zone can affect what counts as "today".
- App UI needs Xcode/iOS to verify; this package has not been compiled on a Mac.

## Suggested GitHub topics

`swift` `swiftui` `swiftdata` `ios` `productivity` `pomodoro` `habit-tracker`

## License

MIT — see [LICENSE](LICENSE) in this folder.
