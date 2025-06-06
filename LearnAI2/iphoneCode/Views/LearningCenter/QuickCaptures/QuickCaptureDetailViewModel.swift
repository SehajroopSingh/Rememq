
import Foundation
import Combine

class QuickCaptureDetailViewModel: ObservableObject {
    @Published var directQuizzes: [Quiz] = []
    @Published var mainPointsWithQuizzes: [MainPointWithQuizzes] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func loadQuizzes(for qcID: Int) {
        let endpoint = "organizer/quickcaptures/\(qcID)/mainpoints_and_quizzes/"

        APIService.shared.performRequest(endpoint: endpoint) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let raw = String(data: data, encoding: .utf8) {
                        print("🧾 Raw response: \(raw)")  // 👈 Add this line
                    }
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(QuickCaptureQuizResponse.self, from: data)
                        self?.directQuizzes = response.directQuizzes
                        self?.mainPointsWithQuizzes = response.mainPoints
                        print("✅ Loaded \(response.directQuizzes.count) direct quizzes")
                        print("✅ Loaded \(response.mainPoints.count) main points with quizzes")

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
}



struct QuickCaptureQuizResponse: Codable {
    let quickCaptureId: Int
    let directQuizzes: [Quiz]
    let mainPoints: [MainPointWithQuizzes]

    enum CodingKeys: String, CodingKey {
        case quickCaptureId = "quick_capture_id"
        case directQuizzes = "direct_quizzes"
        case mainPoints = "main_points"
    }
}



//struct MainPointWithQuizzes: Codable {
//    let id: Int
//    let text: String
//    let context: String?
//    let state: QuizState?  // ✅ Reuse QuizState
//    let quizzes: [Quiz]
//}


struct MainPointWithQuizzes: Codable, Identifiable {
    let id: Int
    let text: String
    let context: String?
    let supportingText: String?
    let order: Int?
    let state: QuizState?
    let quizzes: [Quiz]
    let subpoints: [SubPointWithQuizzes]

    enum CodingKeys: String, CodingKey {
        case id, text, context, state, quizzes, subpoints
        case supportingText = "supporting_text"
        case order
    }
}

struct SubPointWithQuizzes: Codable , Identifiable{
    let id: Int
    let text: String
    let context: String?
    let supportingText: String?    // ✅ Add this line
    let state: QuizState?
    let quizzes: [Quiz]

    enum CodingKeys: String, CodingKey {
        case id, text, context, state, quizzes
        case supportingText = "supporting_text"
    }
}
