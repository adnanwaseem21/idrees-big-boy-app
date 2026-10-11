import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var store: KidStore

    var body: some View {
        List {
            if !store.tasks().isEmpty && store.tasks().allSatisfy({ store.isDone($0) }) {
                Text("MashaAllah! Everything done today 🎉")
                    .font(.headline)
                    .foregroundStyle(.green)
            }
            TaskSection(title: "Chores", tasks: store.tasks(kind: .chore))
            TaskSection(title: "Activities", tasks: store.tasks(kind: .activity))
        }
        .navigationTitle("Today")
    }
}

struct TaskSection: View {
    @EnvironmentObject private var store: KidStore
    let title: String
    let tasks: [TaskItem]

    var body: some View {
        if !tasks.isEmpty {
            Section(title) {
                ForEach(tasks) { task in
                    let done = store.isDone(task)
                    Button {
                        store.toggleTask(task)
                        if done { Haptics.tap() } else { Haptics.success() }
                    } label: {
                        HStack {
                            Text(task.emoji)
                            Text(task.title)
                                .strikethrough(done)
                                .foregroundStyle(done ? Color.secondary : Color.primary)
                            Spacer()
                            Text(done ? "✅" : "+\(task.points)")
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}
