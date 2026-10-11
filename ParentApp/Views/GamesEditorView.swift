import SwiftUI

struct GamesEditorView: View {
    @EnvironmentObject private var store: SettingsStore

    var body: some View {
        List {
            Section {
                Toggle("Allow games", isOn: $store.settings.gamesEnabled)
            } footer: {
                Text("Turn off to hide all games on the watch.")
            }

            if store.settings.gamesEnabled {
                Section("Games") {
                    ForEach($store.settings.games) { $game in
                        Toggle(isOn: $game.enabled) {
                            HStack { Text(game.emoji); Text(game.title) }
                        }
                    }
                }

                Section {
                    ForEach($store.settings.blackouts) { $window in
                        NavigationLink {
                            BlackoutDetailView(window: $window)
                        } label: {
                            HStack {
                                Text("🔒 \(window.label)")
                                Spacer()
                                Text(timeRange(window)).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { store.settings.blackouts.remove(atOffsets: $0) }

                    Button {
                        store.settings.blackouts.append(
                            Blackout(label: "New lock", startHour: 8, startMinute: 0, endHour: 15, endMinute: 0))
                    } label: {
                        Label("Add locked time", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Locked times")
                } footer: {
                    Text("Games are hidden during these windows — e.g. school hours and bedtime. Overnight windows (like 9pm–7am) are fine.")
                }
            }
        }
        .navigationTitle("Games")
        .toolbar { EditButton() }
    }

    private func timeRange(_ w: Blackout) -> String {
        String(format: "%d:%02d–%d:%02d", w.startHour, w.startMinute, w.endHour, w.endMinute)
    }
}

struct BlackoutDetailView: View {
    @Binding var window: Blackout

    var body: some View {
        Form {
            Section {
                TextField("Label", text: $window.label)
                DatePicker("Start", selection: .time(hour: $window.startHour, minute: $window.startMinute),
                           displayedComponents: .hourAndMinute)
                DatePicker("End", selection: .time(hour: $window.endHour, minute: $window.endMinute),
                           displayedComponents: .hourAndMinute)
            }
            Section("Days") {
                DaysPicker(days: $window.days)
            }
        }
        .navigationTitle("Locked time")
        .navigationBarTitleDisplayMode(.inline)
    }
}
