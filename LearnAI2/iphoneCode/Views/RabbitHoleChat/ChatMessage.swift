import SwiftUI

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let content: String
    let sender: String       // e.g. "user" or "ai"
}

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""

    // Example of a function that hits your AI endpoint
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = ChatMessage(content: inputText, sender: "user")
        messages.append(userMessage)   // Add user message to chat locally

        let prompt = inputText
        inputText = ""  // clear the input box

        // Send the text to your AI model endpoint
        let endpoint = "chat"  // Adjust to match your actual API endpoint

        let body: [String: Any] = [
            "prompt": prompt
        ]

        APIService.shared.performRequest(endpoint: endpoint,
                                         method: "POST",
                                         body: body) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    // Parse the response JSON from AI
                    if let aiReply = self?.parseAIResponse(data: data) {
                        let aiMessage = ChatMessage(content: aiReply, sender: "ai")
                        self?.messages.append(aiMessage)
                    }
                case .failure(let error):
                    print("Error sending message: \(error.localizedDescription)")
                }
            }
        }
    }

    // Rudimentary parser for AI response
    private func parseAIResponse(data: Data) -> String {
        if let raw = String(data: data, encoding: .utf8), !raw.isEmpty {
            // If your response is just text, or you can do JSON decode here
            return raw
        }
        return "No response"
    }

    // Example function for adding text to "captures"
    func addTextToCaptures(_ snippet: String) {
        let endpoint = "captures"  // Or whatever your API endpoint is for captures

        let body: [String: Any] = [
            "text": snippet
        ]

        APIService.shared.performRequest(endpoint: endpoint,
                                         method: "POST",
                                         body: body) { result in
            switch result {
            case .success(_):
                print("Successfully added snippet to captures.")
            case .failure(let error):
                print("Error adding snippet to captures: \(error.localizedDescription)")
            }
        }
    }
}
