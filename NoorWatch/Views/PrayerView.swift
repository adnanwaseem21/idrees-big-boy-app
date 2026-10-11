import SwiftUI

struct PrayerView: View {
    @EnvironmentObject private var store: KidStore
    @EnvironmentObject private var prayers: PrayerService

    var body: some View {
        TimelineView(.everyMinute) { context in
            List {
                if let times = prayers.times(on: context.date) {
                    ForEach(Salah.allCases) { salah in
                        PrayerRow(salah: salah, time: times.time(salah), now: context.date)
                    }
                }
                Section {
                    Text("🔥 \(store.prayerStreak)-day streak of all 5 prayers")
                        .font(.caption)
                    NavigationLink { QiblaView() } label: {
                        MenuRow(emoji: "🧭", title: "Qibla")
                    }
                    NavigationLink { TasbihView() } label: {
                        MenuRow(emoji: "📿", title: "Tasbih after salah")
                    }
                }
            }
        }
        .navigationTitle("Prayer")
    }
}

struct PrayerRow: View {
    @EnvironmentObject private var store: KidStore
    let salah: Salah
    let time: Date
    let now: Date

    var body: some View {
        let prayed = store.log().prayed.contains(salah)
        Button {
            store.togglePrayer(salah)
            if prayed { Haptics.tap() } else { Haptics.success() }
        } label: {
            HStack {
                Image(systemName: prayed ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(prayed ? Color.green : Color.secondary)
                VStack(alignment: .leading) {
                    Text(salah.name)
                        .font(.headline)
                    Text(salah.arabic)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(time, style: .time)
                    .font(.caption)
            }
        }
        // A prayer can be ticked once its time has come in.
        .disabled(time > now && !prayed)
    }
}

struct QiblaView: View {
    @EnvironmentObject private var prayers: PrayerService

    var body: some View {
        VStack(spacing: 8) {
            if let heading = prayers.heading {
                let turn = normalized(prayers.qiblaDirection - heading)
                let facing = turn < 8 || turn > 352
                Image(systemName: "location.north.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(facing ? Color.green : Color.orange)
                    .rotationEffect(.degrees(turn))
                    .animation(.easeOut(duration: 0.2), value: turn)
                Text(facing ? "You're facing the Qibla ✅" : "Turn until the arrow points up")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            } else {
                Text("🧭")
                    .font(.largeTitle)
                Text("Qibla is \(Int(prayers.qiblaDirection))° from North")
                    .font(.caption)
            }
        }
        .navigationTitle("Qibla")
        .onAppear { prayers.startHeading() }
        .onDisappear { prayers.stopHeading() }
    }

    private func normalized(_ degrees: Double) -> Double {
        let value = degrees.truncatingRemainder(dividingBy: 360)
        return value < 0 ? value + 360 : value
    }
}
