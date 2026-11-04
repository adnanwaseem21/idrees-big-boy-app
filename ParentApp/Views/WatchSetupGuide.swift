import SwiftUI

/// Reusable instructions for getting the app onto a child's Apple Watch.
/// Shown in onboarding and from Help.
struct WatchSetupGuide: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            group("You'll need", [
                "An Apple Watch for your child (a cellular model if they won't carry an iPhone)",
                "Your iPhone, signed in to iCloud",
                "A watch cellular plan if you want calls and texts away from home",
            ])

            group("1. Pair the watch", [
                "Open the Apple Watch app on your iPhone.",
                "For a child without their own iPhone, choose Set Up for a Family Member (Family Setup).",
                "Follow the steps to pair it to your child.",
            ])

            group("2. Install this app on the watch", [
                "On the watch, open the App Store and search for Idrees Big Boy Watch (with Ask to Buy, approve it on your phone).",
            ])

            group("3. Link the watch", [
                "In this app, open Home → Watch code.",
                "On the watch, open the app, tap Link to parent's phone and type the code.",
                "The watch picks up the settings you chose here, and his progress shows under His week.",
                "Adjust chores, schedule, contacts and more any time from this app.",
            ])

            Text("Everything on the watch works offline. Only calls and texts need a cellular signal.")
                .font(.footnote).foregroundStyle(.secondary)
        }
    }

    private func group(_ title: String, _ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                    Text(item)
                }
                .font(.callout)
            }
        }
    }
}

struct HelpView: View {
    var body: some View {
        ScrollView {
            WatchSetupGuide().padding()
        }
        .navigationTitle("Set up the watch")
    }
}
