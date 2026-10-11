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
                "Build it from the project in Xcode, or install via TestFlight once it's uploaded.",
                "On the paired watch, open the App Store or TestFlight and add it.",
            ])

            group("3. Finish", [
                "The watch picks up the settings you chose here over iCloud.",
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
