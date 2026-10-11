import SwiftUI

/// Turn whole feature sets on or off after setup.
struct FeaturesView: View {
    @EnvironmentObject private var store: SettingsStore

    var body: some View {
        Form {
            Section {
                Toggle(isOn: $store.settings.faithFeaturesOn) {
                    VStack(alignment: .leading) {
                        Text("Islamic features")
                        Text("Prayer times, Qibla, duas, adhan")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
                Toggle("Games", isOn: $store.settings.gamesEnabled)
            } footer: {
                Text("Turning a feature off hides it on your child's watch.")
            }
        }
        .navigationTitle("Features")
    }
}
