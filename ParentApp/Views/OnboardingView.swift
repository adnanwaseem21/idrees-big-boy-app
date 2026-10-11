import SwiftUI

/// First-run setup a parent walks through after downloading the app:
/// name the child, choose features, add contacts, then install on the watch.
struct OnboardingView: View {
    @EnvironmentObject private var store: SettingsStore
    @State private var step = 0

    private let lastStep = 4

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: Double(step + 1), total: Double(lastStep + 1))
                .padding()

            TabView(selection: $step) {
                welcome.tag(0)
                childStep.tag(1)
                featuresStep.tag(2)
                contactsStep.tag(3)
                watchStep.tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.default, value: step)

            controls
                .padding()
        }
    }

    // MARK: Steps

    private var welcome: some View {
        stepScroll {
            Text(Brand.appName).font(.largeTitle.bold())
            Text("Let's set up your child's watch")
                .font(.title3).foregroundStyle(.secondary)
            bullet("✅", "Chores, routines and rewards")
            bullet("📞", "Call and message you with one tap")
            bullet("📅", "Their daily schedule and reminders")
            if store.settings.faithFeaturesOn {
                bullet("🕌", "Prayer times, Qibla and duas")
            }
            bullet("🎮", "Games you can lock during school")
            Text("It all runs on the watch and works without internet. You manage everything from this app.")
                .font(.callout).foregroundStyle(.secondary).padding(.top, 4)
        }
    }

    private var childStep: some View {
        stepScroll {
            Text("What's your child's name?").font(.title2.bold())
            TextField("Name", text: $store.settings.childName)
                .textFieldStyle(.roundedBorder)
                .font(.title3)
            Text("You can change this any time.")
                .font(.footnote).foregroundStyle(.secondary)
        }
    }

    private var featuresStep: some View {
        stepScroll {
            Text("Choose features").font(.title2.bold())
            Toggle(isOn: $store.settings.faithFeaturesOn) {
                VStack(alignment: .leading) {
                    Text("Islamic features")
                    Text("Prayer times, Qibla, duas, adhan")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
            if store.settings.faithFeaturesOn {
                Picker("Prayer times", selection: $store.settings.prayerMethod) {
                    ForEach(PrayerMethods.all) { Text($0.name).tag($0.id) }
                }
                Text("You can fine-tune prayer settings later.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Toggle("Allow games", isOn: $store.settings.gamesEnabled)
                .padding(.top, 4)
        }
    }

    private var contactsStep: some View {
        stepScroll {
            Text("Who can they call?").font(.title2.bold())
            Text("Add the phone numbers your child can reach. Only these contacts can call or text the watch.")
                .font(.callout).foregroundStyle(.secondary)
            ForEach($store.settings.parents) { $parent in
                VStack(spacing: 6) {
                    HStack {
                        TextField("Icon", text: $parent.emoji).frame(width: 40)
                        TextField("Name", text: $parent.name).textFieldStyle(.roundedBorder)
                    }
                    TextField("Phone number", text: $parent.phone)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                }
                .padding(.vertical, 4)
            }
            Button {
                store.settings.parents.append(
                    ParentSetting(id: UUID().uuidString, name: "", emoji: "🙂", phone: ""))
            } label: {
                Label("Add another", systemImage: "plus.circle.fill")
            }
        }
    }

    private var watchStep: some View {
        stepScroll {
            Text("Set up the watch").font(.title2.bold())
            WatchSetupGuide()
        }
    }

    // MARK: Chrome

    private var controls: some View {
        HStack {
            if step > 0 {
                Button("Back") { step -= 1 }
                    .buttonStyle(.bordered)
            }
            Spacer()
            if step < lastStep {
                Button("Next") { step += 1 }
                    .buttonStyle(.borderedProminent)
                    .disabled(step == 1 && store.settings.childName.trimmingCharacters(in: .whitespaces).isEmpty)
            } else {
                Button("Finish") {
                    store.settings.setupComplete = true
                    store.sync()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private func stepScroll<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }

    private func bullet(_ emoji: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(emoji)
            Text(text)
        }
    }
}
