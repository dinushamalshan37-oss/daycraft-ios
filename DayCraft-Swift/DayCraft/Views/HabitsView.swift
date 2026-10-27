import SwiftUI
import SwiftData

struct HabitsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \HabitItem.createdAt) private var habits: [HabitItem]
    @State private var showingAddHabit = false

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.title)
                        .foregroundStyle(.orange)
                    Text("Build better habits")
                        .font(.title2.bold())
                    Text("Show up daily, even in small ways.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .padding(.vertical, 12)
            }
            .listRowBackground(Color.clear)

            Section("Your habits") {
                if habits.isEmpty {
                    ContentUnavailableView("No habits yet", systemImage: "flame", description: Text("Add your first daily habit."))
                } else {
                    ForEach(habits) { habit in
                        HStack(spacing: 14) {
                            Text(habit.emoji).font(.title)
                                .frame(width: 44, height: 44)
                                .background(Color.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(habit.name).fontWeight(.semibold)
                                Text("🔥 \(habit.streak) day streak · \(habit.totalCompletions) total")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button {
                                habit.checkIn()
                                try? context.save()
                            } label: {
                                Image(systemName: habit.completedToday ? "checkmark.circle.fill" : "circle")
                                    .font(.title)
                                    .foregroundStyle(habit.completedToday ? .green : .indigo)
                            }
                            .buttonStyle(.plain)
                            .disabled(habit.completedToday)
                            .accessibilityLabel(habit.completedToday ? "Completed today" : "Complete \(habit.name) today")
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete(perform: delete)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Habits")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingAddHabit = true } label: { Label("New habit", systemImage: "plus") }
            }
        }
        .sheet(isPresented: $showingAddHabit) { AddHabitSheet() }
    }

    private func delete(at offsets: IndexSet) {
        for offset in offsets { context.delete(habits[offset]) }
        try? context.save()
    }
}

private struct AddHabitSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var name = ""
    @State private var emoji = "✨"

    var body: some View {
        NavigationStack {
            Form {
                Section("Daily habit") {
                    TextField("e.g. Read 20 minutes", text: $name)
                    TextField("Emoji", text: $emoji)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let value = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        context.insert(HabitItem(name: value, emoji: emoji.isEmpty ? "✨" : emoji))
                        try? context.save()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
