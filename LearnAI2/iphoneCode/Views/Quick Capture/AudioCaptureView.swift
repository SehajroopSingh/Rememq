import SwiftUI
import AVFoundation
import Speech

struct AudioCaptureView: View {
    init(isPresented: Binding<Bool>, showAcknowledgment: Binding<Bool>) {
        _isPresented = isPresented
        _showAcknowledgment = showAcknowledgment
    }

    @Binding var isPresented: Bool
    @Binding var showAcknowledgment: Bool
    @State private var amplitude: Float = 0.0


    @State  var thought = ""
    @State private var additionalContext = ""
    @State private var phase: CapturePhase = .mainThought
    @State private var responseMessage = ""

    @StateObject private var viewModel = StructureViewModel()

    @State private var selectedSpace: Space?
    @State private var selectedGroup: Group?
    @State private var selectedSet: SetItem?

    enum CapturePhase {
        case mainThought, contextPrompt, contextRecording, pickers
    }

    var body: some View {
        VStack(spacing: 24) {
            // 1. Always show thought recorder
            transcriptionView(
                text: $thought,
                title: "Speak your main thought…",
                finishAction: {
                    stopListening()
                    phase = .contextPrompt
                }
            )
            .disabled(phase != .mainThought)
            .opacity(1.0)

            // 2. Show context prompt only if past mainThought
            if phase != .mainThought {
                VStack(spacing: 16) {
                    if phase == .contextPrompt {
                        Button("Add Context") {
                            phase = .contextRecording
                            startListening(for: .contextRecording)
                        }
                        Button("Skip") {
                            phase = .pickers
                        }.foregroundColor(.gray)
                    }
                }
            }

            // 3. Show context recorder only if started
            if phase == .contextRecording || phase == .pickers {
                transcriptionView(
                    text: $additionalContext,
                    title: "Speak your additional context…",
                    finishAction: {
                        stopListening()
                        phase = .pickers
                    }
                )
                .disabled(phase != .contextRecording)
            }

            // 4. Show pickers at the end
            if phase == .pickers {
                VStack(spacing: 16) {
                    pickersSection
                    saveButton
                    if !responseMessage.isEmpty {
                        Text(responseMessage).foregroundColor(.gray)
                    }
                }
                .onAppear { viewModel.loadStructure() }
            }
        }

        .padding()
        .onAppear { requestPermissionsAndStart() }
    }

    private func transcriptionView(text: Binding<String>, title: String, finishAction: @escaping () -> Void) -> some View {
        
        VStack(spacing: 16) {
            WaveformView(amplitude: amplitude)

            Text(title).font(.headline)
            TextEditor(text: text)
                .frame(height: 150)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            Button("Finish", action: finishAction)
                .buttonStyle(.borderedProminent)
        }
    }

    private func requestPermissionsAndStart() {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else { return }
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    DispatchQueue.main.async {
                        startListening(for: .mainThought)
                    }
                }
            }
        }
    }

    private let audioEngine = AVAudioEngine()
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    
    
    
    private func startListening(for target: CapturePhase) {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let request = recognitionRequest,
              let recognizer = speechRecognizer,
              recognizer.isAvailable else { return }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("AudioSession setup failed: \(error)")
            return
        }

        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { buffer, _ in
            request.append(buffer)
            
            // Update amplitude for waveform
            if let channelData = buffer.floatChannelData?[0] {
                let rms = sqrt(channelData[0] * channelData[0])
                DispatchQueue.main.async {
                    self.amplitude = rms
                }
            }
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine could not start: \(error)")
            return
        }



        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                let transcription = result.bestTranscription.formattedString
                if target == .mainThought {
                    self.thought = transcription
                } else if target == .contextRecording {
                    self.additionalContext = transcription
                }
            }
            if error != nil || (result?.isFinal ?? false) {
                self.stopListening()
            }
        }
    }


    private func stopListening() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }

    private var pickersSection: some View {
        SwiftUI.Group {
            if viewModel.spaces.isEmpty {
                ProgressView("Loading spaces…")
            } else {
                Picker("Space", selection: $selectedSpace) {
                    ForEach(viewModel.spaces) { space in
                        Text(space.name).tag(Optional(space))
                    }
                }.pickerStyle(.menu)

                if let groups = selectedSpace?.groups {
                    Picker("Group", selection: $selectedGroup) {
                        ForEach(groups) { group in
                            Text(group.name).tag(Optional(group))
                        }
                    }.pickerStyle(.menu)
                } else {
                    Text("Select a space first").foregroundColor(.secondary)
                }

                if let sets = selectedGroup?.sets {
                    Picker("Set", selection: $selectedSet) {
                        ForEach(sets) { set in
                            Text(set.title).tag(Optional(set))
                        }
                    }.pickerStyle(.menu)
                } else if selectedGroup != nil {
                    Text("Loading sets…").foregroundColor(.secondary)
                } else {
                    Text("Select a group first").foregroundColor(.secondary)
                }
            }
        }
    }

    private var saveButton: some View {
        Button("Save Thought") {
            var payload: [String: Any] = [
                "content": thought,
                "context": additionalContext
            ]
            if let set = selectedSet { payload["set"] = set.id }

            APIService.shared.performRequest(endpoint: "quick-capture/quick_capture/", method: "POST", body: payload) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        responseMessage = String(data: data, encoding: .utf8) ?? "Saved!"
                        closeAndFlash()
                    case .failure(let error):
                        responseMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
        .disabled(thought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    private func closeAndFlash() {
        isPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showAcknowledgment = true
        }
    }
    struct WaveformView: View {
        var amplitude: Float

        var body: some View {
            Capsule()
                .fill(Color.red)
                .frame(width: 4, height: max(CGFloat(amplitude) * 300, 2))
                .animation(.linear(duration: 0.1), value: amplitude)
        }
    }


}



