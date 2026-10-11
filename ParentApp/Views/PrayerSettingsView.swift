import SwiftUI

struct PrayerMethod: Identifiable {
    let id: String      // matches Adhan's CalculationMethod on the watch
    let name: String
}

enum PrayerMethods {
    static let all: [PrayerMethod] = [
        PrayerMethod(id: "northAmerica", name: "ISNA (North America)"),
        PrayerMethod(id: "muslimWorldLeague", name: "Muslim World League"),
        PrayerMethod(id: "ummAlQura", name: "Umm al-Qura (Makkah)"),
        PrayerMethod(id: "egyptian", name: "Egyptian"),
        PrayerMethod(id: "karachi", name: "Karachi"),
        PrayerMethod(id: "moonsightingCommittee", name: "Moonsighting Committee"),
    ]
}

struct PrayerSettingsView: View {
    @EnvironmentObject private var store: SettingsStore

    var body: some View {
        Form {
            Section("Calculation method") {
                Picker("Method", selection: $store.settings.prayerMethod) {
                    ForEach(PrayerMethods.all) { method in
                        Text(method.name).tag(method.id)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }

            Section("Asr") {
                Picker("Asr time", selection: $store.settings.madhab) {
                    Text("Standard (Shafi'i)").tag("shafi")
                    Text("Later (Hanafi)").tag("hanafi")
                }
            }

            Section {
                Toggle("Play adhan at prayer times", isOn: $store.settings.adhanOn)
            } footer: {
                Text("Off plays a gentle chime and vibration, which is better for school.")
            }

            Section("Points") {
                Stepper("\(store.settings.pointsPerPrayer) points per prayer",
                        value: $store.settings.pointsPerPrayer, in: 0...100, step: 5)
            }
        }
        .navigationTitle("Prayer")
    }
}
