import SwiftUI
import WatchKit

@main
struct NoorWatchApp: App {
    @StateObject private var store = KidStore()
    @StateObject private var prayers = PrayerService()
    @StateObject private var voiceNotes = VoiceNotes()

    var body: some Scene {
        WindowGroup {
            if let shot = ScreenshotMode.screen {
                screenshotRoot(shot)
                    .environmentObject(store)
                    .environmentObject(prayers)
                    .environmentObject(voiceNotes)
                    .task { prayers.refreshLocation() }
            } else {
                HomeView()
                    .environmentObject(store)
                    .environmentObject(prayers)
                    .environmentObject(voiceNotes)
                    .task {
                        await Reminders.requestPermission()
                        prayers.refreshLocation()
                        Reminders.rescheduleAll(prayers: prayers)
                    }
            }
        }
    }

    /// One screen per App Store screenshot (see ScreenshotMode).
    @ViewBuilder
    private func screenshotRoot(_ name: String) -> some View {
        switch name {
        case "today": NavigationStack { TodayView() }
        case "prayer": NavigationStack { PrayerView() }
        case "schedule": NavigationStack { ScheduleView() }
        case "rewards": NavigationStack { RewardsView() }
        case "call": NavigationStack { CallParentsView() }
        default: HomeView()
        }
    }
}

@MainActor
enum Haptics {
    static func tap() { WKInterfaceDevice.current().play(.click) }
    static func success() { WKInterfaceDevice.current().play(.success) }
}
