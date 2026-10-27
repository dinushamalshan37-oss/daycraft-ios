import SwiftUI
import SwiftData
import Combine

struct FocusView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \FocusSession.completedAt, order: .reverse) private var sessions: [FocusSession]
    @State private var selectedMinutes = 25
    @State private var remainingSeconds = 25 * 60
    @State private var endTime: Date?
    @State private var isRunning = false
    @State private var showFinished = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var todaySessions: [FocusSession] {
        sessions.filter { Calendar.current.isDateInToday($0.completedAt) }
    }
    private var clock: String {
        String(format: "%02d:%02d", remainingSeconds / 60, remainingSeconds % 60)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 27) {
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundStyle(.indigo)
                    Text("Time to focus")
                        .font(.title2.bold())
                    Text("One thing at a time. You got this.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 32)

                ZStack {
                    Circle()
                        .stroke(Color.indigo.opacity(0.12), lineWidth: 14)
                    Circle()
                        .trim(from: 0, to: 1 - CGFloat(remainingSeconds) / CGFloat(selectedMinutes * 60))
                        .stroke(Color.indigo, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.6), value: remainingSeconds)
                    VStack(spacing: 6) {
                        Text(clock)
                            .font(.system(size: 55, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .contentTransition(.numericText())
                        Text(isRunning ? "FOCUSING" : "READY WHEN YOU ARE")
                            .font(.caption2.weight(.bold))
                            .tracking(1.5)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 250, height: 250)
                .padding(12)
                .accessibilityLabel("Focus timer: \(clock)")

                Picker("Focus duration", selection: $selectedMinutes) {
                    Text("15 min").tag(15)
                    Text("25 min").tag(25)
                    Text("45 min").tag(45)
                }
                .pickerStyle(.segmented)
                .disabled(isRunning)
                .onChange(of: selectedMinutes) { _, newValue in
                    remainingSeconds = newValue * 60
                }

                HStack(spacing: 12) {
                    Button {
                        if isRunning { pause() } else { start() }
                    } label: {
                        Label(isRunning ? "Pause" : "Start focus", systemImage: isRunning ? "pause.fill" : "play.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        reset()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Reset timer")
                }

                HStack(spacing: 12) {
                    StatPill(icon: "timer", title: "Minutes today", value: "\(todaySessions.reduce(0) { $0 + $1.minutes })", color: .indigo)
                    StatPill(icon: "checkmark.seal", title: "Sessions today", value: "\(todaySessions.count)", color: .green)
                }
                if !sessions.isEmpty {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Recent sessions").font(.headline)
                        ForEach(Array(sessions.prefix(5))) { session in
                            HStack {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                                Text("\(session.minutes)-minute focus")
                                Spacer()
                                Text(session.completedAt, format: .dateTime.month(.abbreviated).day())
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Focus")
        .onReceive(timer) { now in
            guard isRunning, let endTime else { return }
            remainingSeconds = max(0, Int(ceil(endTime.timeIntervalSince(now))))
            if remainingSeconds == 0 { finish() }
        }
        .alert("Focus complete! 🎉", isPresented: $showFinished) {
            Button("Nice!") { }
        } message: {
            Text("You completed \(selectedMinutes) minutes. Keep it up!")
        }
    }

    private func start() {
        endTime = .now.addingTimeInterval(TimeInterval(remainingSeconds))
        isRunning = true
    }

    private func pause() {
        if let endTime { remainingSeconds = max(0, Int(ceil(endTime.timeIntervalSince(.now)))) }
        self.endTime = nil
        isRunning = false
    }

    private func reset() {
        endTime = nil
        isRunning = false
        remainingSeconds = selectedMinutes * 60
    }

    private func finish() {
        guard isRunning else { return }
        context.insert(FocusSession(minutes: selectedMinutes))
        try? context.save()
        reset()
        showFinished = true
    }
}
