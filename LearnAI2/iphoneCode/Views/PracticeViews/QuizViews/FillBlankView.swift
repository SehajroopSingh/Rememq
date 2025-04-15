import SwiftUI

struct FillBlankView: View {
    let quiz: Quiz
    @State private var userAnswer: String = ""
    @State private var showExplanation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Question
            Text(quiz.fillBlankQuestion ?? "Fill in the blank:")
                .font(.headline)

            // Answer input
            TextField("Type your answer here", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical)

            // Submit button
            Button(action: {
                showExplanation = true
            }) {
                Text("Check Answer")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            // Explanation
            if showExplanation, let explanation = quiz.explanation {
                Text("Explanation: \(explanation)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
    }
}
