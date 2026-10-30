import SwiftUI

/// The parent's iPhone companion to Idrees's watch app.
/// Everything edited here syncs to the watch through the family's iCloud.
@main
struct ParentApp: App {
    @StateObject private var store = SettingsStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if let shot = ScreenshotMode.screen {
                    switch shot {
                    case "chores": NavigationStack { TasksEditorView(kind: "chore", title: "Chores") }
                    case "schedule": NavigationStack { ScheduleEditorView() }
                    case "rewards": NavigationStack { RewardsEditorView() }
                    case "review": NavigationStack { ReviewView() }
                    default: ParentHomeView()
                    }
                } else if store.settings.setupComplete {
                    ParentHomeView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(store)
            .tint(Brand.accent)
        }
    }
}
