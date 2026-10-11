import SwiftUI

struct ReviewView: View {
    @StateObject private var progress = ProgressStore()

    var body: some View {
        let week = progress.lastWeek()
        let prayers = week.reduce(0) { $0 + $1.summary.prayersCompleted }
        let tasksDone = week.reduce(0) { $0 + $1.summary.tasksDone }
        let tasksTotal = week.reduce(0) { $0 + $1.summary.tasksTotal }
        let points = week.reduce(0) { $0 + $1.summary.points }
        let hasData = week.contains { $0.summary.points > 0 || $0.summary.prayersCompleted > 0 }

        List {
            if !hasData {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("No activity yet").font(.headline)
                        Text("Idrees's progress will appear here once his watch is set up and he starts ticking off prayers and chores. It syncs automatically over iCloud.")
                            .font(.callout).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section("This week") {
                stat("🕌", "Prayers", "\(prayers) / \(week.count * 5)")
                stat("✅", "Chores & activities", "\(tasksDone) / \(tasksTotal)")
                stat("⭐", "Points earned", "\(points)")
            }

            Section("Day by day") {
                ForEach(week, id: \.date) { day in
                    HStack {
                        Text(day.date.formatted(.dateTime.weekday(.wide)))
                        Spacer()
                        Text(day.summary.prayersCompleted == 5 ? "⭐ all 5"
                             : "\(day.summary.prayersCompleted)/5 prayers")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("His week")
    }

    private func stat(_ emoji: String, _ title: String, _ value: String) -> some View {
        HStack {
            Text(emoji); Text(title); Spacer()
            Text(value).fontWeight(.semibold)
        }
    }
}
