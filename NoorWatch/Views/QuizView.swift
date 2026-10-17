import SwiftUI

struct QuizQuestion {
    let question: String
    let options: [String]
    let correct: Int
}

/// A friendly Islamic quiz for kids. Offline. Please review the questions and
/// answers with your family.
enum QuizContent {
    static let questions: [QuizQuestion] = [
        QuizQuestion(question: "How many daily prayers are there?", options: ["3", "5", "7"], correct: 1),
        QuizQuestion(question: "Which is the first surah of the Quran?", options: ["Al-Ikhlas", "Al-Fatihah", "An-Nas"], correct: 1),
        QuizQuestion(question: "In which month do Muslims fast?", options: ["Ramadan", "Shawwal", "Rajab"], correct: 0),
        QuizQuestion(question: "Which direction do we face to pray?", options: ["The Kaaba", "The sun", "North"], correct: 0),
        QuizQuestion(question: "What do we say before eating?", options: ["Ameen", "Bismillah", "Alhamdulillah"], correct: 1),
        QuizQuestion(question: "Who was the last Prophet?", options: ["Musa ﷺ", "Isa ﷺ", "Muhammad ﷺ"], correct: 2),
        QuizQuestion(question: "How many days are in the week of good deeds? (every day!)", options: ["1", "7", "3"], correct: 1),
        QuizQuestion(question: "What do we say when something good happens?", options: ["Astaghfirullah", "Alhamdulillah", "InshaAllah"], correct: 1),
    ]
}

struct QuizView: View {
    @State private var index = 0
    @State private var score = 0
    @State private var chosen: Int?
    @State private var finished = false

    private var questions: [QuizQuestion] { QuizContent.questions }

    var body: some View {
        ScrollView {
            if finished {
                VStack(spacing: 8) {
                    Text("🎉").font(.largeTitle)
                    Text("You got \(score) of \(questions.count)!")
                        .font(.headline)
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { next() }
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
        index = 0
        score = 0
        chosen = nil
        finished = false
    }
}
