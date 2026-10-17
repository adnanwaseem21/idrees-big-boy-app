import Foundation

struct Ayah: Identifiable {
    let number: Int
    let arabic: String
    let transliteration: String
    let english: String
    var id: Int { number }
}

struct Surah: Identifiable {
    let number: Int
    let name: String          // English name
    let arabicName: String
    let meaning: String
    let ayahs: [Ayah]
    var id: Int { number }
}

/// A beginner selection of short surahs (from Juz Amma and Al-Fatihah), the
/// ones kids usually memorize first. Stored in the app, so it works offline.
/// Please check the Arabic and translations against your family's preferred
/// mushaf before giving the watch to your child.
enum QuranContent {
    static let surahs: [Surah] = [
        Surah(number: 1, name: "Al-Fatihah", arabicName: "الفاتحة", meaning: "The Opening", ayahs: [
            Ayah(number: 1, arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", transliteration: "Bismillahir-Rahmanir-Rahim", english: "In the name of Allah, the Most Gracious, the Most Merciful."),
            Ayah(number: 2, arabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", transliteration: "Alhamdu lillahi Rabbil-'alamin", english: "All praise is for Allah, Lord of all the worlds."),
            Ayah(number: 3, arabic: "الرَّحْمَٰنِ الرَّحِيمِ", transliteration: "Ar-Rahmanir-Rahim", english: "The Most Gracious, the Most Merciful."),
            Ayah(number: 4, arabic: "مَالِكِ يَوْمِ الدِّينِ", transliteration: "Maliki yawmid-din", english: "Master of the Day of Judgment."),
            Ayah(number: 5, arabic: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", transliteration: "Iyyaka na'budu wa iyyaka nasta'in", english: "You alone we worship, and You alone we ask for help."),
            Ayah(number: 6, arabic: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ", transliteration: "Ihdinas-siratal-mustaqim", english: "Guide us to the straight path."),
            Ayah(number: 7, arabic: "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ", transliteration: "Siratal-ladhina an'amta 'alayhim, ghayril-maghdubi 'alayhim wa lad-dallin", english: "The path of those You have blessed, not of those who earned Your anger, nor of those who went astray."),
        ]),
        Surah(number: 112, name: "Al-Ikhlas", arabicName: "الإخلاص", meaning: "Sincerity", ayahs: [
            Ayah(number: 1, arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ", transliteration: "Qul huwa Allahu ahad", english: "Say, He is Allah, the One."),
            Ayah(number: 2, arabic: "اللَّهُ الصَّمَدُ", transliteration: "Allahus-samad", english: "Allah, the Eternal, the Absolute."),
            Ayah(number: 3, arabic: "لَمْ يَلِدْ وَلَمْ يُولَدْ", transliteration: "Lam yalid wa lam yulad", english: "He does not give birth, nor was He born."),
            Ayah(number: 4, arabic: "وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ", transliteration: "Wa lam yakun lahu kufuwan ahad", english: "And there is none comparable to Him."),
        ]),
        Surah(number: 113, name: "Al-Falaq", arabicName: "الفلق", meaning: "The Daybreak", ayahs: [
            Ayah(number: 1, arabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ", transliteration: "Qul a'udhu bi Rabbil-falaq", english: "Say, I seek refuge in the Lord of daybreak."),
            Ayah(number: 2, arabic: "مِن شَرِّ مَا خَلَقَ", transliteration: "Min sharri ma khalaq", english: "From the evil of what He created."),
            Ayah(number: 3, arabic: "وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ", transliteration: "Wa min sharri ghasiqin idha waqab", english: "And from the evil of darkness when it settles."),
            Ayah(number: 4, arabic: "وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ", transliteration: "Wa min sharrin-naffathati fil-'uqad", english: "And from the evil of those who blow on knots."),
            Ayah(number: 5, arabic: "وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ", transliteration: "Wa min sharri hasidin idha hasad", english: "And from the evil of the envier when he envies."),
        ]),
        Surah(number: 114, name: "An-Nas", arabicName: "الناس", meaning: "Mankind", ayahs: [
            Ayah(number: 1, arabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ", transliteration: "Qul a'udhu bi Rabbin-nas", english: "Say, I seek refuge in the Lord of mankind."),
            Ayah(number: 2, arabic: "مَلِكِ النَّاسِ", transliteration: "Malikin-nas", english: "The King of mankind."),
            Ayah(number: 3, arabic: "إِلَٰهِ النَّاسِ", transliteration: "Ilahin-nas", english: "The God of mankind."),
            Ayah(number: 4, arabic: "مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ", transliteration: "Min sharril-waswasil-khannas", english: "From the evil of the retreating whisperer."),
            Ayah(number: 5, arabic: "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ", transliteration: "Alladhi yuwaswisu fi sudurin-nas", english: "Who whispers into the hearts of mankind."),
            Ayah(number: 6, arabic: "مِنَ الْجِنَّةِ وَالنَّاسِ", transliteration: "Minal-jinnati wan-nas", english: "From among jinn and mankind."),
        ]),
        Surah(number: 103, name: "Al-Asr", arabicName: "العصر", meaning: "Time", ayahs: [
            Ayah(number: 1, arabic: "وَالْعَصْرِ", transliteration: "Wal-'asr", english: "By time."),
            Ayah(number: 2, arabic: "إِنَّ الْإِنسَانَ لَفِي خُسْرٍ", transliteration: "Innal-insana lafi khusr", english: "Indeed, mankind is in loss."),
            Ayah(number: 3, arabic: "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ", transliteration: "Illal-ladhina amanu wa 'amilus-salihati wa tawasaw bil-haqqi wa tawasaw bis-sabr", english: "Except those who believe, do good deeds, and encourage one another to truth and to patience."),
        ]),
        Surah(number: 108, name: "Al-Kawthar", arabicName: "الكوثر", meaning: "Abundance", ayahs: [
            Ayah(number: 1, arabic: "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ", transliteration: "Inna a'taynakal-kawthar", english: "Indeed, We have granted you al-Kawthar."),
            Ayah(number: 2, arabic: "فَصَلِّ لِرَبِّكَ وَانْحَرْ", transliteration: "Fasalli li Rabbika wanhar", english: "So pray to your Lord and sacrifice."),
            Ayah(number: 3, arabic: "إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ", transliteration: "Inna shani'aka huwal-abtar", english: "Indeed, your enemy is the one cut off."),
        ]),
    ]
}
