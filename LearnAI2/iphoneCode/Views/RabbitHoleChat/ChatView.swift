import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            // Messages list
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        MessageBubbleView(message: message) {
                            // Called when user chooses "Add to Captures" from context menu
                            viewModel.addTextToCaptures(message.content)
                        }
                    }
                }
                .padding(.horizontal)
            }

            // Input area
            HStack {
                TextField("Type your message...", text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Text("Send")
                }
                .disabled(viewModel.inputText.isEmpty)
            }
            .padding()
        }
        .navigationTitle("AI Chat")
    }
}

// A simple bubble-like view for each message
struct MessageBubbleView: View {
    let message: ChatMessage
    let onCaptureSelected: () -> Void

    var body: some View {
        Group {
            if message.sender == "user" {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .contextMenu {
                            Button("Add to Captures", action: onCaptureSelected)
                        }
                }
            } else {
                // AI message (left-aligned)
                HStack {
                    Text(message.content)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .contextMenu {
                            Button("Add to Captures", action: onCaptureSelected)
                        }
                    Spacer()
                }
            }
        }
    }
}
