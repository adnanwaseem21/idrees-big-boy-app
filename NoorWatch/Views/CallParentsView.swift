import SwiftUI
import WatchKit

/// Calls and texts go over the watch's own cellular plan, like a phone.
struct CallParentsView: View {
    @State private var pendingMessage: String?

    var body: some View {
        List {
            Section {
                ForEach(FamilyConfig.parents) { parent in
                    Button {
                        open("tel:\(parent.dialable)")
                    } label: {
                        MenuRow(emoji: parent.emoji, title: "Call \(parent.name)")
                    }
                }
            }
            Section("Quick message") {
                ForEach(FamilyConfig.quickMessages, id: \.self) { message in
                    Button(message) { pendingMessage = message }
                }
            }
            Section {
                Text("Emergency? Press and hold the side button to call 911.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Call")
        .confirmationDialog("Send to…", isPresented: isChoosingParent, presenting: pendingMessage) { message in
            ForEach(FamilyConfig.parents) { parent in
                Button("\(parent.emoji) \(parent.name)") { send(message, to: parent) }
            }
        }
    }

    private var isChoosingParent: Binding<Bool> {
        Binding(get: { pendingMessage != nil }, set: { if !$0 { pendingMessage = nil } })
    }

    private func send(_ message: String, to parent: Parent) {
        let body = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? message
        open("sms:\(parent.dialable)&body=\(body)")
    }

    private func open(_ link: String) {
        guard let url = URL(string: link) else { return }
        WKApplication.shared().openSystemURL(url)
    }
}
