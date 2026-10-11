import Foundation
import AVFoundation

/// Voice notes are saved as files on the watch.
@MainActor
final class VoiceNotes: NSObject, ObservableObject, AVAudioPlayerDelegate {
    struct Note: Identifiable {
        let url: URL
        let date: Date

        var id: URL { url }
    }

    @Published private(set) var notes: [Note] = []
    @Published private(set) var recordingSince: Date?
    @Published private(set) var playing: URL?

    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private let folder = URL.documentsDirectory.appending(path: "VoiceNotes", directoryHint: .isDirectory)

    override init() {
        super.init()
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        reload()
    }

    func startRecording() async {
        guard await AVAudioApplication.requestRecordPermission() else { return }
        stopPlaying()
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            let url = folder.appending(path: "note-\(Int(Date().timeIntervalSince1970)).m4a")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 22_050,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
            ]
            let recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder.record()
            self.recorder = recorder
            recordingSince = Date()
        } catch {
            recordingSince = nil
        }
    }

    func stopRecording() {
        recorder?.stop()
        recorder = nil
        recordingSince = nil
        reload()
    }

    func play(_ note: Note) {
        stopPlaying()
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            let player = try AVAudioPlayer(contentsOf: note.url)
            player.delegate = self
            player.play()
            self.player = player
            playing = note.url
        } catch {
            playing = nil
        }
    }

    func stopPlaying() {
        player?.stop()
        player = nil
        playing = nil
    }

    func delete(_ note: Note) {
        if playing == note.url {
            stopPlaying()
        }
        try? FileManager.default.removeItem(at: note.url)
        reload()
    }

    private func reload() {
        let urls = (try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.creationDateKey])) ?? []
        notes = urls
            .filter { $0.pathExtension == "m4a" }
            .map { url in
                Note(url: url, date: (try? url.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? .distantPast)
            }
            .sorted { $0.date > $1.date }
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in self.playing = nil }
    }
}
