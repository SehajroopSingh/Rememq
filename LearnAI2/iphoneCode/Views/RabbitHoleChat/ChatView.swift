////
////  ChatView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 3/13/25.
////
//
//
//import SwiftUI
//
//struct ChatView: View {
//    @StateObject var viewModel: ChatViewModel  // No default initialization here
//
//    init(viewModel: ChatViewModel = ChatViewModel()) {
//        _viewModel = StateObject(wrappedValue: viewModel)
//    }
//
//    var body: some View {
//        VStack {
//            // Messages list
//            ScrollView {
//                LazyVStack(alignment: .leading, spacing: 12) {
//                    ForEach(viewModel.messages) { message in
//                        MessageBubbleView(message: message) {
//                            viewModel.addTextToCaptures(message.content)
//                        }
//                    }
//                }
//                .padding(.horizontal)
//            }
//
//            // Input area
//            HStack {
//                TextField("Type your message...", text: $viewModel.inputText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                Button(action: {
//                    viewModel.sendMessage()
//                }) {
//                    Text("Send")
//                }
//                .disabled(viewModel.inputText.isEmpty)
//            }
//            .padding()
//        }
//        .navigationTitle("AI Chat")
//    }
//}
//
//
//// A simple bubble-like view for each message
//struct MessageBubbleView: View {
//    let message: ChatMessage
//    let onCaptureSelected: () -> Void
//
//    var body: some View {
//        Group {
//            if message.sender == "user" {
//                HStack {
//                    Spacer()
//                    Text(message.content)
//                        .padding(8)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(8)
//                        .contextMenu {
//                            Button("Add to Captures", action: onCaptureSelected)
//                        }
//                }
//            } else {
//                // AI message (left-aligned)
//                HStack {
//                    Text(message.content)
//                        .padding(8)
//                        .background(Color.blue.opacity(0.1))
//                        .cornerRadius(8)
//                        .contextMenu {
//                            Button("Add to Captures", action: onCaptureSelected)
//                        }
//                    Spacer()
//                }
//            }
//        }
//    }
//}
//
////struct ChatView_Previews: PreviewProvider {
////    static var previews: some View {
////        ChatView()
////    }
////}
////struct ChatView_Previews: PreviewProvider {
////    static var previews: some View {
////        let mockViewModel = ChatViewModel()
////        mockViewModel.messages = [
////            ChatMessage(content: "Hello, AI!", sender: "user"),
////            ChatMessage(content: "Hi! How can I help?", sender: "ai")
////        ]
////        
////        return ChatView()
////            .environmentObject(mockViewModel)  // Inject preview data
////    }
////}
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockViewModel = ChatViewModel()
//        mockViewModel.messages = [
//            ChatMessage(content: "Hello, AI!", sender: "user"),
//            ChatMessage(content: "Hi! How can I help?", sender: "ai")
//        ]
//
//        return ChatView(viewModel: mockViewModel)  // Inject mock ViewModel
//    }
//}

import SwiftUI

struct ChatView: View {
    var body: some View {
        VStack {
            Text("Chat View Placeholder")
                .font(.largeTitle)
                .padding()
            Text("This view will eventually display chat messages.")
                .foregroundColor(.gray)
        }
        .navigationTitle("Chat")
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
        }
    }
}
