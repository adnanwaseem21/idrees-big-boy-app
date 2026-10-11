import SwiftUI

struct WeekReviewView: View {
    @EnvironmentObject private var store: KidStore
    @State private var weeksBack = 0

    var body: some View {
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .day, value: -7 * weeksBack, to: Date()) ?? Date()
        let week = store.weekSummary(endingOn: end)
        let before = store.weekSummary(endingOn: calendar.date(byAdding: .day, value: -7, to: end) ?? end)
        List {
            Section {
                Text(week.headline)
                    .font(.headline)
                DayStrip(days: week.days)
            } header: {
                Text(rangeLabel(week))
            }
            Section {
                StatRow(emoji: "🕌", title: "Prayers", value: week.prayersDone, total: week.prayersPossible)
                StatRow(emoji: "✅", title: "Chores & activities", value: week.tasksDone, total: week.tasksPossible)
                LabeledContent("🌟 All-5 days", value: "\(week.fullPrayerDays) of 7")
                LabeledContent("⭐ Points", value: "\(week.points)")
                LabeledContent("📿 Dhikr", value: "\(week.dhikr)")
                if let best = week.bestDay {
                    LabeledContent("🏆 Best day", value: best.date.formatted(.dateTime.weekday(.wide)))
                }
            }
            Section {
                Text(comparison(week, before))
                    .font(.caption)
            }
            Section {
                Button("◀ Week before") { weeksBack += 1 }
                if weeksBack > 0 {
                    Button("Back to this week ▶") { weeksBack = 0 }
                }
            }
        }
        .navigationTitle("My Week")
    }

    private func comparison(_ week: WeekSummary, _ before: WeekSummary) -> String {
        let diff = week.prayersDone - before.prayersDone
        if diff > 0 { return "📈 \(diff) more prayers than the week before. MashaAllah!" }
        if diff < 0 { return "📉 \(-diff) fewer prayers than the week before. You've got this!" }
        return "➡️ Same number of prayers as the week before."
    }

    private func rangeLabel(_ week: WeekSummary) -> String {
        guard let first = week.days.first?.date, let last = week.days.last?.date else { return "" }
        let style = Date.FormatStyle.dateTime.month(.abbreviated).day()
        return "\(first.formatted(style)) – \(last.formatted(style))"
    }
}

struct StatRow: View {
    let emoji: String
    let title: String
    let value: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(emoji) \(title): \(value)/\(total)")
                .font(.caption)
            ProgressView(value: Double(min(value, max(total, 1))), total: Double(max(total, 1)))
                .tint(.green)
        }
    }
}

/// One column per day: a star for all five prayers, otherwise how many.
struct DayStrip: View {
    let days: [WeekSummary.Day]

    var body: some View {
        HStack(spacing: 2) {
            ForEach(days) { day in
                VStack(spacing: 2) {
                    Text(day.date.formatted(.dateTime.weekday(.narrow)))
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    Text(day.allPrayers ? "⭐" : "\(day.log.prayed.count)")
                        .font(.system(size: 12))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
