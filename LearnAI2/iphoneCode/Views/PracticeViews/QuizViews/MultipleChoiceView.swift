import SwiftUI

struct MultipleChoiceView: View {
    let quiz: Quiz
    @ObservedObject var viewModel: PracticeViewModel

    
    @State private var selectedIndex: Int? = nil
    @State private var showExplanation = false


    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Question
            Text(quiz.question_text ?? "Select the correct answer:")
                .font(.headline)

            // Options
            ForEach(quiz.choices?.indices ?? 0..<0, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                    showExplanation = true
                    let isCorrect = (index == quiz.correctAnswerIndex)
                    viewModel.recordResponse(
                        for: quiz,
                        wasCorrect: isCorrect,
                        score: isCorrect ? 1.0 : 0.0,
                        userInput: String(index)
                    )
                }) {
                    HStack {
                        Text(quiz.choices?[index] ?? "")
                            .foregroundColor(.primary)
                        Spacer()
                        if let selected = selectedIndex {
                            if selected == index {
                                Image(systemName: selected == quiz.correctAnswerIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(selected == quiz.correctAnswerIndex ? .green : .red)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .disabled(showExplanation)
            }

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
