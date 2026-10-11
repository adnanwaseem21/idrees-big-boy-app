import SwiftUI

struct RewardsEditorView: View {
    @EnvironmentObject private var store: SettingsStore

    var body: some View {
        List {
            ForEach($store.settings.rewards) { $reward in
                NavigationLink {
                    RewardDetailView(reward: $reward)
                } label: {
                    HStack {
                        Text(reward.emoji)
                        Text(reward.title)
                        Spacer()
                        Text("\(reward.cost) pts").foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { store.settings.rewards.remove(atOffsets: $0) }

            Button {
                store.settings.rewards.append(
                    RewardSetting(id: UUID().uuidString, title: "New reward", emoji: "🎁", cost: 100))
            } label: {
                Label("Add reward", systemImage: "plus.circle.fill")
            }
        }
        .navigationTitle("Rewards")
        .toolbar { EditButton() }
    }
}

struct RewardDetailView: View {
    @Binding var reward: RewardSetting

    var body: some View {
        Form {
            TextField("Title", text: $reward.title)
            EmojiField(title: "Icon", emoji: $reward.emoji)
            Stepper("Cost: \(reward.cost) pts", value: $reward.cost, in: 10...2000, step: 10)
        }
        .navigationTitle("Edit reward")
        .navigationBarTitleDisplayMode(.inline)
    }
}
