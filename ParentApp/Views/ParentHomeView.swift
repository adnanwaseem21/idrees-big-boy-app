import SwiftUI

struct ParentHomeView: View {
    @EnvironmentObject private var store: SettingsStore
    @ObservedObject private var family = FamilyCloud.shared

    var body: some View {
        NavigationStack {
            List {
                if ScreenshotMode.screen == nil {
                    Section {
                        NavigationLink { WatchCodeView() } label: {
                            HStack {
                                Text("🔗")
                                Text("Watch code")
                                Spacer()
                                Text(family.code ?? "Set up").font(.body.monospaced()).foregroundStyle(.secondary)
                            }
                        }
                    } footer: {
                        if let error = family.lastError {
                            Text(error).foregroundStyle(.orange)
                        } else if let last = family.lastSync {
                            Text("Synced \(last.formatted(.relative(presentation: .named))).")
                        }
                    }
                }
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
                    Text("Changes sync to \(store.settings.childName)'s watch through the watch code. They reach the watch the next time it has signal and the app is open.")
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

/// Shows the code to type on the watch (or on a second parent's phone), and
/// lets a second parent join with the code from the first parent's phone.
struct WatchCodeView: View {
    @EnvironmentObject private var store: SettingsStore
    @ObservedObject private var family = FamilyCloud.shared
    @State private var typed = ""
    @State private var joining = false

    var body: some View {
        List {
            if let code = family.code {
                Section {
                    Text(code)
                        .font(.system(size: 34, weight: .bold, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .textSelection(.enabled)
                } footer: {
                    Text("On \(store.settings.childName)'s watch, open the app, tap Link to parent's phone and type this code. A second parent can type it on their phone too (Use a code from another phone). Keep it in the family: anyone with the code can see and change these settings.")
                }
                Section {
                    if let error = family.lastError {
                        Label(error, systemImage: "exclamationmark.triangle").foregroundStyle(.orange)
                    } else if let last = family.lastSync {
                        Label("Synced \(last.formatted(.relative(presentation: .named)))", systemImage: "checkmark.circle")
                    }
                    Button("Sync now") {
                        store.pushToWatch()
                        Task { await family.pull() }
                    }
                    Button("Stop syncing and delete synced data", role: .destructive) {
                        Task { await family.deleteAndUnlink() }
                    }
                } footer: {
                    Text("Synced data is encrypted with this code, so only your family's devices can read it.")
                }
            } else {
                Section {
                    Button("Make a watch code") {
                        family.setCode(FamilyCloud.newCode())
                        store.pushToWatch()
                    }
                } footer: {
                    Text("The code links this phone and the watch, even when the watch uses its own Apple ID (Family Setup).")
                }
            }

            Section("Use a code from another phone") {
                TextField("Code, like K7QM-3XTP", text: $typed)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                Button("Use this code") {
                    // Joining: take the other phone's settings instead of pushing ours.
                    family.setCode(typed)
                    typed = ""
                }
                .disabled(!FamilyCloud.isValid(typed))
            }
        }
        .navigationTitle("Watch code")
        .onAppear {
            if family.code == nil {
                family.setCode(FamilyCloud.newCode())
                store.pushToWatch()
            }
        }
    }
}
