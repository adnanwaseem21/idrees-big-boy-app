import SwiftUI
import WatchKit

@main
struct NoorWatchApp: App {
    @StateObject private var store = KidStore()
    @StateObject private var prayers = PrayerService()
    @StateObject private var voiceNotes = VoiceNotes()

    var body: some Scene {
        WindowGroup {
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

@MainActor
enum Haptics {
    static func tap() { WKInterfaceDevice.current().play(.click) }
    static func success() { WKInterfaceDevice.current().play(.success) }
}
