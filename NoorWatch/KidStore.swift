import Foundation
import Combine

/// Saves prayers, chores, activities and points in a file on the watch,
/// so everything works without internet.
@MainActor
final class KidStore: ObservableObject {
    @Published private(set) var logs: [String: DayLog] = [:]
    @Published private(set) var spentPoints = 0

    private struct Saved: Codable {
        var logs: [String: DayLog]
        var spentPoints: Int
    }

    private let fileURL = URL.documentsDirectory.appending(path: "noor-state.json")

    init() {
        if let data = try? Data(contentsOf: fileURL),
           let saved = try? JSONDecoder().decode(Saved.self, from: data) {
            logs = saved.logs
            spentPoints = saved.spentPoints
        }
    }

    // MARK: Reading

    func log(for date: Date = Date()) -> DayLog {
        logs[Self.key(for: date)] ?? DayLog()
    }

    func tasks(on date: Date = Date(), kind: TaskKind? = nil) -> [TaskItem] {
        FamilyConfig.tasks.filter { $0.isScheduled(on: date) && (kind == nil || $0.kind == kind) }
    }

    func isDone(_ task: TaskItem) -> Bool {
        log().doneTasks.contains(task.id)
    }

    var totalPoints: Int {
        logs.values.reduce(0) { $0 + $1.points } - spentPoints
    }

    /// Days in a row with all five prayers. Today counts once it is complete,
    /// so an unfinished today never breaks the streak.
    var prayerStreak: Int {
        let calendar = Calendar.current
        var day = Date()
        if log(for: day).prayed.count < Salah.allCases.count {
            day = calendar.date(byAdding: .day, value: -1, to: day) ?? day
        }
        var streak = 0
        while log(for: day).prayed.count == Salah.allCases.count {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return streak
    }

    /// The seven days ending on `end`.
    func weekSummary(endingOn end: Date) -> WeekSummary {
        let calendar = Calendar.current
        let last = calendar.startOfDay(for: end)
        let days = (0..<7).reversed().compactMap { offset -> WeekSummary.Day? in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: last) else { return nil }
            return WeekSummary.Day(date: date, log: log(for: date), tasksPossible: tasks(on: date).count)
        }
        return WeekSummary(days: days)
    }

    // MARK: Changing

    func togglePrayer(_ salah: Salah) {
        updateToday { day in
            if day.prayed.remove(salah) != nil {
                day.points -= FamilyConfig.pointsPerPrayer
            } else {
                day.prayed.insert(salah)
                day.points += FamilyConfig.pointsPerPrayer
            }
        }
    }

    func toggleTask(_ task: TaskItem) {
        updateToday { day in
            if day.doneTasks.remove(task.id) != nil {
                day.points -= task.points
            } else {
                day.doneTasks.insert(task.id)
                day.points += task.points
            }
        }
    }

    func addTasbih() {
        updateToday { $0.tasbih += 1 }
    }

    @discardableResult
    func redeem(_ reward: Reward) -> Bool {
        guard totalPoints >= reward.cost else { return false }
        spentPoints += reward.cost
        save()
        return true
    }

    // MARK: Saving

    private func updateToday(_ change: (inout DayLog) -> Void) {
        let key = Self.key(for: Date())
        var day = logs[key] ?? DayLog()
        change(&day)
        logs[key] = day
        save()
    }

    private func save() {
        let saved = Saved(logs: logs, spentPoints: spentPoints)
        if let data = try? JSONEncoder().encode(saved) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    private static func key(for date: Date) -> String {
        let parts = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", parts.year ?? 0, parts.month ?? 0, parts.day ?? 0)
    }
}
