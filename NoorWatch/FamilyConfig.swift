import Foundation
import Adhan

/// Everything a parent would change lives in this file. Edit it, then press
/// Run in Xcode again to put the new version on the watch.
enum FamilyConfig {
    static let childName = "Idrees"

    // MARK: Parents

    static let parents: [Parent] = [
        Parent(name: "Mom", emoji: "👩", phone: "+1 555 555 0100"),
        Parent(name: "Dad", emoji: "👨", phone: "+1 555 555 0101"),
    ]

    static let quickMessages = [
        "Please pick me up",
        "I'm OK 👍",
        "I'm running late",
        "I got to school",
        "I love you ❤️",
    ]

    // MARK: Prayer

    /// .northAmerica is ISNA. Others: .muslimWorldLeague, .ummAlQura,
    /// .egyptian, .karachi, .moonsightingCommittee
    static let calculationMethod: CalculationMethod = .northAmerica
    /// .shafi is the standard (earlier) Asr, .hanafi the later one.
    static let madhab: Madhab = .shafi
    /// File name of an adhan sound added to the project (e.g. "adhan.caf",
    /// under 30 seconds). nil plays the normal chime, which suits school.
    static let prayerSoundFile: String? = nil
    /// Used until the watch gets its first location fix (Paterson, NJ).
    static let fallbackLatitude = 40.9168
    static let fallbackLongitude = -74.1718
    static let pointsPerPrayer = 10

    // MARK: Chores and daily activities
    // Weekdays: 1 = Sunday ... 7 = Saturday. A reminder pops up at that time.

    static let tasks: [TaskItem] = [
        TaskItem(id: "bed", title: "Make your bed", emoji: "🛏️", kind: .chore, points: 5, reminder: ClockTime(7, 10)),
        TaskItem(id: "teeth-am", title: "Brush teeth (morning)", emoji: "🪥", kind: .chore, points: 5),
        TaskItem(id: "table", title: "Help set the table", emoji: "🍽️", kind: .chore, points: 5),
        TaskItem(id: "room", title: "Tidy your room", emoji: "🧹", kind: .chore, points: 10, reminder: ClockTime(11), days: Weekdays.weekend),
        TaskItem(id: "bag", title: "Pack school bag", emoji: "🎒", kind: .chore, points: 5, reminder: ClockTime(20), days: [1, 2, 3, 4, 5]),
        TaskItem(id: "teeth-pm", title: "Brush teeth (night)", emoji: "🪥", kind: .chore, points: 5, reminder: ClockTime(20, 45)),

        TaskItem(id: "quran", title: "Quran practice (10 min)", emoji: "📖", kind: .activity, points: 10, reminder: ClockTime(17, 30)),
        TaskItem(id: "homework", title: "Homework", emoji: "✏️", kind: .activity, points: 10, days: Weekdays.school),
        TaskItem(id: "read", title: "Read a book (20 min)", emoji: "📚", kind: .activity, points: 10),
        // Karate is on weekends for now. If a week changes, just tick it off
        // on the day it actually happens, or edit the days here.
        TaskItem(id: "karate", title: "Karate practice", emoji: "🥋", kind: .activity, points: 10, reminder: ClockTime(10, 30), days: Weekdays.weekend),
        TaskItem(id: "outside", title: "Play outside", emoji: "⚽", kind: .activity, points: 5),
        TaskItem(id: "freeplay", title: "Free play / build something", emoji: "🧩", kind: .activity, points: 5),
        TaskItem(id: "duas", title: "Morning & evening duas", emoji: "🤲", kind: .activity, points: 5),
        TaskItem(id: "kind", title: "Do a kind deed", emoji: "💚", kind: .activity, points: 10),
    ]

    // MARK: Weekly schedule (reminder comes a few minutes before)

    static let schedule: [ScheduleItem] = [
        ScheduleItem(title: "School", emoji: "🏫", time: ClockTime(8), days: Weekdays.school, remindMinutesBefore: 15),
        ScheduleItem(title: "Quran class", emoji: "📖", time: ClockTime(10), days: Weekdays.weekend, remindMinutesBefore: 15),
        ScheduleItem(title: "Karate", emoji: "🥋", time: ClockTime(11), days: Weekdays.weekend, remindMinutesBefore: 20),
        ScheduleItem(title: "Dinner", emoji: "🍲", time: ClockTime(18, 30)),
        ScheduleItem(title: "Bedtime", emoji: "🌙", time: ClockTime(21)),
    ]

    // MARK: Rewards

    static let rewards: [Reward] = [
        Reward(title: "Ice cream trip", emoji: "🍦", cost: 100),
        Reward(title: "30 min extra game time", emoji: "🎮", cost: 150),
        Reward(title: "Pick what's for dinner", emoji: "🍕", cost: 250),
        Reward(title: "A new book or toy", emoji: "🎁", cost: 500),
    ]

    // MARK: Games
    // The parent controls whether games show at all, and when they're locked.
    // (In the version 2 parent app these become toggles on your phone.)

    /// Master switch. Set to false to hide the Games section completely.
    static let gamesEnabled = true

    /// Windows when games are locked, even if enabled — e.g. school hours and
    /// bedtime. Add or edit windows freely. Outside these, games are playable.
    static let gameBlackouts: [TimeWindow] = [
        TimeWindow(label: "School", start: ClockTime(8), end: ClockTime(15), days: Weekdays.school),
        TimeWindow(label: "Bedtime", start: ClockTime(21), end: ClockTime(7), days: Weekdays.all),
    ]

    /// The games on the watch. Add a new case to GameKind and a new row here to
    /// grow the arcade later — the Games screen picks them up automatically.
    static let games: [GameItem] = [
        GameItem(id: "snake", title: "Snake", emoji: "🐍", detail: "The classic game", kind: .snake),
    ]
}
