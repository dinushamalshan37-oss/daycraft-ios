import Foundation
import SwiftData

@Model
final class TaskItem {
    var title: String
    var notes: String
    var dueDate: Date
    var priority: Int
    var isCompleted: Bool
    var createdAt: Date

    init(title: String, notes: String = "", dueDate: Date = .now, priority: Int = 1) {
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = false
        self.createdAt = .now
    }
}
