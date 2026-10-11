import SwiftUI

struct RewardsView: View {
    @EnvironmentObject private var store: KidStore
    @State private var pending: Reward?

    var body: some View {
        let points = max(0, store.totalPoints)
        List {
            Section {
                Text("⭐ \(points) points")
                    .font(.title3)
            }
            Section("Rewards") {
                ForEach(FamilyConfig.rewards) { reward in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(reward.emoji) \(reward.title)")
                        ProgressView(value: Double(min(points, reward.cost)), total: Double(reward.cost))
                            .tint(.yellow)
                        if points >= reward.cost {
                            Button("Redeem \(reward.cost) points") { pending = reward }
                        } else {
                            Text("\(reward.cost - points) more points to go")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Rewards")
        .confirmationDialog("Ask Mom or Dad to tap Yes", isPresented: isConfirming, presenting: pending) { reward in
            Button("Yes, redeem \(reward.title)") {
                store.redeem(reward)
                Haptics.success()
            }
            Button("Not now", role: .cancel) {}
        }
    }

    private var isConfirming: Binding<Bool> {
        Binding(get: { pending != nil }, set: { if !$0 { pending = nil } })
    }
}
