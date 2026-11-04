import Foundation

/// A lightweight, synchronous reader of the family's settings for the watch.
/// It reads the same iCloud key the parent app writes, so the watch always
/// reflects the latest choices, and falls back to defaults before iCloud or a
/// local copy is available. The watch's FamilyConfig reads through this.
final class LiveSettings {
    static let shared = LiveSettings()

    private let key = "familySettings"
    private let cloud = NSUbiquitousKeyValueStore.default
    private let local = UserDefaults.standard
    private(set) var current: FamilySettings

    private init() {
        current = Self.read(cloud: cloud, local: local, key: key)
        NotificationCenter.default.addObserver(
            self, selector: #selector(reload),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: cloud)
        cloud.synchronize()
    }

    /// Settings that arrived through the watch code (FamilyCloud).
    func apply(_ data: Data?) {
        guard let data, let decoded = try? JSONDecoder().decode(FamilySettings.self, from: data),
              decoded != current else { return }
        local.set(data, forKey: key)
        current = decoded
    }

    @objc private func reload() {
        current = Self.read(cloud: cloud, local: local, key: key)
    }

    private static func read(cloud: NSUbiquitousKeyValueStore, local: UserDefaults, key: String) -> FamilySettings {
        // Once linked with a watch code, the copy from the code wins over the
        // (per Apple ID) key-value store.
        let linked = local.string(forKey: "familyCode") != nil
        if let data = linked ? (local.data(forKey: key) ?? cloud.data(forKey: key)) : (cloud.data(forKey: key) ?? local.data(forKey: key)),
           let decoded = try? JSONDecoder().decode(FamilySettings.self, from: data) {
            return decoded
        }
        return .defaults
    }
}

/// The watch writes Idrees's daily totals here so the parent's "His week"
/// screen can show them, through the same iCloud store.
enum KidProgressWriter {
    private static let key = "kidProgress"

    static func record(_ summary: DaySummary, for date: Date) {
        let cloud = NSUbiquitousKeyValueStore.default
        var progress = cloud.data(forKey: key)
            .flatMap { try? JSONDecoder().decode(KidProgress.self, from: $0) } ?? KidProgress()
        progress.days[dayKey(date)] = summary
        if let data = try? JSONEncoder().encode(progress) {
            cloud.set(data, forKey: key)
            cloud.synchronize()
            Task { @MainActor in FamilyCloud.shared.push("progress", data) }
        }
    }

    static func dayKey(_ date: Date) -> String {
        let p = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", p.year ?? 0, p.month ?? 0, p.day ?? 0)
    }
}
