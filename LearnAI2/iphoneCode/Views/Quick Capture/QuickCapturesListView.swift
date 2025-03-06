import SwiftUI

struct QuickCapturesListView: View {
    @State private var quickCaptures: [QuickCapture] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    // Group captures by category
    private var groupedCaptures: [String: [QuickCapture]] {
        Dictionary(grouping: quickCaptures, by: { $0.category ?? "Uncategorized" })
    }

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
                    List(groupedCaptures.keys.sorted(), id: \.self) { category in
                        NavigationLink(destination: CategoryDetailView(category: category, captures: groupedCaptures[category] ?? [])) {
                            Text(category)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Quick Captures")
            .onAppear {
                print("🟡 QuickCapturesListView appeared. Fetching captures...")
                fetchQuickCaptures()
            }
        }
    }

    // Fetch quick captures using your APIService
    private func fetchQuickCaptures() {
        print("🌐 Fetching quick captures from API...")  // LOG: Fetch started

        APIService.shared.performRequest(endpoint: "processor/list_quick_captures/") { result in
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let data):
                    print("✅ Success! Received data from API.")  // LOG: Data received
                    if let rawString = String(data: data, encoding: .utf8) {
                        print("📜 Raw JSON response:\n\(rawString)")  // LOG: Print raw JSON
                    } else {
                        print("⚠️ Warning: Unable to convert data to string.")
                    }

                    do {
                        print("🔍 Decoding JSON response...")
                        let decodedResponse = try JSONDecoder().decode(QuickCapturesResponse.self, from: data)
                        self.quickCaptures = decodedResponse.captures
                        print("✅ Successfully decoded JSON. Total captures: \(self.quickCaptures.count)")  // LOG: Decoding success
                    } catch {
                        print("❌ Decoding error: \(error.localizedDescription)")  // LOG: Decoding failed
                        self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    }

                case .failure(let error):
                    print("🔴 API Request failed: \(error.localizedDescription)")  // LOG: API error
                    self.errorMessage = "Failed to fetch: \(error.localizedDescription)"
                }
            }
        }
    }
}

// View that shows captures for a specific category
struct CategoryDetailView: View {
    let category: String
    let captures: [QuickCapture]

    var body: some View {
        List(captures) { capture in
            NavigationLink(destination: QuickCaptureDetailView(capture: capture)) {
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
        .navigationTitle(category)
        .onAppear {
            print("🟢 CategoryDetailView appeared for category: \(category)")
        }
    }
}
struct QuickCaptureDetailView: View {
    let capture: QuickCapture

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Content:")
                    .font(.title2)
                    .bold()
                Text(capture.content)

                Text("Summary:")
                    .font(.title2)
                    .bold()
                Text(capture.summary)

                // ✅ Extracted into a separate view
                if !capture.quizzes.isEmpty {
                    QuizListView(quizzes: capture.quizzes)
                } else {
                    Text("No quizzes available for this capture.")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .navigationTitle("Quick Capture Detail")
        .onAppear {
            print("🟢 QuickCaptureDetailView appeared for capture ID: \(capture.id)")
        }
    }
}

// ✅ Separate quiz list view
struct QuizListView: View {
    let quizzes: [Quiz]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quiz Questions:")
                .font(.title2)
                .bold()

            ForEach(quizzes) { quiz in
                QuizCardView(quiz: quiz)
            }
        }
    }
}

//// ✅ Separate quiz card view
//struct QuizCardView: View {
//    let quiz: Quiz
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            Text(quiz.question)
//                .font(.headline)
//            if let choices = quiz.choices {
//                ForEach(choices, id: \.self) { choice in
//                    Text("• \(choice)")
//                }
//            }
//            Text("✅ Answer: \(quiz.correct_answer)")
//                .font(.subheadline)
//                .foregroundColor(.green)
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(8)
//    }
//}
//
//
struct QuickCapture: Identifiable, Codable {
    let id: Int
    let content: String
    let summary: String
    let category: String?
    let created_at: String?
    let quizzes: [Quiz]  // ✅ Added quizzes
}

struct Quiz: Identifiable, Codable {
    let id: Int
    let question: String
    let choices: [String]?
    let correct_answer: String  // ✅ Use this name
    let quiz_type: String       // ✅ Matches API response

    enum CodingKeys: String, CodingKey {
        case id
        case question
        case choices
        case correct_answer = "correct_answer"  // ✅ Matches JSON key from API
        case quiz_type = "quiz_type"            // ✅ Matches JSON key from API
    }
}

// Response wrapper (matches Django API structure)
struct QuickCapturesResponse: Codable {
    let captures: [QuickCapture]
}

#Preview {
    QuickCapturesListView()
}
