import SwiftUI

/// Edits chores or activities (same screen, filtered by kind).
struct TasksEditorView: View {
    @EnvironmentObject private var store: SettingsStore
    let kind: String
    let title: String

    var body: some View {
        List {
            ForEach(indices, id: \.self) { i in
                NavigationLink {
                    TaskDetailView(task: $store.settings.tasks[i])
                } label: {
                    HStack {
                        Text(store.settings.tasks[i].emoji)
                        VStack(alignment: .leading) {
                            Text(store.settings.tasks[i].title)
                            Text("+\(store.settings.tasks[i].points) pts\(reminderText(store.settings.tasks[i]))")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .onDelete { offsets in
                let realIndices = offsets.map { indices[$0] }
                store.settings.tasks.remove(atOffsets: IndexSet(realIndices))
            }

            Button {
                store.settings.tasks.append(
                    TaskSetting(id: UUID().uuidString, title: "New \(kind)", emoji: kind == "chore" ? "✅" : "⭐",
                                kind: kind, points: 5))
            } label: {
                Label("Add \(kind)", systemImage: "plus.circle.fill")
            }
        }
        .navigationTitle(title)
        .toolbar { EditButton() }
    }

    private var indices: [Int] {
        store.settings.tasks.indices.filter { store.settings.tasks[$0].kind == kind }
    }

    private func reminderText(_ t: TaskSetting) -> String {
        guard let h = t.reminderHour else { return "" }
        return " · reminder \(String(format: "%d:%02d", h, t.reminderMinute))"
    }
}

struct TaskDetailView: View {
    @Binding var task: TaskSetting
    @State private var hasReminder: Bool

    init(task: Binding<TaskSetting>) {
        _task = task
        _hasReminder = State(initialValue: task.wrappedValue.reminderHour != nil)
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $task.title)
                EmojiField(title: "Icon", emoji: $task.emoji)
                Stepper("Points: \(task.points)", value: $task.points, in: 0...100, step: 5)
            }
            Section("Days") {
                DaysPicker(days: $task.days)
            }
            Section("Reminder") {
                Toggle("Remind on the watch", isOn: $hasReminder)
                    .onChange(of: hasReminder) { _, on in
                        task.reminderHour = on ? (task.reminderHour ?? 17) : nil
                    }
                if hasReminder {
                    DatePicker("Time", selection: .time(
                        hour: Binding($task.reminderHour, default: 17),
                        minute: $task.reminderMinute), displayedComponents: .hourAndMinute)
                }
            }
        }
        .navigationTitle("Edit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Unwraps an optional Int binding with a fallback, for the time picker.
extension Binding where Value == Int {
    init(_ source: Binding<Int?>, default fallback: Int) {
        self.init(
            get: { source.wrappedValue ?? fallback },
            set: { source.wrappedValue = $0 }
        )
    }
}
