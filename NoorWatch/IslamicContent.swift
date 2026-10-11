import Foundation

struct Dua: Identifiable {
    let occasion: String
    let emoji: String
    let arabic: String
    let transliteration: String
    let meaning: String
    let source: String

    var id: String { occasion }
}

struct DhikrStep {
    let arabic: String
    let transliteration: String
    let meaning: String
    let count: Int
}

/// Stored in the app, so it all works offline. Please review the wording
/// with your family's preferred translation before giving him the watch.
enum IslamicContent {
    static let duas: [Dua] = [
        Dua(occasion: "Waking up", emoji: "🌅",
            arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
            transliteration: "Alhamdu lillahil-ladhi ahyana ba'da ma amatana wa ilayhin-nushur",
            meaning: "All praise is for Allah, who gave us life after causing us to die, and to Him is the return.",
            source: "Bukhari"),
        Dua(occasion: "Before eating", emoji: "🍽️",
            arabic: "بِسْمِ اللَّهِ",
            transliteration: "Bismillah",
            meaning: "In the name of Allah.",
            source: "Abu Dawud, Tirmidhi"),
        Dua(occasion: "After eating", emoji: "😋",
            arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ",
            transliteration: "Alhamdu lillahil-ladhi at'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah",
            meaning: "All praise is for Allah, who fed me this and provided it for me without any might or power from me.",
            source: "Abu Dawud, Tirmidhi"),
        Dua(occasion: "Leaving home", emoji: "🚪",
            arabic: "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
            transliteration: "Bismillah, tawakkaltu 'alallah, wa la hawla wa la quwwata illa billah",
            meaning: "In the name of Allah. I trust in Allah. There is no might and no power except with Allah.",
            source: "Abu Dawud, Tirmidhi"),
        Dua(occasion: "Before studying", emoji: "📚",
            arabic: "رَبِّ زِدْنِي عِلْمًا",
            transliteration: "Rabbi zidni 'ilma",
            meaning: "My Lord, increase me in knowledge.",
            source: "Quran 20:114"),
        Dua(occasion: "For parents", emoji: "👨‍👩‍👦",
            arabic: "رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا",
            transliteration: "Rabbir-hamhuma kama rabbayani saghira",
            meaning: "My Lord, have mercy on them, as they raised me when I was small.",
            source: "Quran 17:24"),
        Dua(occasion: "Good in both worlds", emoji: "🌍",
            arabic: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
            transliteration: "Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina 'adhaban-nar",
            meaning: "Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.",
            source: "Quran 2:201"),
        Dua(occasion: "Before sleeping", emoji: "🌙",
            arabic: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
            transliteration: "Bismika Allahumma amutu wa ahya",
            meaning: "In Your name, O Allah, I die and I live.",
            source: "Bukhari"),
    ]

    /// After-prayer tasbih: 33 + 33 + 34.
    static let tasbih: [DhikrStep] = [
        DhikrStep(arabic: "سُبْحَانَ اللَّهِ", transliteration: "SubhanAllah", meaning: "Glory be to Allah", count: 33),
        DhikrStep(arabic: "الْحَمْدُ لِلَّهِ", transliteration: "Alhamdulillah", meaning: "All praise is for Allah", count: 33),
        DhikrStep(arabic: "اللَّهُ أَكْبَرُ", transliteration: "Allahu Akbar", meaning: "Allah is the Greatest", count: 34),
    ]

    static func duaOfTheDay(_ date: Date = Date()) -> Dua {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return duas[day % duas.count]
    }
}
