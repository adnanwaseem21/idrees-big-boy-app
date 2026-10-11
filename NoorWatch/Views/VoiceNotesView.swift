import SwiftUI

struct VoiceNotesView: View {
    @EnvironmentObject private var voiceNotes: VoiceNotes

    var body: some View {
        List {
            Section {
                Button {
                    if voiceNotes.recordingSince == nil {
                        Task { await voiceNotes.startRecording() }
                    } else {
                        voiceNotes.stopRecording()
                    }
                } label: {
                    HStack {
                        Image(systemName: voiceNotes.recordingSince == nil ? "mic.circle.fill" : "stop.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                        if let since = voiceNotes.recordingSince {
                            Text(since, style: .timer)
                                .font(.headline)
                        } else {
                            Text("Record")
                                .font(.headline)
                        }
                    }
                }
            }
            Section("My recordings") {
                if voiceNotes.notes.isEmpty {
                    Text("Nothing yet. Try recording a surah you're learning!")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                ForEach(voiceNotes.notes) { note in
                    let isPlaying = voiceNotes.playing == note.url
                    Button {
                        if isPlaying { voiceNotes.stopPlaying() } else { voiceNotes.play(note) }
                    } label: {
                        Label(note.date.formatted(date: .abbreviated, time: .shortened),
                              systemImage: isPlaying ? "stop.fill" : "play.fill")
                            .font(.caption)
                    }
                }
                .onDelete { offsets in
                    for note in offsets.map({ voiceNotes.notes[$0] }) {
                        voiceNotes.delete(note)
                    }
                }
            }
        }
        .navigationTitle("Voice Notes")
    }
}
