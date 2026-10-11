import Foundation

/// Every game the watch knows how to open. To add a game later:
///   1. Add a case here.
///   2. Build its SwiftUI view.
///   3. Map the case to that view in GamesView.destination(for:).
///   4. Add a GameItem row in FamilyConfig.games.
enum GameKind: String, Codable {
    case snake
    // case memory
    // case tapRace
}

struct GameItem: Identifiable {
    let id: String
    let title: String
    let emoji: String
    var detail: String = ""
    let kind: GameKind
}

/// Decides whether games are open right now, and why not when they're closed.
@MainActor
enum GamesGate {
    static var isEnabled: Bool { FamilyConfig.gamesEnabled }

    /// The blackout window active right now, if any (school, bedtime…).
    static func activeBlackout(at date: Date = Date()) -> TimeWindow? {
        FamilyConfig.gameBlackouts.first { $0.contains(date) }
    }

    static func isOpen(at date: Date = Date()) -> Bool {
        isEnabled && activeBlackout(at: date) == nil
    }
}
