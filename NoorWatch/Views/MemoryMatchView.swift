import SwiftUI

/// A simple memory match game: flip cards, find the pairs. Fully offline.
@MainActor
final class MemoryGame: ObservableObject {
    struct Card: Identifiable {
        let id = UUID()
        let symbol: String
        var faceUp = false
        var matched = false
    }

    @Published var cards: [Card] = []
    @Published var moves = 0
    @Published var won = false

    private var firstIndex: Int?
    private let symbols = ["🌙", "⭐", "🕌", "📖", "🤲", "🐫"]

    func start() {
        won = false
        moves = 0
        firstIndex = nil
        cards = (symbols + symbols)
            .map { Card(symbol: $0) }
            .shuffled()
    }

    func tap(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }),
              !cards[index].faceUp, !cards[index].matched else { return }

        cards[index].faceUp = true

        if let first = firstIndex {
            moves += 1
            if cards[first].symbol == cards[index].symbol {
                cards[first].matched = true
                cards[index].matched = true
                Haptics.success()
                if cards.allSatisfy(\.matched) { won = true }
            } else {
                let a = first, b = index
                Haptics.tap()
                // Flip both back after a short pause.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                    guard let self else { return }
                    self.cards[a].faceUp = false
                    self.cards[b].faceUp = false
                }
            }
            firstIndex = nil
        } else {
            firstIndex = index
        }
    }
}

struct MemoryMatchView: View {
    @StateObject private var game = MemoryGame()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Moves \(game.moves)").font(.caption2)
                Spacer()
                Button("New") { game.start() }.font(.caption2)
            }
            if game.won {
                Text("MashaAllah! You won 🎉")
                    .font(.headline)
                    .foregroundStyle(.green)
            }
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(game.cards) { card in
                    Button { game.tap(card) } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(card.matched ? Color.green.opacity(0.3) : Color.green.opacity(0.85))
                            if card.faceUp || card.matched {
                                Text(card.symbol).font(.title3)
                            } else {
                                Text("?").font(.headline).foregroundStyle(.white)
                            }
                        }
                        .frame(height: 40)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 2)
        .navigationTitle("Memory")
        .onAppear { if game.cards.isEmpty { game.start() } }
    }
}
