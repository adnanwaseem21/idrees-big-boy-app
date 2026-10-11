import SwiftUI

struct ParentHomeView: View {
    @EnvironmentObject private var store: SettingsStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Child")
                        Spacer()
                        TextField("Name", text: $store.settings.childName)
                            .multilineTextAlignment(.trailing)
                    }
                    NavigationLink { ContactsEditorView() } label: {
                        row("📞", "Contacts & messages", count: store.settings.parents.count)
                    }
                }

                Section("Daily life") {
                    NavigationLink {
                        TasksEditorView(kind: "chore", title: "Chores")
                    } label: { row("🧹", "Chores", count: tasks("chore").count) }
                    NavigationLink {
                        TasksEditorView(kind: "activity", title: "Activities")
                    } label: { row("⭐", "Activities", count: tasks("activity").count) }
                    NavigationLink { ScheduleEditorView() } label: {
                        row("📅", "Schedule", count: store.settings.schedule.count)
                    }
                }

                Section("Fun & rewards") {
                    NavigationLink { GamesEditorView() } label: {
                        row("🎮", "Games", detail: store.settings.gamesEnabled ? "On" : "Off")
                    }
                    NavigationLink { RewardsEditorView() } label: {
                        row("🎁", "Rewards", count: store.settings.rewards.count)
                    }
                }

                if store.settings.faithFeaturesOn {
                    Section("Faith") {
                        NavigationLink { PrayerSettingsView() } label: {
                            row("🕌", "Prayer", detail: methodName(store.settings.prayerMethod))
                        }
                        NavigationLink { LocationSettingsView() } label: {
                            row("📍", "Home location")
                        }
                    }
                }

                Section(store.settings.childName) {
                    NavigationLink { ReviewView() } label: { row("📈", "His week") }
                }

                Section("App") {
                    NavigationLink { FeaturesView() } label: { row("⚙️", "Features") }
                    NavigationLink { HelpView() } label: { row("⌚", "Set up the watch") }
                }

                Section {
                    Text("Changes sync to \(store.settings.childName)'s watch through iCloud. They reach the watch the next time it has signal.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(Brand.shortName)
        }
    }

    private func tasks(_ kind: String) -> [TaskSetting] {
        store.settings.tasks.filter { $0.kind == kind }
    }

    private func row(_ emoji: String, _ title: String, count: Int? = nil, detail: String? = nil) -> some View {
        HStack {
            Text(emoji)
            Text(title)
            Spacer()
            if let count { Text("\(count)").foregroundStyle(.secondary) }
            if let detail { Text(detail).foregroundStyle(.secondary) }
        }
    }

    private func methodName(_ raw: String) -> String {
        PrayerMethods.all.first { $0.id == raw }?.name ?? raw
    }
}
