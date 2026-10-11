import SwiftUI

struct DuaView: View {
    var body: some View {
        let today = IslamicContent.duaOfTheDay()
        List {
            Section("Dua of the day") {
                NavigationLink { DuaDetailView(dua: today) } label: {
                    MenuRow(emoji: today.emoji, title: today.occasion, detail: today.transliteration)
                }
            }
            Section("All duas") {
                ForEach(IslamicContent.duas) { dua in
                    NavigationLink { DuaDetailView(dua: dua) } label: {
                        MenuRow(emoji: dua.emoji, title: dua.occasion)
                    }
                }
            }
            Section {
                NavigationLink { TasbihView() } label: {
                    MenuRow(emoji: "📿", title: "Tasbih counter")
                }
            }
        }
        .navigationTitle("Dua & Dhikr")
    }
}

struct DuaDetailView: View {
    let dua: Dua

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text(dua.arabic)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(dua.transliteration)
                    .italic()
                Text(dua.meaning)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(dua.source)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .navigationTitle(dua.occasion)
    }
}

struct TasbihView: View {
    @EnvironmentObject private var store: KidStore
    @State private var count = 0

    /// The current phrase and how many of it are done, or nil when finished.
    private var current: (step: DhikrStep, done: Int)? {
        var remaining = count
        for step in IslamicContent.tasbih {
            if remaining < step.count { return (step, remaining) }
            remaining -= step.count
        }
        return nil
    }

    var body: some View {
        VStack(spacing: 6) {
            if let current {
                Text(current.step.arabic)
                    .font(.title3)
                Text(current.step.transliteration)
                    .font(.caption)
                Button(action: tap) {
                    Text("\(current.done) / \(current.step.count)")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, minHeight: 70)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            } else {
                Text("MashaAllah! 🌟")
                    .font(.title3)
                Text("You finished your tasbih.")
                    .font(.caption)
                Button("Start again") { count = 0 }
            }
        }
        .navigationTitle("Tasbih")
    }

    private func tap() {
        count += 1
        store.addTasbih()
        // A stronger buzz when moving to the next phrase or finishing.
        if current == nil || current?.done == 0 { Haptics.success() } else { Haptics.tap() }
    }
}
