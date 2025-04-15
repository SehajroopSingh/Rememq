//import SwiftUI
//
//struct FillBlankView: View {
//    let quiz: Quiz
//    @State private var userAnswer: String = ""
//    @State private var showExplanation = false
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // Question
//            Text(quiz.fillBlankQuestion ?? "Fill in the blank:")
//                .font(.headline)
//
//            // Answer input
//            TextField("Type your answer here", text: $userAnswer)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(.vertical)
//
//            // Submit button
//            Button(action: {
//                showExplanation = true
//            }) {
//                Text("Check Answer")
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//
//            // Explanation
//            if showExplanation, let explanation = quiz.explanation {
//                Text("Explanation: \(explanation)")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .padding(.top)
//            }
//        }
//    }
//}


import SwiftUI

struct FillBlankView: View {
    let quiz: Quiz
    @ObservedObject var viewModel: PracticeViewModel

    @State private var userAnswer: String = ""
    @State private var showExplanation = false
    @State private var submitted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Question
            Text(quiz.fillBlankQuestion ?? "Fill in the blank:")
                .font(.headline)

            // Answer input
            TextField("Type your answer here", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical)
                .disabled(submitted)

            // Submit button
            Button(action: {
                handleSubmission()
            }) {
                Text("Check Answer")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(submitted || userAnswer.isEmpty)

            // Explanation
            if showExplanation, let explanation = quiz.explanation {
                Text("Explanation: \(explanation)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top)
            }

            if submitted {
                let isCorrect = userAnswer.trimmed.lowercased() == (quiz.fillBlankAnswer ?? "").lowercased()
                Text(isCorrect ? "✅ Correct!" : "❌ Incorrect")
                    .font(.subheadline)
                    .foregroundColor(isCorrect ? .green : .red)
            }
        }
    }
    

    func handleSubmission() {
        showExplanation = true
        submitted = true

        let isCorrect = userAnswer.trimmed.lowercased() == (quiz.fillBlankAnswer ?? "").lowercased()
        viewModel.recordResponse(
            for: quiz,
            wasCorrect: isCorrect,
            score: isCorrect ? 1.0 : 0.0,
            userInput: userAnswer
        )
    }
}
extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
