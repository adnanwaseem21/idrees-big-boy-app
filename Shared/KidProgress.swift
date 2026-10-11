import Foundation
import Combine

/// Idrees's progress, written by the watch and read by the parent app, through
/// the same iCloud key-value store. One entry per day, keyed "yyyy-MM-dd".
/// Shared by both targets.
struct KidProgress: Codable, Equatable {
    var days: [String: DaySummary] = [:]
}

struct DaySummary: Codable, Equatable {
    var prayersCompleted: Int = 0
    var tasksDone: Int = 0
    var tasksTotal: Int = 0
    var points: Int = 0
    var dhikr: Int = 0
}

/// Read-only on the parent side; the watch writes to the same key.
@MainActor
final class ProgressStore: ObservableObject {
    @Published private(set) var progress = KidProgress()

    private let key = "kidProgress"
    private let cloud = NSUbiquitousKeyValueStore.default

    init() {
        reload()
        NotificationCenter.default.addObserver(
            self, selector: #selector(changed),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: cloud)
        cloud.synchronize()
    }

    /// Oldest-first summaries for the seven days ending today.
    func lastWeek() -> [(date: Date, summary: DaySummary)] {
        let cal = Calendar.current
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return (0..<7).reversed().compactMap { offset in
            guard let date = cal.date(byAdding: .day, value: -offset, to: Date()) else { return nil }
            return (date, progress.days[fmt.string(from: date)] ?? DaySummary())
        }
    }

    private func reload() {
        if let data = cloud.data(forKey: key),
           let decoded = try? JSONDecoder().decode(KidProgress.self, from: data) {
            progress = decoded
        }
    }

    @objc private func changed() { reload() }
}
