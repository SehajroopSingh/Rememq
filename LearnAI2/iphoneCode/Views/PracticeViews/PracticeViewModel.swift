import SwiftUI
import Combine

enum PracticeContext {
    case fromDashboard
    case daily(limit: Int)
    case fromSet(id: Int)
    case fromGroup(id: Int)
    case fromSpace(id: Int)
}

@MainActor
class PracticeViewModel: ObservableObject {
    @Published var context: PracticeContext? = nil

    @Published var quizzes: [Quiz] = []
    @Published var currentIndex: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var sessionID: String?
    @Published var startingHearts: Int = 5  // Default to 3, will be updated by backend
    @Published var remainingHearts: Int = 3
    var initialDashboardSnapshot: DashboardData?

    
    // ✅ Store user answers here
    @Published var submittedResults: [Int: QuizResult] = [:]  // key = quiz_id


    var currentQuiz: Quiz? {
        guard currentIndex >= 0 && currentIndex < quizzes.count else { return nil }
        return quizzes[currentIndex]
    }

    var hasAnsweredCurrentQuiz: Bool {
        guard let currentQuiz = currentQuiz else { return false }
        return submittedResults[currentQuiz.id] != nil
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
                        self?.startingHearts = response.starting_hearts ?? 5
                        self?.remainingHearts = response.starting_hearts ?? 5

                        print("✅ Successfully parsed \(response.quizzes.count) quizzes")
                        print("🔍 First quiz description: \(self?.quizzes.first?.short_description ?? "nil")")
                        print("👤 Initial author: \(self?.quizzes.first?.initial_author?.description ?? "nil")")
                        print("📊 Mastery level: \(self?.quizzes.first?.previous_performance?.mastery_level ?? -1)")


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
    
    
    func loadQuizzesFromSet(setId: Int, limit: Int = 10) {
        isLoading = true
        errorMessage = nil

        let endpoint = "scheduler/sets/\(setId)/practice/?limit=\(limit)"
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
                        self?.startingHearts = response.starting_hearts ?? 5
                        self?.remainingHearts = response.starting_hearts ?? 5

                        print("✅ Successfully parsed \(response.quizzes.count) quizzes (set practice)")

                    } catch {
                        print("❌ Decoding error (set practice): \(error)")
                        self?.errorMessage = "Failed to parse quizzes: \(error.localizedDescription)"
                    }

                case .failure(let error):
                    print("❌ API error (set practice): \(error)")
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
        // Subtract heart if incorrect and not already submitted
        if submittedResults[quiz.id] == nil && !wasCorrect {
            remainingHearts = max(0, remainingHearts - 1)
        }
        submittedResults[quiz.id] = result
    }
    
    
//    
//    func submitQuizSession() {
//        guard let sessionID = sessionID else {
//            print("⚠️ No session ID")
//            return
//        }
//        
//        let payload: [String: Any] = [
//            "session_id": sessionID,
//            "results": submittedResults.values.map {
//                [
//                    "quiz_id": $0.quiz_id,
//                    "was_correct": $0.was_correct,
//                    "score": $0.score,
//                    "response_data": $0.response_data
//                ]
//            }
//        ]
//
//        APIService.shared.performRequest(
//            endpoint: "scheduler/submit-session/",
//            method: "POST",
//            body: payload
//        ) { result in
//            switch result {
//            case .success:
//                print("✅ Session submitted successfully.")
//            case .failure(let error):
//                print("❌ Submission failed: \(error.localizedDescription)")
//            }
//        }
//    }
//    func submitQuizSession(completion: @escaping (Result<SessionResultResponse, Error>) -> Void) {
//        guard let sessionID = sessionID else {
//            print("⚠️ No session ID")
//            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No session ID"])))
//            return
//        }
//
//        let payload: [String: Any] = [
//            "session_id": sessionID,
//            "results": submittedResults.values.map {
//                [
//                    "quiz_id": $0.quiz_id,
//                    "was_correct": $0.was_correct,
//                    "score": $0.score,
//                    "response_data": $0.response_data
//                ]
//            }
//        ]
//                
//                APIService.shared.performRequest(
//                    endpoint: "scheduler/submit-session/",
//                    method: "POST",
//                    body: payload
//                ) { result in
//                    switch result {
//                    case .success(let data):
//                        do {
//                            let decoded = try JSONDecoder().decode(SessionResultResponse.self, from: data)
//                            print("✅ Submission success with result: \(decoded)")
//                            completion(.success(decoded))
//                        } catch {
//                            print("❌ Decoding error: \(error)")
//                            completion(.failure(error))
//                        }
//                    case .failure(let error):
//                        print("❌ Submission failed: \(error.localizedDescription)")
//                        completion(.failure(error))
//                    }
//                }
//            }
    func submitQuizSession(completion: @escaping (Result<SessionResultResponse, Error>) -> Void) {
        guard let sessionID = sessionID else {
            print("⚠️ No session ID")
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No session ID"])))
            return
        }

        let resultsArray = submittedResults.values.map {
            [
                "quiz_id": $0.quiz_id,
                "was_correct": $0.was_correct,
                "score": $0.score,
                "response_data": $0.response_data
            ]
        }

        guard !resultsArray.isEmpty else {
            print("🚫 No quiz results to submit. Skipping submission.")
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No quiz results to submit"])))
            return
        }

        let payload: [String: Any] = [
            "session_id": sessionID,
            "results": resultsArray
        ]

        APIService.shared.performRequest(
            endpoint: "scheduler/submit-session/",
            method: "POST",
            body: payload
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(SessionResultResponse.self, from: data)
                    print("✅ Submission success with result: \(decoded)")
                    completion(.success(decoded))
                } catch {
                    print("❌ Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ Submission failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

}

    


// Matches the API JSON response format: { "quizzes": [ ... ] }
private struct QuizResponse: Codable {
    
    let session_id: String
    let quizzes: [Quiz]
    let starting_hearts: Int?  // ← Add this (optional in case backend doesn't return it yet)

}


struct QuizResult: Codable {
    let quiz_id: Int
    let was_correct: Bool
    let score: Double
    let response_data: [String: String]  // keep it simple and flexible
}


struct SessionResultResponse: Codable {
    let message: String
    let xpDelta: Int
    let pointsDelta: Int
    let coinsDelta: Int

    enum CodingKeys: String, CodingKey {
        case message
        case xpDelta = "xp_delta"
        case pointsDelta = "points_delta"
        case coinsDelta = "coins_delta"
    }
}
