//import SwiftUI
//
//struct FillBlankWithOptionsView: View {
//    let quiz: Quiz
//    var onAnswer: ((Bool, Double, String) -> Void)? = nil
//
//    @State private var selectedIndex: Int?
//    @State private var showExplanation = false
//
//    init(quiz: Quiz, onAnswer: ((Bool, Double, String) -> Void)? = nil) {
//        self.quiz = quiz
//        self.onAnswer = onAnswer
//
//        print("📥 [DEBUG] Quiz ID: \(quiz.id)")
//        print("📋 Question: \(quiz.question_text ?? "No question")")
//        print("✅ Choices: \(quiz.choices ?? [])")
//        print("⭐️ Correct Index: \(quiz.correctAnswerIndex ?? -1)")
//    }
//
//    @State private var selectedOption: Int?
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text(quiz.question_text ?? "Choose the correct word to fill in:")
//                .font(.headline)
//
//            if let options = quiz.options {
//
//                ForEach(options.indices, id: \.self) { index in
//                    Button(action: {
//                        selectedOption = index
//                    }) {
//                        HStack {
//                            Image(systemName: selectedOption == index ? "largecircle.fill.circle" : "circle")
//                            Text(options[index])
//                        }
//                    }
//                    .foregroundColor(.primary)
//                }
//            }
//
//            if let explanation = quiz.explanation {
//                Text("Explanation: \(explanation)")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .padding(.top)
//            }
//        }
//    }
//}
import SwiftUI

struct FillBlankWithOptionsView: View {
    let quiz: Quiz
    @ObservedObject var viewModel: PracticeViewModel

    @State private var selectedOption: Int?
    @State private var submitted = false
    @State private var showExplanation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quiz.question_text ?? "Choose the correct word to fill in:")
                .font(.headline)

            if let options = quiz.options {
                ForEach(options.indices, id: \.self) { index in
                    Button(action: {
                        if !submitted {
                            selectedOption = index
                            handleSubmission(index: index)
                        }
                    }) {
                        HStack {
                            Image(systemName: selectedOption == index ? "largecircle.fill.circle" : "circle")
                            Text(options[index])
                            Spacer()
                            if submitted && selectedOption == index {
                                Image(systemName: index == quiz.correctAnswerIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(index == quiz.correctAnswerIndex ? .green : .red)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .disabled(submitted)
                    .foregroundColor(.primary)
                }
            }

            if showExplanation, let explanation = quiz.explanation {
                Text("Explanation: \(explanation)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
    }

    func handleSubmission(index: Int) {
        showExplanation = true
        submitted = true

        let isCorrect = index == quiz.correctAnswerIndex
        let userInput = String(index)

        viewModel.recordResponse(
            for: quiz,
            wasCorrect: isCorrect,
            score: isCorrect ? 1.0 : 0.0,
            userInput: userInput
        )
    }
}
