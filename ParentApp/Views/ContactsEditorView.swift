import SwiftUI

/// Who Idrees can call, and the one-tap messages he can send.
struct ContactsEditorView: View {
    @EnvironmentObject private var store: SettingsStore

    var body: some View {
        List {
            Section("Parents he can call") {
                ForEach($store.settings.parents) { $parent in
                    NavigationLink {
                        ParentDetailView(parent: $parent)
                    } label: {
                        HStack {
                            Text(parent.emoji)
                            Text(parent.name)
                            Spacer()
                            Text(parent.phone).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { store.settings.parents.remove(atOffsets: $0) }

                Button {
                    store.settings.parents.append(
                        ParentSetting(id: UUID().uuidString, name: "New contact", emoji: "🙂", phone: ""))
                } label: {
                    Label("Add contact", systemImage: "plus.circle.fill")
                }
            }

            Section {
                ForEach($store.settings.quickMessages) { $message in
                    TextField("Message", text: $message.text)
                }
                .onDelete { store.settings.quickMessages.remove(atOffsets: $0) }

                Button {
                    store.settings.quickMessages.append(QuickMessage(text: "New message"))
                } label: {
                    Label("Add quick message", systemImage: "plus.circle.fill")
                }
            } header: {
                Text("Quick messages")
            } footer: {
                Text("One-tap texts Idrees can send you from the watch.")
            }
        }
        .navigationTitle("Contacts")
        .toolbar { EditButton() }
    }
}

struct ParentDetailView: View {
    @Binding var parent: ParentSetting

    var body: some View {
        Form {
            TextField("Name", text: $parent.name)
            EmojiField(title: "Icon", emoji: $parent.emoji)
            TextField("Phone number", text: $parent.phone)
                .keyboardType(.phonePad)
        }
        .navigationTitle("Contact")
        .navigationBarTitleDisplayMode(.inline)
    }
}
