import SwiftUI

struct QuickCapturesListView: View {
    @State private var quickCaptures: [QuickCapture] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading quick captures...")
                } else if let errorMessage = errorMessage {
                    VStack {
                        Text("Error")
                            .font(.title)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else if quickCaptures.isEmpty {
                    Text("No quick captures available.")
                        .foregroundColor(.gray)
                } else {
                    List(quickCaptures) { capture in
                        VStack(alignment: .leading) {
                            Text(capture.content)
                                .font(.headline)
                            Text("Summary: \(capture.summary)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Quick Captures")
            .onAppear {
                fetchQuickCaptures()
            }
        }
    }

    // Fetch quick captures using your APIService
    private func fetchQuickCaptures() {
        APIService.shared.performRequest(endpoint: "processor/quick-captures/") { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(QuickCapturesResponse.self, from: data)
                        self.quickCaptures = decodedResponse.captures
                    } catch {
                        self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    self.errorMessage = "Failed to fetch: \(error.localizedDescription)"
                }
            }
        }
    }
}

// Data Model for Quick Capture
struct QuickCapture: Identifiable, Codable {
    let id: Int
    let content: String
    let summary: String
    let category: String?
    let created_at: String?
}

// Response wrapper (matches Django API structure)
struct QuickCapturesResponse: Codable {
    let captures: [QuickCapture]
}

#Preview {
    QuickCapturesListView()
}
