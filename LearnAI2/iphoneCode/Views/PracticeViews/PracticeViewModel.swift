import SwiftUI
import Combine

class PracticeViewModel: ObservableObject {
    @Published var quizzes: [Quiz] = []
    @Published var currentIndex: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func loadQuizzes(limit: Int = 10) {
        isLoading = true
        errorMessage = nil

        APIService.shared.fetchScheduledQuizzes(limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedQuizzes):
                    self?.quizzes = fetchedQuizzes
                    self?.currentIndex = 0
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func nextQuiz() {
        if currentIndex < quizzes.count - 1 {
            currentIndex += 1
        }
    }

    func prevQuiz() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
}
