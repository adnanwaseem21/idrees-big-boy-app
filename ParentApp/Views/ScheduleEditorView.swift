import SwiftUI

struct ScheduleEditorView: View {
    @EnvironmentObject private var store: SettingsStore

    var body: some View {
        List {
            ForEach($store.settings.schedule) { $item in
                NavigationLink {
                    ScheduleDetailView(item: $item)
                } label: {
                    HStack {
                        Text(item.emoji)
                        Text(item.title)
                        Spacer()
                        Text(String(format: "%d:%02d", item.hour, item.minute))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { store.settings.schedule.remove(atOffsets: $0) }

            Button {
                store.settings.schedule.append(
                    ScheduleSetting(id: UUID().uuidString, title: "New event", emoji: "📌", hour: 15, minute: 0))
            } label: {
                Label("Add event", systemImage: "plus.circle.fill")
            }
        }
        .navigationTitle("Schedule")
        .toolbar { EditButton() }
    }
}

struct ScheduleDetailView: View {
    @Binding var item: ScheduleSetting

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $item.title)
                EmojiField(title: "Icon", emoji: $item.emoji)
                DatePicker("Time", selection: .time(hour: $item.hour, minute: $item.minute),
                           displayedComponents: .hourAndMinute)
                Stepper("Remind \(item.remindBefore) min before", value: $item.remindBefore, in: 0...60, step: 5)
            }
            Section("Days") {
                DaysPicker(days: $item.days)
            }
        }
        .navigationTitle("Edit")
        .navigationBarTitleDisplayMode(.inline)
    }
}
