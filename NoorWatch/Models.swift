import Foundation

enum Salah: String, CaseIterable, Codable, Identifiable {
    case fajr, dhuhr, asr, maghrib, isha

    var id: String { rawValue }
    var name: String { rawValue.capitalized }

    var arabic: String {
        switch self {
        case .fajr: "الفجر"
        case .dhuhr: "الظهر"
        case .asr: "العصر"
        case .maghrib: "المغرب"
        case .isha: "العشاء"
        }
    }
}

/// A time of day, like 7:10 PM, without a date.
struct ClockTime: Hashable {
    let hour: Int
    let minute: Int

    init(_ hour: Int, _ minute: Int = 0) {
        self.hour = hour
        self.minute = minute
    }

    func on(_ day: Date) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: day) ?? day
    }

    /// Moves the time earlier or later, staying within the same day.
    func shifted(byMinutes delta: Int) -> ClockTime {
        let total = min(max(0, hour * 60 + minute + delta), 23 * 60 + 59)
        return ClockTime(total / 60, total % 60)
    }

    var label: String { on(Date()).formatted(date: .omitted, time: .shortened) }
}

/// Calendar weekday numbers: 1 = Sunday ... 7 = Saturday.
enum Weekdays {
    static let all: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
    static let school: Set<Int> = [2, 3, 4, 5, 6]
    static let weekend: Set<Int> = [1, 7]
}

/// A recurring stretch of the day, e.g. school hours, used to lock games.
/// Handles overnight windows (start later than end, like 9pm–7am).
struct TimeWindow: Identifiable {
    let label: String
    let start: ClockTime
    let end: ClockTime
    var days: Set<Int> = Weekdays.all

    var id: String { "\(label)-\(start.hour)-\(end.hour)" }

    func contains(_ date: Date) -> Bool {
        let cal = Calendar.current
        let minutes = cal.component(.hour, from: date) * 60 + cal.component(.minute, from: date)
        let from = start.hour * 60 + start.minute
        let to = end.hour * 60 + end.minute
        let weekday = cal.component(.weekday, from: date)
        if from <= to {
            return days.contains(weekday) && minutes >= from && minutes < to
        }
        // Overnight window: active late today OR early the "next" day.
        let yesterday = weekday == 1 ? 7 : weekday - 1
        return (days.contains(weekday) && minutes >= from)
            || (days.contains(yesterday) && minutes < to)
    }
}

enum TaskKind: String, Codable {
    case chore, activity
}

struct TaskItem: Identifiable {
    let id: String
    let title: String
    let emoji: String
    let kind: TaskKind
    var points: Int = 5
    var reminder: ClockTime? = nil
    var days: Set<Int> = Weekdays.all

    func isScheduled(on date: Date) -> Bool {
        days.contains(Calendar.current.component(.weekday, from: date))
    }
}

struct ScheduleItem: Identifiable {
    let title: String
    let emoji: String
    let time: ClockTime
    var days: Set<Int> = Weekdays.all
    var remindMinutesBefore: Int = 5

    var id: String { "\(title)-\(time.hour)-\(time.minute)" }
}

struct Parent: Identifiable {
    let name: String
    let emoji: String
    let phone: String

    var id: String { name }
    /// The phone number with spaces and dashes removed, for tel: and sms: links.
    var dialable: String { phone.filter { $0.isNumber || $0 == "+" } }
}

struct Reward: Identifiable {
    let title: String
    let emoji: String
    let cost: Int

    var id: String { title }
}

/// Everything that happened on one day, saved on the watch.
struct DayLog: Codable {
    var prayed: Set<Salah> = []
    var doneTasks: Set<String> = []
    var tasbih: Int = 0
    var points: Int = 0
}

struct WeekSummary {
    struct Day: Identifiable {
        let date: Date
        let log: DayLog
        let tasksPossible: Int

        var id: Date { date }
        var allPrayers: Bool { log.prayed.count == Salah.allCases.count }
    }

    /// Oldest first.
    let days: [Day]

    var prayersDone: Int { days.reduce(0) { $0 + $1.log.prayed.count } }
    var prayersPossible: Int { days.count * Salah.allCases.count }
    var fullPrayerDays: Int { days.filter(\.allPrayers).count }
    var tasksDone: Int { days.reduce(0) { $0 + $1.log.doneTasks.count } }
    var tasksPossible: Int { days.reduce(0) { $0 + $1.tasksPossible } }
    var points: Int { days.reduce(0) { $0 + $1.log.points } }
    var dhikr: Int { days.reduce(0) { $0 + $1.log.tasbih } }
    var bestDay: Day? { days.filter { $0.log.points > 0 }.max { $0.log.points < $1.log.points } }

    var headline: String {
        let ratio = prayersPossible == 0 ? 0 : Double(prayersDone) / Double(prayersPossible)
        switch ratio {
        case 0.9...: return "MashaAllah, amazing week! 🌟"
        case 0.7..<0.9: return "Great job! Keep it up 💪"
        case 0.4..<0.7: return "Good effort. Let's aim higher next week!"
        default: return "New week, fresh start. You can do it! 🌱"
        }
    }
}
