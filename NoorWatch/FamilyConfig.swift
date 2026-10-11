import Foundation
import Adhan

/// The watch reads its settings through here. Values come live from the
/// family's iCloud (written by the parent app), falling back to sensible
/// defaults before anything syncs. Property names and types are unchanged, so
/// the rest of the watch code stays the same whether settings are hard-coded
/// or synced.
enum FamilyConfig {
    private static var s: FamilySettings { LiveSettings.shared.current }

    static var childName: String { s.childName }
    static var faithFeaturesOn: Bool { s.faithFeaturesOn }

    // MARK: Parents & messages

    static var parents: [Parent] {
        s.parents.map { Parent(name: $0.name, emoji: $0.emoji, phone: $0.phone) }
    }
    static var quickMessages: [String] { s.quickMessages.map(\.text) }

    // MARK: Prayer

    static var calculationMethod: CalculationMethod {
        switch s.prayerMethod {
        case "muslimWorldLeague": .muslimWorldLeague
        case "ummAlQura": .ummAlQura
        case "egyptian": .egyptian
        case "karachi": .karachi
        case "moonsightingCommittee": .moonsightingCommittee
        default: .northAmerica
        }
    }
    static var madhab: Madhab { s.madhab == "hanafi" ? .hanafi : .shafi }
    /// When the parent turns the adhan on, the watch looks for "adhan.caf" in
    /// the bundle; add that file to play it, otherwise it uses the chime.
    static var prayerSoundFile: String? { s.adhanOn ? "adhan.caf" : nil }
    static var fallbackLatitude: Double { s.homeLatitude }
    static var fallbackLongitude: Double { s.homeLongitude }
    static var pointsPerPrayer: Int { s.pointsPerPrayer }

    // MARK: Chores, activities, schedule, rewards

    static var tasks: [TaskItem] {
        s.tasks.map { t in
            TaskItem(id: t.id, title: t.title, emoji: t.emoji,
                     kind: TaskKind(rawValue: t.kind) ?? .activity,
                     points: t.points,
                     reminder: t.reminderHour.map { ClockTime($0, t.reminderMinute) },
                     days: Set(t.days))
        }
    }

    static var schedule: [ScheduleItem] {
        s.schedule.map { e in
            ScheduleItem(title: e.title, emoji: e.emoji, time: ClockTime(e.hour, e.minute),
                         days: Set(e.days), remindMinutesBefore: e.remindBefore)
        }
    }

    static var rewards: [Reward] {
        s.rewards.map { Reward(title: $0.title, emoji: $0.emoji, cost: $0.cost) }
    }

    // MARK: Games

    static var gamesEnabled: Bool { s.gamesEnabled }

    static var gameBlackouts: [TimeWindow] {
        s.blackouts.map {
            TimeWindow(label: $0.label,
                       start: ClockTime($0.startHour, $0.startMinute),
                       end: ClockTime($0.endHour, $0.endMinute),
                       days: Set($0.days))
        }
    }

    static var games: [GameItem] {
        s.games.compactMap { g in
            guard g.enabled, let kind = GameKind(rawValue: g.id) else { return nil }
            return GameItem(id: g.id, title: g.title, emoji: g.emoji, kind: kind)
        }
    }
}
