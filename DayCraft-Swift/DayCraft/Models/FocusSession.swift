import Foundation
import SwiftData

@Model
final class FocusSession {
    var minutes: Int
    var completedAt: Date

    init(minutes: Int, completedAt: Date = .now) {
        self.minutes = minutes
        self.completedAt = completedAt
    }
}
