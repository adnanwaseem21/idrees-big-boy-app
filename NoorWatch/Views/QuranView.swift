import SwiftUI

/// Short surahs to read and memorize, with a memorized checklist that works
/// offline. Memorized surahs are remembered on the watch.
struct QuranView: View {
    @State private var memorized = MemorizedStore.load()

    var body: some View {
        List {
            Section {
                Text("📖 \(memorized.count) of \(QuranContent.surahs.count) memorized")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
            ForEach(QuranContent.surahs) { surah in
                NavigationLink {
                    SurahView(surah: surah, memorized: $memorized)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(surah.number). \(surah.name)")
                                .font(.headline)
                            Text(surah.meaning)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if memorized.contains(surah.number) {
                            Image(systemName: "star.fill").foregroundStyle(.yellow)
                        }
                    }
                }
            }
        }
        .navigationTitle("Quran")
    }
}

struct SurahView: View {
    let surah: Surah
    @Binding var memorized: Set<Int>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(surah.arabicName)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text("\(surah.name) · \(surah.meaning)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                ForEach(surah.ayahs) { ayah in
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(ayah.arabic) ﴿\(ayah.number)﴾")
                            .font(.body)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(ayah.transliteration)
                            .font(.caption2)
                            .italic()
                        Text(ayah.english)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Divider()
                }

                Button {
                    if memorized.contains(surah.number) {
                        memorized.remove(surah.number)
                    } else {
                        memorized.insert(surah.number)
                        Haptics.success()
                    }
                    MemorizedStore.save(memorized)
                } label: {
                    Label(memorized.contains(surah.number) ? "Memorized ⭐" : "Mark as memorized",
                          systemImage: memorized.contains(surah.number) ? "star.fill" : "star")
                }
                .tint(.green)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle(surah.name)
    }
}

/// Remembers which surahs are memorized, on the watch.
enum MemorizedStore {
    private static let key = "memorizedSurahs"

    static func load() -> Set<Int> {
        let array = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        return Set(array)
    }

    static func save(_ set: Set<Int>) {
        UserDefaults.standard.set(Array(set), forKey: key)
    }
}
