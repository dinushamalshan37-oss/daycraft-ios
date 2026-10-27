import SwiftUI

struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? .green : .indigo)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(task.isCompleted ? "Mark \(task.title) incomplete" : "Complete \(task.title)")

            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .fontWeight(.medium)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)
                if !task.notes.isEmpty {
                    Text(task.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            Spacer(minLength: 8)
            if task.priority == 2 {
                Image(systemName: "flag.fill")
                    .foregroundStyle(.orange)
                    .accessibilityLabel("High priority")
            }
        }
        .padding(.vertical, 4)
    }
}
