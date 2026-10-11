import SwiftUI

/// The fallback home location used for prayer times before the watch gets its
/// own GPS fix. Most families can leave this alone.
struct LocationSettingsView: View {
    @EnvironmentObject private var store: SettingsStore

    var body: some View {
        Form {
            Section {
                LabeledContent("Latitude") {
                    TextField("", value: $store.settings.homeLatitude, format: .number.precision(.fractionLength(4)))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numbersAndPunctuation)
                }
                LabeledContent("Longitude") {
                    TextField("", value: $store.settings.homeLongitude, format: .number.precision(.fractionLength(4)))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numbersAndPunctuation)
                }
            } footer: {
                Text("Used only until Idrees's watch gets a location fix, then the watch uses where he actually is. You can find your coordinates in any maps app.")
            }
        }
        .navigationTitle("Home location")
    }
}
