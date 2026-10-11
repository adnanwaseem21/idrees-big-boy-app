import Foundation

/// The single source of truth the parent edits on the phone and the watch
/// reads. It's a plain Codable value synced through the family's iCloud, so
/// there's no server and it works offline, catching up when there's signal.
///
/// This file is shared by BOTH targets (the watch app and the parent app).
/// In Xcode, tick both targets under "Target Membership" for every file in
/// this Shared/ folder.
struct FamilySettings: Codable, Equatable {
    var childName: String

    var parents: [ParentSetting]
    var quickMessages: [QuickMessage]

    var prayerMethod: String          // e.g. "northAmerica", "ummAlQura"
    var madhab: String                // "shafi" or "hanafi"
    var adhanOn: Bool
    var pointsPerPrayer: Int

    // Fallback home location, used for prayer times until the watch gets a
    // GPS fix. Defaults to Paterson, NJ.
    var homeLatitude: Double
    var homeLongitude: Double

    var gamesEnabled: Bool
    var blackouts: [Blackout]
    var games: [GameToggle]

    var tasks: [TaskSetting]
    var schedule: [ScheduleSetting]
    var rewards: [RewardSetting]

    /// Starting values — mirror the watch's original FamilyConfig so nothing
    /// changes until the parent edits something.
    static var defaults: FamilySettings {
        FamilySettings(
            childName: Brand.defaultChildName,
            parents: [
                ParentSetting(id: "mom", name: "Mom", emoji: "👩", phone: "+1 555 555 0100"),
                ParentSetting(id: "dad", name: "Dad", emoji: "👨", phone: "+1 555 555 0101"),
            ],
            quickMessages: [
                QuickMessage(text: "Please pick me up"),
                QuickMessage(text: "I'm OK 👍"),
                QuickMessage(text: "I'm running late"),
                QuickMessage(text: "I got to school"),
                QuickMessage(text: "I love you ❤️"),
            ],
            prayerMethod: "northAmerica",
            madhab: "shafi",
            adhanOn: false,
            pointsPerPrayer: 10,
            homeLatitude: 40.9168,
            homeLongitude: -74.1718,
            gamesEnabled: true,
            blackouts: [
                Blackout(label: "School", startHour: 8, startMinute: 0, endHour: 15, endMinute: 0, days: Weekday.school),
                Blackout(label: "Bedtime", startHour: 21, startMinute: 0, endHour: 7, endMinute: 0, days: Weekday.all),
            ],
            games: [
                GameToggle(id: "snake", title: "Snake", emoji: "🐍", enabled: true),
            ],
            tasks: [
                TaskSetting(id: "bed", title: "Make your bed", emoji: "🛏️", kind: "chore", points: 5, reminderHour: 7, reminderMinute: 10, days: Weekday.all),
                TaskSetting(id: "teeth-am", title: "Brush teeth (morning)", emoji: "🪥", kind: "chore", points: 5, days: Weekday.all),
                TaskSetting(id: "bag", title: "Pack school bag", emoji: "🎒", kind: "chore", points: 5, reminderHour: 20, days: [2, 3, 4, 5, 6]),
                TaskSetting(id: "quran", title: "Quran practice (10 min)", emoji: "📖", kind: "activity", points: 10, reminderHour: 17, reminderMinute: 30, days: Weekday.all),
                TaskSetting(id: "homework", title: "Homework", emoji: "✏️", kind: "activity", points: 10, days: Weekday.school),
                TaskSetting(id: "karate", title: "Karate practice", emoji: "🥋", kind: "activity", points: 10, reminderHour: 10, reminderMinute: 30, days: Weekday.weekend),
                TaskSetting(id: "kind", title: "Do a kind deed", emoji: "💚", kind: "activity", points: 10, days: Weekday.all),
            ],
            schedule: [
                ScheduleSetting(id: "school", title: "School", emoji: "🏫", hour: 8, minute: 0, days: Weekday.school, remindBefore: 15),
                ScheduleSetting(id: "karate", title: "Karate", emoji: "🥋", hour: 11, minute: 0, days: Weekday.weekend, remindBefore: 20),
                ScheduleSetting(id: "dinner", title: "Dinner", emoji: "🍲", hour: 18, minute: 30, days: Weekday.all, remindBefore: 5),
                ScheduleSetting(id: "bedtime", title: "Bedtime", emoji: "🌙", hour: 21, minute: 0, days: Weekday.all, remindBefore: 5),
            ],
            rewards: [
                RewardSetting(id: "icecream", title: "Ice cream trip", emoji: "🍦", cost: 100),
                RewardSetting(id: "games", title: "30 min extra game time", emoji: "🎮", cost: 150),
                RewardSetting(id: "dinner", title: "Pick what's for dinner", emoji: "🍕", cost: 250),
                RewardSetting(id: "toy", title: "A new book or toy", emoji: "🎁", cost: 500),
            ]
        )
    }
}

enum Weekday {
    static let all = [1, 2, 3, 4, 5, 6, 7]
    static let school = [2, 3, 4, 5, 6]
    static let weekend = [1, 7]
    static let names = ["S", "M", "T", "W", "T", "F", "S"]   // index 0 = Sunday(1)
}

struct ParentSetting: Codable, Equatable, Identifiable {
    var id: String
    var name: String
    var emoji: String
    var phone: String
}

struct QuickMessage: Codable, Equatable, Identifiable {
    var id = UUID().uuidString
    var text: String
}

struct TaskSetting: Codable, Equatable, Identifiable {
    var id: String
    var title: String
    var emoji: String
    var kind: String                  // "chore" or "activity"
    var points: Int
    var reminderHour: Int? = nil
    var reminderMinute: Int = 0
    var days: [Int] = Weekday.all
}

struct ScheduleSetting: Codable, Equatable, Identifiable {
    var id: String
    var title: String
    var emoji: String
    var hour: Int
    var minute: Int
    var days: [Int] = Weekday.all
    var remindBefore: Int = 5
}

struct Blackout: Codable, Equatable, Identifiable {
    var id = UUID().uuidString
    var label: String
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int
    var days: [Int] = Weekday.all
}

struct GameToggle: Codable, Equatable, Identifiable {
    var id: String
    var title: String
    var emoji: String
    var enabled: Bool
}

struct RewardSetting: Codable, Equatable, Identifiable {
    var id: String
    var title: String
    var emoji: String
    var cost: Int
}
