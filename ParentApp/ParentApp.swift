import SwiftUI

/// The parent's iPhone companion to Idrees's watch app.
/// Everything edited here syncs to the watch through the family's iCloud.
@main
struct ParentApp: App {
    @StateObject private var store = SettingsStore()

    var body: some Scene {
        WindowGroup {
            ParentHomeView()
                .environmentObject(store)
                .tint(Color(red: 0.14, green: 0.35, blue: 0.22))   // Idrees forest green
        }
    }
}
