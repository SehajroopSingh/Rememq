import SwiftUI
import Combine

class PracticeViewModel: ObservableObject {
    @Published var quizzes: [Quiz] = []
    @Published var currentIndex: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var sessionID: String?
    
    // ✅ Store user answers here
    @Published var submittedResults: [Int: QuizResult] = [:]  // key = quiz_id


    var currentQuiz: Quiz? {
        guard currentIndex >= 0 && currentIndex < quizzes.count else { return nil }
        return quizzes[currentIndex]
    }

    func loadQuizzes(limit: Int = 10) {
        isLoading = true
        errorMessage = nil

        let endpoint = "scheduler/scheduled-quizzes/?limit=\(limit)"
        //let endpoint = "scheduler/scheduled-quizzes/"
        APIService.shared.performRequest(endpoint: endpoint) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let data):
                    do {
                        let rawString = String(data: data, encoding: .utf8) ?? "Unable to decode to string"
                        print("📥 Raw JSON:\n\(rawString)")

                        let decoder = JSONDecoder()
                        let response = try decoder.decode(QuizResponse.self, from: data)
                        self?.quizzes = response.quizzes
                        self?.sessionID = response.session_id
                        self?.currentIndex = 0
                        print("✅ Successfully parsed \(response.quizzes.count) quizzes")

                    } catch {
                        print("❌ Decoding error: \(error)")
                        self?.errorMessage = "Failed to parse quizzes: \(error.localizedDescription)"
                    }

                case .failure(let error):
                    print("❌ API error: \(error)")
                    self?.errorMessage = "API Error: \(error.localizedDescription)"
                }
            }
        }
    }

    func nextQuiz() {
        if currentIndex < quizzes.count{
            currentIndex += 1
        }
    }

    func prevQuiz() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    
    
    
    func recordResponse(for quiz: Quiz, wasCorrect: Bool, score: Double, userInput: String) {
        var responseData: [String: String] = [:]

        switch quiz.quiz_type {
        case .multipleChoice:
            responseData = ["selected_index": userInput]

        case .trueFalse:
            responseData = ["selected": userInput]

        case .fillBlank, .fillBlankWithOptions:
            responseData = ["text": userInput]

        default:
            responseData = ["answer": userInput]
        }

        let result = QuizResult(
            quiz_id: quiz.id,
            was_correct: wasCorrect,
            score: score,
            response_data: responseData
        )

        submittedResults[quiz.id] = result
    }
    
    
    
    func submitQuizSession() {
        guard let sessionID = sessionID else {
            print("⚠️ No session ID")
            return
        }

        let payload: [String: Any] = [
            "session_id": sessionID,
            "results": submittedResults.values.map {
                [
                    "quiz_id": $0.quiz_id,
                    "was_correct": $0.was_correct,
                    "score": $0.score,
                    "response_data": $0.response_data
                ]
            }
        ]

        APIService.shared.performRequest(
            endpoint: "scheduler/submit-session/",
            method: "POST",
            body: payload
        ) { result in
            switch result {
            case .success:
                print("✅ Session submitted successfully.")
            case .failure(let error):
                print("❌ Submission failed: \(error.localizedDescription)")
            }
        }
    }
    
}

    
    
    
    

// Matches the API JSON response format: { "quizzes": [ ... ] }
private struct QuizResponse: Codable {
    let session_id: String
    let quizzes: [Quiz]
}





struct QuizResult: Codable {
    let quiz_id: Int
    let was_correct: Bool
    let score: Double
    let response_data: [String: String]  // keep it simple and flexible
}
