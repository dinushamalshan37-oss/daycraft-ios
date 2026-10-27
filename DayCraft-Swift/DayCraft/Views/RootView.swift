import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TodayView()
            }
            .tabItem { Label("Tasks", systemImage: "checkmark.square") }

            NavigationStack {
                HabitsView()
            }
            .tabItem { Label("Habits", systemImage: "flame") }

            NavigationStack {
                FocusView()
            }
            .tabItem { Label("Focus", systemImage: "timer") }
        }
    }
}
