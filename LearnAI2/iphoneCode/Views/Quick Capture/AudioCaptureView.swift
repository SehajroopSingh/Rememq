
/// A slide‐up view that records audio, lets you add context, and returns both.
struct AudioCaptureView: View {
    @Binding var isPresented: Bool
    var onComplete: (_ audioFile: URL, _ context: String) -> Void

    @State private var recorder: AVAudioRecorder?
    @State private var isRecording = false
    @State private var contextText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Record/Stop Button
                Button(action: toggleRecording) {
                    Image(systemName: isRecording ? "stop.circle.fill" : "record.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(isRecording ? .gray : .red)
                }

                Text(isRecording ? "Recording…" : "Tap to Record")
                    .font(.headline)

                // Context field
                TextEditor(text: $contextText)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Spacer()
            }
            .padding()
            .navigationTitle("Voice Capture")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        guard let url = recorder?.url else { return }
                        isPresented = false
                        onComplete(url, contextText)
                    }
                    .disabled(isRecording)  // Don't allow Done while recording
                }
            }
            .onAppear(perform: setupRecorder)
        }
    }

    private func setupRecorder() {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                guard granted else { return }
                configureAudioSessionAndRecorder()
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted else { return }
                configureAudioSessionAndRecorder()
            }
        }
    }


    private func configureAudioSessionAndRecorder() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)

            let tempDir = FileManager.default.temporaryDirectory
            let fileURL = tempDir.appendingPathComponent("quickcapture.m4a")

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1
            ]

            recorder = try AVAudioRecorder(url: fileURL, settings: settings)
            recorder?.prepareToRecord()
        } catch {
            print("Failed to set up audio recorder:", error)
        }
    }


    private func toggleRecording() {
        guard let rec = recorder else { return }
        if rec.isRecording {
            rec.stop()
            isRecording = false
        } else {
            rec.record()
            isRecording = true
        }
    }
}


