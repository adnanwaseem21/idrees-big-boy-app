import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: KidStore
    @EnvironmentObject private var prayers: PrayerService
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            List {
                TimelineView(.everyMinute) { context in
                    NextPrayerCard(now: context.date)
                }
                .listRowBackground(Color.clear)

                if Brand.islamicFeatures {
                    NavigationLink { PrayerView() } label: {
                        MenuRow(emoji: "🕌", title: "Prayer", detail: "\(store.log().prayed.count) of 5 today")
                    }
                }
                NavigationLink { TodayView() } label: {
                    MenuRow(emoji: "✅", title: "Chores & Activities", detail: "\(doneToday) of \(store.tasks().count) done")
                }
                NavigationLink { ScheduleView() } label: {
                    MenuRow(emoji: "📅", title: "My Day", detail: Brand.islamicFeatures ? "Schedule & prayer times" : "Your schedule")
                }
                NavigationLink { CallParentsView() } label: {
                    MenuRow(emoji: "📞", title: "Call " + FamilyConfig.parents.map(\.name).joined(separator: " & "))
                }
                NavigationLink { VoiceNotesView() } label: {
                    MenuRow(emoji: "🎙️", title: "Voice Notes")
                }
                if Brand.islamicFeatures {
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
            }
            .navigationTitle(Brand.shortName)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
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
            if Brand.islamicFeatures, let next = prayers.nextPrayer(after: now) {
                Text("\(next.salah.name) at \(next.time.formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                Text("in \(next.time, style: .relative)")
                    .font(.caption2)
                    .foregroundStyle(.green)
            }
            if Brand.islamicFeatures {
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
