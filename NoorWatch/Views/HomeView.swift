import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: KidStore
    @EnvironmentObject private var prayers: PrayerService
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var family = FamilyCloud.shared

    var body: some View {
        NavigationStack {
            List {
                if family.code == nil && ScreenshotMode.screen == nil {
                    NavigationLink { WatchLinkView() } label: {
                        MenuRow(emoji: "🔗", title: "Link to parent's phone", detail: "Type the watch code")
                    }
                }
                TimelineView(.everyMinute) { context in
                    NextPrayerCard(now: context.date)
                }
                .listRowBackground(Color.clear)

                if FamilyConfig.faithFeaturesOn {
                    NavigationLink { PrayerView() } label: {
                        MenuRow(emoji: "🕌", title: "Prayer", detail: "\(store.log().prayed.count) of 5 today")
                    }
                }
                NavigationLink { TodayView() } label: {
                    MenuRow(emoji: "✅", title: "Chores & Activities", detail: "\(doneToday) of \(store.tasks().count) done")
                }
                NavigationLink { ScheduleView() } label: {
                    MenuRow(emoji: "📅", title: "My Day", detail: FamilyConfig.faithFeaturesOn ? "Schedule & prayer times" : "Your schedule")
                }
                NavigationLink { CallParentsView() } label: {
                    MenuRow(emoji: "📞", title: "Call " + FamilyConfig.parents.map(\.name).joined(separator: " & "))
                }
                NavigationLink { VoiceNotesView() } label: {
                    MenuRow(emoji: "🎙️", title: "Voice Notes")
                }
                if FamilyConfig.faithFeaturesOn {
                    NavigationLink { QuranView() } label: {
                        MenuRow(emoji: "📖", title: "Quran", detail: "\(QuranContent.surahs.count) surahs to memorize")
                    }
                    NavigationLink { DuaView() } label: {
                        MenuRow(emoji: "🤲", title: "Dua & Dhikr", detail: IslamicContent.duaOfTheDay().occasion)
                    }
                }
                NavigationLink { WeekReviewView() } label: {
                    MenuRow(emoji: "⭐", title: "My Week")
                }
                NavigationLink { RewardsView() } label: {
                    MenuRow(emoji: "🎁", title: "Rewards", detail: "\(store.totalPoints) points")
                }
                if FamilyConfig.gamesEnabled {
                    NavigationLink { GamesView() } label: {
                        MenuRow(emoji: "🎮", title: "Games", detail: gamesDetail)
                    }
                }
                if family.code != nil {
                    NavigationLink { WatchLinkView() } label: {
                        MenuRow(emoji: "🔗", title: "Phone link", detail: family.lastError == nil ? "Linked" : "Not syncing")
                    }
                }
            }
            .navigationTitle(Brand.shortName)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                Task { await FamilyCloud.shared.pull() }
                prayers.refreshLocation()
                Reminders.rescheduleAll(prayers: prayers)
            }
        }
    }

    private var doneToday: Int {
        store.tasks().filter { store.isDone($0) }.count
    }

    private var gamesDetail: String {
        if let blackout = GamesGate.activeBlackout() {
            return "Off during \(blackout.label.lowercased())"
        }
        return FamilyConfig.games.count == 1 ? "1 game" : "\(FamilyConfig.games.count) games"
    }
}

struct NextPrayerCard: View {
    @EnvironmentObject private var store: KidStore
    @EnvironmentObject private var prayers: PrayerService
    let now: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(Brand.greeting), \(FamilyConfig.childName)!")
                .font(.headline)
            if FamilyConfig.faithFeaturesOn, let next = prayers.nextPrayer(after: now) {
                Text("\(next.salah.name) at \(next.time.formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                Text("in \(next.time, style: .relative)")
                    .font(.caption2)
                    .foregroundStyle(.green)
            }
            if FamilyConfig.faithFeaturesOn {
                Text("⭐ \(store.totalPoints)   🔥 \(store.prayerStreak)-day streak")
                    .font(.caption2)
            } else {
                Text("⭐ \(store.totalPoints) points")
                    .font(.caption2)
            }
        }
    }
}

struct MenuRow: View {
    let emoji: String
    let title: String
    var detail: String? = nil

    var body: some View {
        HStack(spacing: 10) {
            Text(emoji)
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                if let detail {
                    Text(detail)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

/// Links the watch to the parent app with the watch code shown on the phone
/// (Home → Watch code). Works even when the watch has its own Apple ID.
struct WatchLinkView: View {
    @ObservedObject private var family = FamilyCloud.shared
    @State private var typed = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if let code = family.code {
                    Text("Linked").font(.headline)
                    Text(code).font(.title3.monospaced())
                    if let error = family.lastError {
                        Text(error).font(.caption2).foregroundStyle(.orange)
                    } else if let last = family.lastSync {
                        Text("Synced \(last.formatted(.relative(presentation: .named)))")
                            .font(.caption2).foregroundStyle(.secondary)
                    }
                    Button("Sync now") { Task { await family.pull() } }
                        .tint(.green)
                    Button("Unlink", role: .destructive) { family.setCode(nil) }
                } else {
                    Text("On the parent's iPhone, open the app and look for Watch code. Type it here.")
                        .font(.caption2)
                    TextField("Watch code", text: $typed)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                    Button("Link") {
                        family.setCode(typed)
                        Haptics.success()
                    }
                    .disabled(!FamilyCloud.isValid(typed))
                    .tint(.green)
                }
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Phone link")
    }
}
