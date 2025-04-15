import SwiftUI

struct TrueFalseView: View {
    let quiz: Quiz
    @ObservedObject var viewModel: PracticeViewModel

    @State private var selected: String? = nil
    @State private var showExplanation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quiz.statement ?? "True or False?")
                .font(.headline)

            HStack {
                Button("True") {
                    handleAnswer("true")
                }
                .buttonStyle(.bordered)
                .disabled(showExplanation)

                Button("False") {
                    handleAnswer("false")
                }
                .buttonStyle(.bordered)
                .disabled(showExplanation)
            }

            if showExplanation, let explanation = quiz.explanation {
                Text("Explanation: \(explanation)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            if let selected = selected {
                Text("You answered: \(selected.capitalized)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
    }

    func handleAnswer(_ userAnswer: String) {
        selected = userAnswer
        showExplanation = true

        let isCorrect = (userAnswer == quiz.trueFalseAnswer)
        viewModel.recordResponse(
            for: quiz,
            wasCorrect: isCorrect,
            score: isCorrect ? 1.0 : 0.0,
            userInput: userAnswer
        )
    }
}
