import Foundation
import Combine
import CloudKit
import CryptoKit

/// Idrees's progress, written by the watch and read by the parent app, through
/// the same iCloud key-value store. One entry per day, keyed "yyyy-MM-dd".
/// Shared by both targets.
struct KidProgress: Codable, Equatable {
    var days: [String: DaySummary] = [:]
}

struct DaySummary: Codable, Equatable {
    var prayersCompleted: Int = 0
    var tasksDone: Int = 0
    var tasksTotal: Int = 0
    var points: Int = 0
    var dhikr: Int = 0
}

/// Read-only on the parent side; the watch writes to the same key.
@MainActor
final class ProgressStore: ObservableObject {
    @Published private(set) var progress = KidProgress()
    /// Surah numbers he has marked as memorized on the watch.
    @Published private(set) var memorized: [Int] = []

    private let key = "kidProgress"
    private let cloud = NSUbiquitousKeyValueStore.default
    private var watch: AnyCancellable?

    init() {
        reload()
        watch = FamilyCloud.shared.$remote.sink { [weak self] fields in
            Task { @MainActor in self?.apply(fields) }
        }
        Task { await FamilyCloud.shared.pull() }
        NotificationCenter.default.addObserver(
            self, selector: #selector(changed),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: cloud)
        cloud.synchronize()
    }

    /// Oldest-first summaries for the seven days ending today.
    func lastWeek() -> [(date: Date, summary: DaySummary)] {
        let cal = Calendar.current
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return (0..<7).reversed().compactMap { offset in
            guard let date = cal.date(byAdding: .day, value: -offset, to: Date()) else { return nil }
            return (date, progress.days[fmt.string(from: date)] ?? DaySummary())
        }
    }

    private func reload() {
        if let data = cloud.data(forKey: key),
           let decoded = try? JSONDecoder().decode(KidProgress.self, from: data) {
            progress = decoded
        }
    }

    @objc private func changed() { reload() }

    private func apply(_ fields: [String: Data]) {
        if let d = fields["progress"], let decoded = try? JSONDecoder().decode(KidProgress.self, from: d) {
            progress = decoded
        }
        if let d = fields["memorized"], let list = try? JSONDecoder().decode([Int].self, from: d) {
            memorized = list
        }
    }
}

// MARK: - Family sync across Apple IDs

/// Syncs the phone and the watch through a "watch code" instead of a shared
/// Apple ID. A Family Setup watch is signed in to the child's own Apple ID,
/// so the iCloud key-value store (which is per Apple ID) never reaches the
/// parent's phone. Here both devices read and write one record in the app's
/// CloudKit public database, named after a hash of the code. Only devices
/// that know the code can find the record. Shared by both targets.
///
/// Fields on the "Family" record (all Bytes, JSON):
/// - settings  — written by the parent app
/// - progress  — written by the watch (KidProgress)
/// - memorized — written by the watch ([Int] surah numbers)
@MainActor
final class FamilyCloud: ObservableObject {
    static let shared = FamilyCloud()
    static let containerID = "iCloud.com.ewsnetworks.idreesbigboy"
    static let recordType = "Family"

    @Published private(set) var code: String?
    @Published private(set) var lastSync: Date?
    @Published private(set) var lastError: String?
    /// The latest data pulled from the cloud, by field name.
    @Published private(set) var remote: [String: Data] = [:]

    private let local = UserDefaults.standard
    private var timer: Timer?
    private lazy var db = CKContainer(identifier: Self.containerID).publicCloudDatabase

    private init() {
        code = local.string(forKey: "familyCode")
    }

    // MARK: Code

    private static let alphabet = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")

    /// A new random code like "K7QM-3XTP" (no 0/O or 1/I to mix up).
    static func newCode() -> String {
        let chars = (0..<8).map { _ in String(alphabet.randomElement()!) }
        return chars[0..<4].joined() + "-" + chars[4..<8].joined()
    }

    /// Upper-cases and drops spaces and dashes, so "k7qm 3xtp" works too.
    static func normalize(_ s: String) -> String {
        String(s.uppercased().filter { $0.isLetter || $0.isNumber })
    }

    static func isValid(_ s: String) -> Bool { normalize(s).count == 8 }

    /// Pretty form of a typed code.
    static func display(_ s: String) -> String {
        let n = normalize(s)
        guard n.count == 8 else { return n }
        return String(n.prefix(4)) + "-" + String(n.suffix(4))
    }

    func setCode(_ newValue: String?) {
        let cleaned = newValue.map(Self.display)
        code = cleaned
        local.set(cleaned, forKey: "familyCode")
        remote = [:]
        lastSync = nil
        lastError = nil
        Task { await pull() }
    }

    private var recordID: CKRecord.ID? {
        guard let code else { return nil }
        let hash = SHA256.hash(data: Data(("idreesbigboy:" + Self.normalize(code)).utf8))
        return CKRecord.ID(recordName: "family-" + hash.map { String(format: "%02x", $0) }.joined())
    }

    // MARK: Reading and writing

    /// Writes one field, leaving the other device's fields alone.
    func push(_ field: String, _ data: Data) {
        guard let id = recordID else { return }
        let record = CKRecord(recordType: Self.recordType, recordID: id)
        record[field] = data
        Task {
            do {
                _ = try await db.modifyRecords(saving: [record], deleting: [], savePolicy: .changedKeys)
                lastSync = Date()
                lastError = nil
            } catch {
                lastError = Self.describe(error)
            }
        }
    }

    /// Fetches the record and publishes its fields.
    func pull() async {
        guard let id = recordID else { return }
        do {
            let record = try await db.record(for: id)
            var fields: [String: Data] = [:]
            for key in ["settings", "progress", "memorized"] {
                if let d = record[key] as? Data { fields[key] = d }
            }
            if fields != remote { remote = fields }
            lastSync = Date()
            lastError = nil
        } catch let e as CKError where e.code == .unknownItem {
            lastSync = Date()      // linked, the other device hasn't written yet
            lastError = nil
        } catch {
            lastError = Self.describe(error)
        }
    }

    /// Pulls now and every minute while the app is open.
    func start() {
        Task { await pull() }
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            Task { @MainActor in await FamilyCloud.shared.pull() }
        }
    }

    private static func describe(_ error: Error) -> String {
        if let e = error as? CKError {
            switch e.code {
            case .notAuthenticated: return "Sign in to iCloud in Settings to sync."
            case .networkUnavailable, .networkFailure: return "No internet right now. It will sync when there's signal."
            default: break
            }
        }
        return "Couldn't sync: \(error.localizedDescription)"
    }
}
