import SwiftUI

/// Lists the games, or a friendly locked message during school / bedtime.
struct GamesView: View {
    var body: some View {
        TimelineView(.everyMinute) { context in
            content(now: context.date)
        }
        .navigationTitle("Games")
    }

    @ViewBuilder
    private func content(now: Date) -> some View {
        if let blackout = GamesGate.activeBlackout(at: now), GamesGate.isEnabled {
            locked(reason: blackout)
        } else {
            List {
                ForEach(FamilyConfig.games) { game in
                    NavigationLink {
                        destination(for: game.kind)
                    } label: {
                        MenuRow(emoji: game.emoji, title: game.title, detail: game.detail)
                    }
                }
            }
        }
    }

    private func locked(reason: TimeWindow) -> some View {
        VStack(spacing: 8) {
            Text("🔒").font(.largeTitle)
            Text("Games are off during \(reason.label.lowercased())")
                .font(.headline)
                .multilineTextAlignment(.center)
            Text("Come back after \(reason.end.label).")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    /// Maps each game to its screen. Add new cases as games are added.
    @ViewBuilder
    private func destination(for kind: GameKind) -> some View {
        switch kind {
        case .snake:
            SnakeView()
        }
    }
}
