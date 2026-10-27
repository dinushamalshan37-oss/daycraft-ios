import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskItem.createdAt, order: .reverse) private var tasks: [TaskItem]
    @State private var showingAddTask = false

    private var currentTasks: [TaskItem] {
        tasks.filter { $0.dueDate < Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now))! }
    }

    private var upcomingTasks: [TaskItem] {
        tasks.filter { $0.dueDate >= Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now))! }
    }

    private var completedCount: Int { currentTasks.filter(\.isCompleted).count }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 7) {
                    Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.indigo)
                    Text("Make today count.")
                        .font(.title2.weight(.bold))
                    Text("Small progress adds up to big things.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)

            Section {
                HStack(spacing: 10) {
                    StatPill(icon: "checkmark.circle", title: "Completed", value: "\(completedCount)", color: .green)
                    StatPill(icon: "list.bullet", title: "Pending", value: "\(currentTasks.count - completedCount)", color: .indigo)
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)

            Section("Today & overdue") {
                if currentTasks.isEmpty {
                    ContentUnavailableView("You're all clear!", systemImage: "checkmark.seal", description: Text("Add a task to start your day."))
                } else {
                    ForEach(currentTasks) { task in
                        TaskRow(task: task) { task.isCompleted.toggle(); try? context.save() }
                    }
                    .onDelete { delete($0, from: currentTasks) }
                }
            }

            if !upcomingTasks.isEmpty {
                Section("Upcoming") {
                    ForEach(upcomingTasks) { task in
                        VStack(alignment: .leading, spacing: 4) {
                            TaskRow(task: task) { task.isCompleted.toggle(); try? context.save() }
                            Text(task.dueDate, format: .dateTime.month(.abbreviated).day())
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { delete($0, from: upcomingTasks) }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("DayCraft")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingAddTask = true } label: { Label("New task", systemImage: "plus") }
            }
        }
        .sheet(isPresented: $showingAddTask) { AddTaskSheet() }
    }

    private func delete(_ offsets: IndexSet, from source: [TaskItem]) {
        for index in offsets { context.delete(source[index]) }
        try? context.save()
    }
}

private struct AddTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate: Date = .now
    @State private var isHighPriority = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Task details") {
                    TextField("What needs to be done?", text: $title)
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                    DatePicker("Due date", selection: $dueDate, displayedComponents: .date)
                    Toggle("High priority", isOn: $isHighPriority)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        context.insert(TaskItem(title: title.trimmingCharacters(in: .whitespacesAndNewlines), notes: notes, dueDate: dueDate, priority: isHighPriority ? 2 : 1))
                        try? context.save()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
