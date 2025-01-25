import SwiftUI
import Vision

struct ContentView: View {
    var body: some View {
        #if os(macOS)
        MacHomeView()
        #elseif os(iOS)
        iPhoneHomeView()
        #endif
    }
}

struct MacHomeView: View {
    @State private var recognizedText: String = "Recognized text will appear here."
    @State private var message: String = ""
    private let ocrManager = OCRManager()
    private let backendManager = BackendManager()

    var body: some View {
        VStack(spacing: 20) {
            Button("Recognize Text in Selected Area") {
                captureAndProcessText()
            }
            
            Text(recognizedText)
                .padding()
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Text(message)
                .foregroundColor(.green)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    private func captureAndProcessText() {
        #if os(macOS)
        let savePath = FileManager.default.temporaryDirectory.appendingPathComponent("screenshot.png").path

        // Step 1: Capture Selected Area
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        task.arguments = ["-i", savePath]
        
        do {
            try task.run()
            task.waitUntilExit()
            
            // Step 2: Perform OCR if screenshot exists
            if FileManager.default.fileExists(atPath: savePath) {
                performOCR(onImageAt: savePath)
            } else {
                recognizedText = "Screenshot file not found."
            }
        } catch {
            recognizedText = "Error capturing screenshot: \(error.localizedDescription)"
        }
        #endif
    }
    
    private func sendTextToBackend(_ text: String) {
        backendManager.sendToBackend(text: text)
        self.message = "Text sent to backend successfully!"
    }
}
