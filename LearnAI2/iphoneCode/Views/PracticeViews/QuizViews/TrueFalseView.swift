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
                .foregroundColor(.primary)

            HStack(spacing: 16) {
                Button("True") {
                    handleAnswer("true")
                }
                .buttonStyle(GlassButtonStyle(isDisabled: showExplanation))
                .disabled(showExplanation)

                Button("False") {
                    handleAnswer("false")
                }
                .buttonStyle(GlassButtonStyle(isDisabled: showExplanation))
                .disabled(showExplanation)
            }
            .padding(.vertical, 8)

            if showExplanation {
                VStack(alignment: .leading, spacing: 8) {
                    if let explanation = quiz.explanation {
                        Text("Explanation: \(explanation)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    if let selected = selected {
                        let isCorrect = selected == quiz.trueFalseAnswer
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

struct GlassButtonStyle: ButtonStyle {
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
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
            .foregroundColor(isDisabled ? .gray : .primary)
            .shadow(color: .white.opacity(0.15), radius: 2, x: -1, y: -1)
            .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
