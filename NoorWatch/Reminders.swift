import Foundation
import UserNotifications

/// Reminders are scheduled on the watch itself, so they fire with no internet.
@MainActor
enum Reminders {
    /// The system keeps at most 64 pending reminders per app.
    private static let maxPending = 64

    static func requestPermission() async {
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
    }

    /// Rebuilds every reminder. Prayer times shift a little each day, so they
    /// are scheduled a week ahead and refilled whenever the app opens.
    static func rescheduleAll(prayers: PrayerService) {
        var requests: [UNNotificationRequest] = []

        for task in FamilyConfig.tasks {
            guard let time = task.reminder else { continue }
            requests += repeating(id: "task-\(task.id)", title: "\(task.emoji) \(task.title)",
                                  body: "Tick it off in Noor when you're done!", time: time, days: task.days)
        }
        for item in FamilyConfig.schedule {
            requests += repeating(id: "schedule-\(item.id)", title: "\(item.emoji) \(item.title)",
                                  body: "Starts at \(item.time.label)",
                                  time: item.time.shifted(byMinutes: -item.remindMinutesBefore), days: item.days)
        }
        requests += repeating(id: "week-review", title: "⭐ Your week in review",
                              body: "See how your week went!", time: ClockTime(18), days: [1])

        let calendar = Calendar.current
        let now = Date()
        dayLoop: for offset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: offset, to: now),
                  let times = prayers.times(on: day) else { continue }
            for salah in Salah.allCases {
                guard requests.count < maxPending else { break dayLoop }
                let time = times.time(salah)
                guard time > now else { continue }
                let content = UNMutableNotificationContent()
                content.title = "🕌 Time for \(salah.name)"
                content.body = "\(salah.arabic) · \(time.formatted(date: .omitted, time: .shortened))"
                content.sound = prayerSound
                let when = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
                let trigger = UNCalendarNotificationTrigger(dateMatching: when, repeats: false)
                requests.append(UNNotificationRequest(identifier: "prayer-\(offset)-\(salah.rawValue)",
                                                      content: content, trigger: trigger))
            }
        }

        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        for request in requests {
            center.add(request, withCompletionHandler: nil)
        }
    }

    private static var prayerSound: UNNotificationSound {
        guard let file = FamilyConfig.prayerSoundFile else { return .default }
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: file))
    }

    /// One reminder that repeats daily, or one per weekday when not every day.
    private static func repeating(id: String, title: String, body: String,
                                  time: ClockTime, days: Set<Int>) -> [UNNotificationRequest] {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let weekdays: [Int?] = days.count == 7 ? [nil] : days.sorted().map { Optional($0) }
        return weekdays.map { weekday in
            var when = DateComponents()
            when.hour = time.hour
            when.minute = time.minute
            when.weekday = weekday
            let trigger = UNCalendarNotificationTrigger(dateMatching: when, repeats: true)
            return UNNotificationRequest(identifier: "\(id)-\(weekday ?? 0)", content: content, trigger: trigger)
        }
    }
}
