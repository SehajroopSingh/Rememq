//
//  QuizPerformanceStatsDetailView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 6/5/25.
//
import SwiftUI

struct QuizPerformanceStatsDetailView: View {
    let title: String
    let state: QuizState
    let attempts: [QuizAttempt]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.title2)
                    .bold()

                // State
                SpacedRepetitionStateView(state: state)

                // Recent Attempts (if any)
                if !attempts.isEmpty {
                    QuizAttemptsView(attempts: attempts)
                } else {
                    Text("No recent attempts").italic()
                }
            }
            .padding()
        }
        .navigationTitle("Performance")
    }
}
extension QuizPerformanceStatsDetailView {
    init(quiz: Quiz) {
        self.title = "Quiz Performance"
        self.state = quiz.state!
        self.attempts = quiz.recent_attempts ?? []
    }

    init(mainPoint: MainPointWithQuizzes) {
        self.title = "Main Point Performance"
        self.state = mainPoint.state!
        self.attempts = []  // Main points don’t have attempts directly
    }

    init(subPoint: SubPointWithQuizzes) {
        self.title = "Subpoint Performance"
        self.state = subPoint.state!
        self.attempts = []  // Subpoints don’t have attempts directly
    }
}
