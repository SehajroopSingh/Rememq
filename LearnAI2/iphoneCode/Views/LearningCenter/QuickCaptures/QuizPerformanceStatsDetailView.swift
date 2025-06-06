struct QuizPerformanceStatsDetailView: View {
    let quiz: Quiz

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Quiz Performance Details")
                    .font(.title2)
                    .bold()

                // Placeholder — replace with real chart later
                Text("📊 Charts coming soon...")

                // Quiz State Summary
                if let state = quiz.state {
                    SpacedRepetitionStateView(state: state)
                }

                // Recent Attempts
                QuizAttemptsView(attempts: quiz.recent_attempts ?? [])
            }
            .padding()
        }
        .navigationTitle("Performance")
    }
}
