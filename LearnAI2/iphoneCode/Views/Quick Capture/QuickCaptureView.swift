//import SwiftUI
//
//struct QuickCaptureView: View {
//    @State private var isExpanded: Bool = false
//    @State private var showAcknowledgment: Bool = false
//
//    var body: some View {
//        ZStack {
//            // Main content (top part)
//            VStack {
//                ZStack(alignment: .bottomTrailing) {
//                    // "Visual button" (half-screen rounded rectangle)
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color(.systemGray6))
//                        .frame(height: UIScreen.main.bounds.height * 0.08)
//                        .overlay(
//                            Text("Jot down your thoughts...")
//                                .foregroundColor(.gray)
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                        )
//                        .onTapGesture {
//                            isExpanded = true
//                        }
//                    
//                    // "+" Button in Bottom-Right Corner
//                    Button(action: {
//                        isExpanded = true
//                    }) {
//                        Image(systemName: "plus.circle.fill")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                            .foregroundColor(.blue)
//                            .background(Color.white.opacity(0.8))
//                            .clipShape(Circle())
//                            .shadow(radius: 3)
//                    }
//                    .offset(x: -10, y: -10)
//                }
//                .padding()
//                
////                Spacer()
//            }
//            .padding()
//            .fullScreenCover(isPresented: $isExpanded) {
//                FullCaptureView(isExpanded: $isExpanded, showAcknowledgment: $showAcknowledgment)
//            }
//            
//            // Acknowledgment overlay
//            if showAcknowledgment {
//                CameraShutterAcknowledgmentView(showAcknowledgment: $showAcknowledgment)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                    .transition(AnyTransition.opacity.animation(nil))
//                    .zIndex(2)
//            }
//        }
//        // Disable default animations for the acknowledgment overlay
//        .animation(nil, value: showAcknowledgment)
//    }
//}
//
//
import SwiftUI
import AVFoundation

struct QuickCaptureView: View {
    @State private var isExpanded = false
    @State private var showAcknowledgment = false
    @State private var showAudioCapture = false        // ➊

    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                        .frame(height: UIScreen.main.bounds.height * 0.08)
                        .overlay(
                            Text("Jot down your thoughts…")
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        )
                        .onTapGesture { isExpanded = true }

                    // ➋ Two‐button HStack
                    HStack(spacing: 16) {
                        // “+” button
                        Button { isExpanded = true } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .foregroundColor(.blue)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }

                        // Mic button
                        Button { showAudioCapture = true } label: {
                            Image(systemName: "mic.circle.fill")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .foregroundColor(.red)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                    .offset(x: -10, y: -10)
                }
                .padding()
            }
            .fullScreenCover(isPresented: $isExpanded) {
                FullCaptureView(isExpanded: $isExpanded,
                                showAcknowledgment: $showAcknowledgment)
            }

            if showAcknowledgment {
                CameraShutterAcknowledgmentView(showAcknowledgment: $showAcknowledgment)
                    .zIndex(2)
            }
        }
        .sheet(isPresented: $showAudioCapture) {               // ➌
            AudioCaptureView(isPresented: $showAudioCapture) { audioURL, context in
                // ➍ here you can upload `audioURL` and `context` to
                //    your Django backend or an AI transcription API
                //    e.g. APIService.shared.transcribe(audioURL, context)
            }
        }
        .animation(nil, value: showAcknowledgment)
    }
}


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




struct CameraShutterAcknowledgmentView: View {
    @Binding var showAcknowledgment: Bool
    @State private var showText: Bool = false
    @State private var blackoutOpacity: Double = 1.0
    @State private var scale: CGFloat = 3.0  // Start from large scale

    var body: some View {
        ZStack {
            // Full black background mimicking a camera shutter effect.
            Color.black
                .opacity(blackoutOpacity)
                .edgesIgnoringSafeArea(.all)
            
            // "Thought Captured" Text appearing from the center.
            if showText {
                Text("✨ Thought Captured ✨")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                blackoutOpacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    showText = true
                    scale = 1
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeIn(duration: 0.5)) {
                    blackoutOpacity = 0.0
                    scale = 0.8
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showAcknowledgment = false
            }
        }
    }
}
//
//
