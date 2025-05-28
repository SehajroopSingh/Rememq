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
                .foregroundColor(.primary)

            // Answer input
            TextField("Type your answer here", text: $userAnswer)
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                            .background(.ultraThinMaterial)
                            .blur(radius: 0.3)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.5), Color.white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                )
                .shadow(color: .white.opacity(0.15), radius: 2, x: -1, y: -1)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 2)
                .disabled(submitted)

            // Submit button
            Button(action: {
                handleSubmission()
            }) {
                Text("Check Answer")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                                .background(.ultraThinMaterial)
                                .blur(radius: 0.3)
                            
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.5), Color.white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        }
                    )
                    .shadow(color: .white.opacity(0.15), radius: 2, x: -1, y: -1)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 2)
            }
            .disabled(submitted || userAnswer.isEmpty)

            if submitted || showExplanation {
                VStack(alignment: .leading, spacing: 8) {
                    // Explanation
                    if let explanation = quiz.explanation {
                        Text("Explanation: \(explanation)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    if submitted {
                        let isCorrect = userAnswer.trimmed.lowercased() == (quiz.fillBlankAnswer ?? "").lowercased()
                        HStack {
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isCorrect ? .green : .red)
                            Text(isCorrect ? "Correct!" : "Incorrect")
                                .foregroundColor(isCorrect ? .green : .red)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
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
