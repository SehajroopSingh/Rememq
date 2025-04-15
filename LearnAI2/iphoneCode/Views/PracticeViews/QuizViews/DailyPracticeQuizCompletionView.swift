//
//  QuizCompletionView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/15/25.
//


struct QuizCompletionView: View {
    @ObservedObject var viewModel: PracticeViewModel
    @State private var submitted = false
    @State private var submissionMessage = "Submitting..."

    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 You've completed all quizzes!")
                .font(.title)
                .multilineTextAlignment(.center)

            if submitted {
                Text(submissionMessage)
                    .foregroundColor(.gray)
            } else {
                ProgressView("Submitting your results...")
            }

            if submitted {
                Button("Done") {
                    // Optionally pop the view or reset session
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .onAppear {
            submit()
        }
    }

    func submit() {
        guard !submitted else { return }

        viewModel.submitQuizSession()
        submitted = true
        submissionMessage = "✅ Session submitted successfully!"
    }
}
