import SwiftUI

struct QuickCaptureDetailView: View {
    let quickCapture: QuickCaptureModel
    @StateObject private var viewModel = QuickCaptureDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // … your existing Content/Context/Highlights …

                Text("Quizzes")
                  .font(.headline)
                
                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else if viewModel.quizzes.isEmpty {
                    Text("Loading quizzes…")
                        .italic()
                } else {
                    ForEach(viewModel.quizzes) { quiz in
                        DisclosureGroup(
                            isExpanded: .constant(false),
                            content: {
                                switch quiz.quiz_type {
                                case .multipleChoice:
                                    if let q = quiz.question_text {
                                        Text(q)
                                            .font(.subheadline)
                                            .padding(.bottom, 4)
                                    }
                                    ForEach(quiz.choices ?? [], id: \.self) { choice in
                                        Text("• \(choice)")
                                    }
                                    if let idx = quiz.correctAnswerIndex,
                                       idx < (quiz.choices?.count ?? 0) {
                                        Text("Answer: \(quiz.choices![idx])")
                                            .italic()
                                            .padding(.top, 4)
                                    }
                                    
                                case .trueFalse:
                                    if let stmt = quiz.statement {
                                        Text(stmt)
                                            .font(.subheadline)
                                            .padding(.bottom, 4)
                                    }
                                    if let ans = quiz.trueFalseAnswer {
                                        Text("Answer: \(ans)")
                                            .italic()
                                    }
                                    
                                case .fillBlank:
                                    if let q = quiz.fillBlankQuestion {
                                        Text(q)
                                            .font(.subheadline)
                                            .padding(.bottom, 4)
                                    }
                                    if let ans = quiz.fillBlankAnswer {
                                        Text("Answer: \(ans)")
                                            .italic()
                                    }
                                    
                                case .fillBlankWithOptions:
                                    if let q = quiz.fillBlankQuestion {
                                        Text(q)
                                            .font(.subheadline)
                                            .padding(.bottom, 4)
                                    }
                                    ForEach(quiz.options ?? [], id: \.self) { opt in
                                        Text("• \(opt)")
                                    }
                                    if let ans = quiz.fillBlankAnswer {
                                        Text("Answer: \(ans)")
                                            .italic()
                                            .padding(.top, 4)
                                    }
                                }
                            },
                            label: {
                                Text(quiz.quiz_type.rawValue
                                      .replacingOccurrences(of: "_", with: " ")
                                      .capitalized)
                                  .font(.body)
                                  .bold()
                            }
                        )
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary)
                        )
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Quick Capture Details")
        .onAppear {
            viewModel.loadQuizzes(for: quickCapture.id)
        }
    }
}
