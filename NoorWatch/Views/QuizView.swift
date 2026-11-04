import SwiftUI

struct QuizQuestion {
    let question: String
    let options: [String]
    let correct: Int
}

/// An Islamic quiz for kids: 55 questions with 4 answers each. Every round
/// picks 15 at random and shuffles the answers, so it's different each time.
/// Offline. Please review the questions and answers with your family.
/// (In this list the right answer is always written first; it's shuffled
/// before it's shown.)
enum QuizContent {
    static let perRound = 15
    static let questions: [QuizQuestion] = [
        QuizQuestion(question: "How many surahs are in the Quran?", options: ["114", "99", "120", "110"], correct: 0),
        QuizQuestion(question: "Which is the longest surah?", options: ["Al-Baqarah", "Al-Imran", "Yasin", "Al-Kahf"], correct: 0),
        QuizQuestion(question: "Which is the shortest surah?", options: ["Al-Kawthar", "Al-Ikhlas", "An-Nas", "Al-Asr"], correct: 0),
        QuizQuestion(question: "How many ayahs are in Al-Fatihah?", options: ["7", "5", "6", "4"], correct: 0),
        QuizQuestion(question: "Which surah does not start with Bismillah?", options: ["At-Tawbah", "Al-Mulk", "Yasin", "Al-Fatihah"], correct: 0),
        QuizQuestion(question: "Which surah has Bismillah twice?", options: ["An-Naml", "Al-Baqarah", "Maryam", "Yusuf"], correct: 0),
        QuizQuestion(question: "Which surah is named after a woman?", options: ["Maryam", "Al-Kahf", "Yusuf", "Hud"], correct: 0),
        QuizQuestion(question: "Which surah is called 'the heart of the Quran'?", options: ["Yasin", "Al-Fatihah", "Al-Mulk", "Ar-Rahman"], correct: 0),
        QuizQuestion(question: "Which surah repeats 'Which of the favors of your Lord will you deny?'", options: ["Ar-Rahman", "Al-Waqi'ah", "Al-Mulk", "An-Naba"], correct: 0),
        QuizQuestion(question: "Which surah tells the story of the People of the Cave?", options: ["Al-Kahf", "Yusuf", "Maryam", "Al-Anbiya"], correct: 0),
        QuizQuestion(question: "Which surah is about a whole prophet's life story, from a dream to Egypt?", options: ["Yusuf", "Hud", "Ibrahim", "Yunus"], correct: 0),
        QuizQuestion(question: "Al-Ikhlas is said to equal what part of the Quran?", options: ["One third", "One half", "One quarter", "One tenth"], correct: 0),
        QuizQuestion(question: "Which surah protects from the punishment of the grave if read every night?", options: ["Al-Mulk", "Al-Kawthar", "Al-Fil", "Al-Qadr"], correct: 0),
        QuizQuestion(question: "Which surah tells about the army with elephants?", options: ["Al-Fil", "Quraysh", "Al-Adiyat", "Al-Masad"], correct: 0),
        QuizQuestion(question: "Which surah is about Laylat al-Qadr?", options: ["Al-Qadr", "Al-Fajr", "Ad-Duha", "Al-Layl"], correct: 0),
        QuizQuestion(question: "In which month was the Quran first revealed?", options: ["Ramadan", "Muharram", "Rajab", "Dhul-Hijjah"], correct: 0),
        QuizQuestion(question: "Which angel brought the Quran to the Prophet ﷺ?", options: ["Jibreel", "Mikaeel", "Israfeel", "Malik"], correct: 0),
        QuizQuestion(question: "In which cave did the first revelation come?", options: ["Cave Hira", "Cave Thawr", "Cave of Uhud", "Cave of Badr"], correct: 0),
        QuizQuestion(question: "What was the first word revealed?", options: ["Iqra (Read)", "Qul (Say)", "Bismillah", "Alhamdulillah"], correct: 0),
        QuizQuestion(question: "How many juz are in the Quran?", options: ["30", "40", "20", "114"], correct: 0),
        QuizQuestion(question: "Which juz has the most short surahs?", options: ["Juz Amma (30)", "Juz 1", "Juz 15", "Juz 29"], correct: 0),
        QuizQuestion(question: "How many rak'ahs are in Fajr (fard)?", options: ["2", "3", "4", "1"], correct: 0),
        QuizQuestion(question: "How many rak'ahs are in Maghrib (fard)?", options: ["3", "2", "4", "5"], correct: 0),
        QuizQuestion(question: "How many rak'ahs are in Isha (fard)?", options: ["4", "3", "2", "5"], correct: 0),
        QuizQuestion(question: "What is the third pillar of Islam?", options: ["Zakah", "Hajj", "Fasting", "Salah"], correct: 0),
        QuizQuestion(question: "How many pillars of Islam are there?", options: ["5", "6", "4", "7"], correct: 0),
        QuizQuestion(question: "How many pillars of Iman (faith) are there?", options: ["6", "5", "7", "4"], correct: 0),
        QuizQuestion(question: "Which prophet built the Kaaba with his son?", options: ["Ibrahim", "Nuh", "Musa", "Dawud"], correct: 0),
        QuizQuestion(question: "Which son helped Ibrahim build the Kaaba?", options: ["Ismail", "Ishaq", "Yaqub", "Yusuf"], correct: 0),
        QuizQuestion(question: "Which prophet was swallowed by a big fish?", options: ["Yunus", "Yusuf", "Ayyub", "Ilyas"], correct: 0),
        QuizQuestion(question: "Which prophet built the ark?", options: ["Nuh", "Hud", "Salih", "Lut"], correct: 0),
        QuizQuestion(question: "Which prophet could speak with animals and had a huge kingdom?", options: ["Sulayman", "Dawud", "Ibrahim", "Isa"], correct: 0),
        QuizQuestion(question: "Which prophet spoke as a baby in the cradle?", options: ["Isa", "Musa", "Yahya", "Ismail"], correct: 0),
        QuizQuestion(question: "Which prophet is mentioned by name most in the Quran?", options: ["Musa", "Ibrahim", "Isa", "Nuh"], correct: 0),
        QuizQuestion(question: "In which city was the Prophet ﷺ born?", options: ["Makkah", "Madinah", "Taif", "Jerusalem"], correct: 0),
        QuizQuestion(question: "What is the Prophet's ﷺ move to Madinah called?", options: ["The Hijrah", "The Isra", "Hajj", "Umrah"], correct: 0),
        QuizQuestion(question: "Who was the first person to accept Islam?", options: ["Khadijah", "Abu Bakr", "Ali", "Umar"], correct: 0),
        QuizQuestion(question: "Who was the first caliph after the Prophet ﷺ?", options: ["Abu Bakr", "Umar", "Uthman", "Ali"], correct: 0),
        QuizQuestion(question: "Which masjid is the first qibla of Muslims?", options: ["Al-Aqsa", "Al-Haram", "Quba", "An-Nabawi"], correct: 0),
        QuizQuestion(question: "Which was the first masjid built by the Prophet ﷺ?", options: ["Masjid Quba", "Masjid An-Nabawi", "Al-Aqsa", "Masjid Al-Haram"], correct: 0),
        QuizQuestion(question: "What is the night journey to Jerusalem called?", options: ["Al-Isra", "Al-Hijrah", "Al-Qadr", "Al-Fath"], correct: 0),
        QuizQuestion(question: "On which day is Jumu'ah prayer?", options: ["Friday", "Thursday", "Saturday", "Monday"], correct: 0),
        QuizQuestion(question: "Which Eid comes after Ramadan?", options: ["Eid al-Fitr", "Eid al-Adha", "Both", "Neither"], correct: 0),
        QuizQuestion(question: "On which day of Dhul-Hijjah is Eid al-Adha?", options: ["10th", "1st", "9th", "15th"], correct: 0),
        QuizQuestion(question: "What is the day of Arafah?", options: ["9th Dhul-Hijjah", "1st Ramadan", "27th Ramadan", "10th Muharram"], correct: 0),
        QuizQuestion(question: "How much of savings is given as zakah each year?", options: ["2.5%", "10%", "5%", "1%"], correct: 0),
        QuizQuestion(question: "What do we say when we hear someone sneeze and say Alhamdulillah?", options: ["Yarhamukallah", "Bismillah", "Ameen", "SubhanAllah"], correct: 0),
        QuizQuestion(question: "What do we say when we make a mistake?", options: ["Astaghfirullah", "MashaAllah", "Ameen", "Bismillah"], correct: 0),
        QuizQuestion(question: "What does 'InshaAllah' mean?", options: ["If Allah wills", "Thanks to Allah", "Allah is great", "Glory to Allah"], correct: 0),
        QuizQuestion(question: "What does 'SubhanAllah' mean?", options: ["Glory be to Allah", "Allah is the Greatest", "Praise be to Allah", "In the name of Allah"], correct: 0),
        QuizQuestion(question: "What does 'Ar-Rahman' mean?", options: ["The Most Merciful", "The King", "The Creator", "The All-Knowing"], correct: 0),
        QuizQuestion(question: "What is the Arabic word for the bowing in prayer?", options: ["Ruku", "Sujud", "Qiyam", "Tashahhud"], correct: 0),
        QuizQuestion(question: "What is the sitting at the end of prayer called?", options: ["Tashahhud", "Ruku", "Takbir", "Qunut"], correct: 0),
        QuizQuestion(question: "What do we say to start every prayer?", options: ["Allahu Akbar", "Ameen", "Assalamu alaykum", "SubhanAllah"], correct: 0),
        QuizQuestion(question: "How do we finish the prayer?", options: ["Saying salam to both sides", "Saying Ameen", "Standing up", "Clapping hands"], correct: 0),
    ]

    /// A fresh round: random questions, answers in random order.
    static func round() -> [QuizQuestion] {
        questions.shuffled().prefix(perRound).map { q in
            let order = Array(q.options.indices).shuffled()
            return QuizQuestion(question: q.question,
                                options: order.map { q.options[$0] },
                                correct: order.firstIndex(of: q.correct) ?? 0)
        }
    }
}

struct QuizView: View {
    @State private var index = 0
    @State private var score = 0
    @State private var chosen: Int?
    @State private var finished = false

    @State private var questions = QuizContent.round()

    var body: some View {
        ScrollView {
            if finished {
                VStack(spacing: 8) {
                    Text(score >= questions.count * 2 / 3 ? "🎉" : "💪").font(.largeTitle)
                    Text("You got \(score) of \(questions.count)!")
                        .font(.headline)
                    Text(score == questions.count ? "Perfect! MashaAllah 🌟" : score >= questions.count * 2 / 3 ? "Great job!" : "Keep learning, try again!")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Button("Play again") { restart() }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                let q = questions[index]
                VStack(alignment: .leading, spacing: 10) {
                    Text("Question \(index + 1) of \(questions.count)")
                        .font(.caption2).foregroundStyle(.secondary)
                    Text(q.question).font(.headline)
                    ForEach(Array(q.options.enumerated()), id: \.offset) { i, option in
                        Button {
                            guard chosen == nil else { return }
                            chosen = i
                            if i == q.correct { score += 1; Haptics.success() } else { Haptics.tap() }
                            DispatchQueue.main.asyncAfter(deadline: .now() + (i == q.correct ? 0.9 : 1.8)) { next() }
                        } label: {
                            Text(option)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                        .tint(color(for: i, correct: q.correct))
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Quiz")
    }

    private func color(for option: Int, correct: Int) -> Color {
        guard let chosen else { return .gray }
        if option == correct { return .green }
        if option == chosen { return .red }
        return .gray
    }

    private func next() {
        chosen = nil
        if index + 1 < questions.count {
            index += 1
        } else {
            finished = true
        }
    }

    private func restart() {
        questions = QuizContent.round()
        index = 0
        score = 0
        chosen = nil
        finished = false
    }
}
