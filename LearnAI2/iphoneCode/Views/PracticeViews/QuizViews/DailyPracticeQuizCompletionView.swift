////
////  QuizCompletionView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 4/15/25.
////
//import SwiftUI
//
//struct DailyPracticeQuizCompletionView: View {
//    @ObservedObject var viewModel: PracticeViewModel
//    @State private var submitted = false
//    @State private var submissionMessage = "Submitting..."
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("🎉 You've completed all quizzes!")
//                .font(.title)
//                .multilineTextAlignment(.center)
//
//            if submitted {
//                Text(submissionMessage)
//                    .foregroundColor(.gray)
//            } else {
//                ProgressView("Submitting your results...")
//            }
//
//            if submitted {
//                Button("Done") {
//                    // Optionally pop the view or reset session
//                }
//                .buttonStyle(.borderedProminent)
//            }
//        }
//        .padding()
//        .onAppear {
//            submit()
//        }
//    }
//
//    func submit() {
//        guard !submitted else { return }
//
//        viewModel.submitQuizSession()
//        submitted = true
//        submissionMessage = "✅ Session submitted successfully!"
//    }
//}
import SwiftUI

struct DailyPracticeQuizCompletionView: View {
    @ObservedObject var viewModel: PracticeViewModel

    @State private var isLoading = true
    @State private var result: SessionResultResponse?
    @State private var error: String?

    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView("Calculating Results...")
            } else if let error = error {
                Text("⚠️ Error: \(error)")
                    .foregroundColor(.red)
            } else if let result = result {
                let oldXP = viewModel.initialDashboardSnapshot?.xp ?? 0
                let oldGems = viewModel.initialDashboardSnapshot?.gems ?? 0
                let oldStreak = viewModel.initialDashboardSnapshot?.streak ?? 0

                let newXP = oldXP + result.xpDelta
                let newGems = oldGems + result.coinsDelta
                let newStreak = oldStreak + result.pointsDelta

                VStack(spacing: 12) {
                    Text("🎉 Session Complete!")
                        .font(.title)
                        .bold()

                    Text("⭐ XP: \(oldXP) + \(result.xpDelta) = \(newXP)")
                    Text("💎 Gems: \(oldGems) + \(result.coinsDelta) = \(newGems)")
                    Text("🔥 Streak Points: \(oldStreak) + \(result.pointsDelta) = \(newStreak)")

                    Text("✅ \(result.message)")
                        .foregroundColor(.green)

                    Button("Done") {
                        // You could navigate back or reset session state here
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 16)
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.submitQuizSession { submissionResult in
                DispatchQueue.main.async {
                    isLoading = false
                    switch submissionResult {
                    case .success(let response):
                        result = response
                    case .failure(let err):
                        error = err.localizedDescription
                    }
                }
            }
        }
    }
}
