import Foundation
import Combine

/// Reads and writes FamilySettings through the family's iCloud, syncing the
/// parent's phone and Idrees's watch. Uses NSUbiquitousKeyValueStore: tiny,
/// serverless, automatic, and offline-friendly. A local copy is kept too, so
/// the app still works before iCloud answers or when signed out.
///
/// Shared by both targets. Requires the iCloud capability with
/// "Key-value storage" turned on for each target (same iCloud container).
@MainActor
final class SettingsStore: ObservableObject {
    @Published var settings: FamilySettings {
        didSet { if settings != oldValue { persist() } }
    }

    private let key = "familySettings"
    private let cloud = NSUbiquitousKeyValueStore.default
    private let local = UserDefaults.standard
    private var lastLocalEdit = Date.distantPast
    private var applyingRemote = false
    private var watch: AnyCancellable?

    init() {
        settings = Self.load(cloud: NSUbiquitousKeyValueStore.default, local: UserDefaults.standard, key: "familySettings")
        NotificationCenter.default.addObserver(
            self, selector: #selector(cloudChanged(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: cloud)
        cloud.synchronize()
        // The watch code sync (works with a Family Setup watch on its own Apple ID).
        watch = FamilyCloud.shared.$remote.sink { [weak self] fields in
            Task { @MainActor in self?.applyRemote(fields["settings"]) }
        }
    }

    /// Sends the current settings to the watch code record (after linking).
    func pushToWatch() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        FamilyCloud.shared.push("settings", data)
    }

    /// Another parent's phone changed the settings. Ignored right after an
    /// edit here, so a slow download never undoes what you just typed.
    private func applyRemote(_ data: Data?) {
        guard let data, Date().timeIntervalSince(lastLocalEdit) > 120,
              let decoded = try? JSONDecoder().decode(FamilySettings.self, from: data),
              decoded != settings else { return }
        applyingRemote = true
        settings = decoded
        applyingRemote = false
    }

    /// Call after a batch of edits; the didSet already persists each change,
    /// this just nudges iCloud to push sooner.
    func sync() { cloud.synchronize() }

    private func persist() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        cloud.set(data, forKey: key)
        local.set(data, forKey: key)
        cloud.synchronize()
        if !applyingRemote {
            lastLocalEdit = Date()
            FamilyCloud.shared.push("settings", data)
        }
    }

    private static func load(cloud: NSUbiquitousKeyValueStore, local: UserDefaults, key: String) -> FamilySettings {
        if let data = cloud.data(forKey: key) ?? local.data(forKey: key),
           let decoded = try? JSONDecoder().decode(FamilySettings.self, from: data) {
            return decoded
        }
        return .defaults
    }

    @objc private func cloudChanged(_ note: Notification) {
        // Another device (the watch, or the other parent) changed settings.
        guard let data = cloud.data(forKey: key),
              let decoded = try? JSONDecoder().decode(FamilySettings.self, from: data) else { return }
        if decoded != settings {
            settings = decoded
        }
    }
}
