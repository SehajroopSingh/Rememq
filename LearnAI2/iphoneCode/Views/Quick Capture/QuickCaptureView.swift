import SwiftUI

struct QuickCaptureView: View {
    @State private var isExpanded: Bool = false
    @State private var showAcknowledgment: Bool = false

    var body: some View {
        ZStack {
            // Main content (top part)
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    // "Visual button" (half-screen rounded rectangle)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                        .frame(height: UIScreen.main.bounds.height * 0.08)
                        .overlay(
                            Text("Jot down your thoughts...")
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        )
                        .onTapGesture {
                            isExpanded = true
                        }
                    
                    // "+" Button in Bottom-Right Corner
                    Button(action: {
                        isExpanded = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .offset(x: -10, y: -10)
                }
                .padding()
                
//                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $isExpanded) {
                FullCaptureView(isExpanded: $isExpanded, showAcknowledgment: $showAcknowledgment)
            }
            
            // Acknowledgment overlay
            if showAcknowledgment {
                CameraShutterAcknowledgmentView(showAcknowledgment: $showAcknowledgment)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .transition(AnyTransition.opacity.animation(nil))
                    .zIndex(2)
            }
        }
        // Disable default animations for the acknowledgment overlay
        .animation(nil, value: showAcknowledgment)
    }
}

struct FullCaptureView: View {
    @Binding var isExpanded: Bool
    @Binding var showAcknowledgment: Bool
    @State private var thought: String = ""
    @State private var additionalContext: String = ""
    @State private var responseMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Write your main thought here...", text: $thought)
                    .padding()
                    .frame(height: 100)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                TextField("Add more context...", text: $additionalContext)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Spacer()

                // Save & Capture Button
                Button(action: {
                    sendThoughtToDjango(thought: thought, additionalContext: additionalContext)
                }) {
                    Text("Save Thought")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Text(responseMessage)
                    .foregroundColor(.gray)
                    .padding()
            }
            .padding()
            .navigationTitle("Expand Your Thought")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isExpanded = false
                    }
                }
            }
        }
    }
    
    func sendThoughtToDjango(thought: String, additionalContext: String) {
        // Build the payload
        let postData: [String: Any] = [
            "input_type": "text",
            "content": thought,
            "context": additionalContext
        ]
        
        // Use APIService to perform the request.
        APIService.shared.performRequest(endpoint: "processor/quick_capture/", method: "POST", body: postData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let responseString = String(data: data, encoding: .utf8) {
                        self.responseMessage = "Response: \(responseString)"
                    } else {
                        self.responseMessage = "Success but response is unreadable."
                    }
                    // Close the capture view and show acknowledgment
                    self.isExpanded = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.showAcknowledgment = true
                    }
                case .failure(let error):
                    self.responseMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
        // Note: Removed the extraneous `task.resume()` here.
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


