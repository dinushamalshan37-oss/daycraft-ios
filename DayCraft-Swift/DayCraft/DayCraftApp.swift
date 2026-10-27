import SwiftUI
import SwiftData

@main
struct DayCraftApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .tint(Color.indigo)
        }
        .modelContainer(for: [TaskItem.self, HabitItem.self, FocusSession.self])
    }
}
