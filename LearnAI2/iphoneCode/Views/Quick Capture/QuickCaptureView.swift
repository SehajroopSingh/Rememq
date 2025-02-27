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
                
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $isExpanded) {
                FullCaptureView(isExpanded: $isExpanded, showAcknowledgment: $showAcknowledgment)
            }
            
            // Acknowledgment overlay remains unchanged
            if showAcknowledgment {
                CameraShutterAcknowledgmentView(showAcknowledgment: $showAcknowledgment)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .transition(AnyTransition.opacity.animation(nil))
                    .zIndex(2)
            }
            
            // Bottom Navigation Bar: A separate VStack anchored to the bottom
            VStack {
                Spacer()  // Pushes the content to the bottom
                HStack {
                    Spacer()
                    NavigationLink(destination: Page1View()) {
                        Image(systemName: "house.fill")
                    }
                    Spacer()
                    NavigationLink(destination: Page2View()) {
                        Image(systemName: "star.fill")
                    }
                    Spacer()
                    NavigationLink(destination: Page3View()) {
                        Image(systemName: "magnifyingglass")
                    }
                    Spacer()
                    NavigationLink(destination: Page4View()) {
                        Image(systemName: "person.fill")
                    }
                    Spacer()
                    NavigationLink(destination: Page5View()) {
                        Image(systemName: "gearshape.fill")
                    }
                    Spacer()
                }
                .font(.title)
                .padding(.bottom, 20)
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

                Text(responseMessage) // Show response from Django
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
        guard let url = URL(string: "https://aa9a-5-91-191-155.ngrok-free.app/api/processor/quick_capture/") else {
            responseMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let postData: [String: Any] = [
            "input_type": "text",
            "content": thought,
            "context": additionalContext
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
        } catch {
            responseMessage = "Failed to encode JSON"
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    responseMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    responseMessage = "Response: \(responseString)"
                    isExpanded = false // Close capture view
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        showAcknowledgment = true // Show acknowledgment screen
                    }
                }
            }
        }

        task.resume()
    }
}

// Camera Shutter Acknowledgment View
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
                    .transition(.opacity)  // Smooth fade in/out for the text
            }
        }
        .onAppear {
            // Start with the shutter effect.
            withAnimation(.easeOut(duration: 0.2)) {
                blackoutOpacity = 1.0 // Start fully black.
            }
            
            // After a short delay, show the text from the center.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    showText = true
                    scale = 1  // Shrink to normal size.
                }
            }
            
            // After a moment, fade everything out.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeIn(duration: 0.5)) {
                    blackoutOpacity = 0.0  // Fade to transparent.
                    scale = 0.8          // Shrink further.
                }
            }
            
            // Finally, remove the acknowledgment view.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showAcknowledgment = false
            }
        }
    }
}

// Placeholder destination views for the icons
struct Page1View: View {
    var body: some View {
        Text("Page 1")
            .font(.largeTitle)
            .padding()
    }
}

struct Page2View: View {
    var body: some View {
        Text("Page 2")
            .font(.largeTitle)
            .padding()
    }
}

struct Page3View: View {
    var body: some View {
        Text("Page 3")
            .font(.largeTitle)
            .padding()
    }
}

struct Page4View: View {
    var body: some View {
        Text("Page 4")
            .font(.largeTitle)
            .padding()
    }
}

struct Page5View: View {
    var body: some View {
        Text("Page 5")
            .font(.largeTitle)
            .padding()
    }
}

#Preview {
    QuickCaptureView()
}
