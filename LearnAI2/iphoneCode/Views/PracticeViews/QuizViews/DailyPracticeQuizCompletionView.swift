////
////  QuizCompletionView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 4/15/25.
////
import SwiftUI

struct DailyPracticeQuizCompletionView: View {
    @ObservedObject var viewModel: PracticeViewModel
    @EnvironmentObject var tabManager: TabSelectionManager
    @Environment(\.dismiss) var dismiss

    @State private var isLoading = true
    @State private var result: SessionResultResponse?
    @State private var error: String?

    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView("Calculating Results...")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
            } else if let error = error {
                Text("⚠️ Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
            } else if let result = result {
                let oldXP = viewModel.initialDashboardSnapshot?.xp ?? 0
                let oldGems = viewModel.initialDashboardSnapshot?.gems ?? 0
                let oldStreak = viewModel.initialDashboardSnapshot?.streak ?? 0

                let newXP = oldXP + result.xpDelta
                let newGems = oldGems + result.coinsDelta
                let newStreak = oldStreak + result.pointsDelta

                VStack(spacing: 16) {
                    Text("🎉 Session Complete!")
                        .font(.title)
                        .bold()

                    VStack(alignment: .leading, spacing: 12) {
                        StatRow(icon: "⭐", label: "XP", oldValue: oldXP, delta: result.xpDelta, newValue: newXP)
                        StatRow(icon: "💎", label: "Gems", oldValue: oldGems, delta: result.coinsDelta, newValue: newGems)
                        StatRow(icon: "🔥", label: "Streak", oldValue: oldStreak, delta: result.pointsDelta, newValue: newStreak)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.5), Color.white.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .shadow(color: .white.opacity(0.15), radius: 2, x: -1, y: -1)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 2)

                    Text("✅ \(result.message)")
                        .foregroundColor(.green)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )

                    Button(action: {
                        // Navigate to dashboard
                        tabManager.selectedTab = 0
                        dismiss()
                    }) {
                        Text("Return to Dashboard")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.2))
                                        .background(.ultraThinMaterial)
                                        .blur(radius: 0.3)
                                    
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.6), Color.white.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                }
                            )
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.15), radius: 2, x: -1, y: -1)
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 2)
                    }
                    .padding(.top, 16)
                }
            }
        }
        .padding()
//        .onAppear {
//            viewModel.submitQuizSession { submissionResult in
//                DispatchQueue.main.async {
//                    isLoading = false
//                    switch submissionResult {
//                    case .success(let response):
//                        result = response
//                    case .failure(let err):
//                        error = err.localizedDescription
//                    }
//                }
//            }
//        }
        .onAppear {
            guard !viewModel.quizzes.isEmpty, !viewModel.submittedResults.isEmpty else {
                print("🛑 Skipping submission: No quizzes or no results.")
                isLoading = false
                error = "No answers were submitted."
                return
            }

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

struct StatRow: View {
    let icon: String
    let label: String
    let oldValue: Int
    let delta: Int
    let newValue: Int
    
    var body: some View {
        HStack {
            Text(icon)
            Text(label)
            Spacer()
            Text("\(oldValue) + \(delta) = \(newValue)")
                .foregroundColor(.primary)
        }
        .font(.system(.body, design: .rounded))
    }
}
