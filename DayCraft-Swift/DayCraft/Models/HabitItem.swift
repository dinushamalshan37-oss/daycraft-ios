import Foundation
import SwiftData

@Model
final class HabitItem {
    var name: String
    var emoji: String
    var createdAt: Date
    var lastCompletedAt: Date?
    var streak: Int
    var totalCompletions: Int

    init(name: String, emoji: String = "✨") {
        self.name = name
        self.emoji = emoji
        self.createdAt = .now
        self.lastCompletedAt = nil
        self.streak = 0
        self.totalCompletions = 0
    }

    var completedToday: Bool {
        guard let lastCompletedAt else { return false }
        return Calendar.current.isDateInToday(lastCompletedAt)
    }

    func checkIn() {
        guard !completedToday else { return }
        if let previous = lastCompletedAt, Calendar.current.isDateInYesterday(previous) {
            streak += 1
        } else {
            streak = 1
        }
        totalCompletions += 1
        lastCompletedAt = .now
    }
}
