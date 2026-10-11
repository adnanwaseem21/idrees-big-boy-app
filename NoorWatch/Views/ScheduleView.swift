import SwiftUI

/// Today's and tomorrow's schedule, with prayer times mixed in.
struct ScheduleView: View {
    @EnvironmentObject private var prayers: PrayerService

    private struct Entry: Identifiable {
        let id: String
        let time: Date
        let emoji: String
        let title: String
    }

    var body: some View {
        TimelineView(.everyMinute) { context in
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: context.date) ?? context.date
            List {
                daySection("Today", day: context.date, now: context.date)
                daySection("Tomorrow", day: tomorrow, now: context.date)
            }
        }
        .navigationTitle("My Day")
    }

    private func daySection(_ title: String, day: Date, now: Date) -> some View {
        Section(title) {
            ForEach(entries(on: day)) { entry in
                HStack {
                    Text(entry.emoji)
                    Text(entry.title)
                    Spacer()
                    Text(entry.time, style: .time)
                        .font(.caption2)
                }
                .opacity(entry.time < now ? 0.4 : 1)
            }
        }
    }

    private func entries(on day: Date) -> [Entry] {
        let weekday = Calendar.current.component(.weekday, from: day)
        var list = FamilyConfig.schedule
            .filter { $0.days.contains(weekday) }
            .map { Entry(id: "s-\($0.id)", time: $0.time.on(day), emoji: $0.emoji, title: $0.title) }
        if let times = prayers.times(on: day) {
            list += Salah.allCases.map { Entry(id: "p-\($0.rawValue)", time: times.time($0), emoji: "🕌", title: $0.name) }
        }
        return list.sorted { $0.time < $1.time }
    }
}
