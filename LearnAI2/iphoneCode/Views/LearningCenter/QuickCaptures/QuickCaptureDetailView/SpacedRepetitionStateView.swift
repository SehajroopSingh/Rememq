
struct SpacedRepetitionStateView: View {
    let state: QuizState

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("📈 Mastery: \(String(format: "%.2f", state.mastery_level))")
            Text("🧠 Easiness Factor: \(String(format: "%.2f", state.easiness_factor))")
            Text("🔁 Repetition: \(state.repetition)")
            Text("📆 Interval (days): \(String(format: "%.1f", state.interval_days))")
            Text("✅ Correct Attempts: \(state.correct_attempts)/\(state.total_attempts)")
            if let score = state.last_score {
                Text("📝 Last Score: \(String(format: "%.2f", score))")
            }
            if let lastReviewed = state.last_reviewed_at {
                Text("📅 Last Reviewed: \(formatDate(lastReviewed))")
            }
            if let nextDue = state.next_due {
                Text("⏭️ Next Due: \(formatDate(nextDue))")
            }
        }
        .font(.caption)
        .foregroundColor(.gray)
        .padding(.bottom, 4)
    }

    func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoString) {
            let output = DateFormatter()
            output.dateStyle = .medium
            output.timeStyle = .short
            return output.string(from: date)
        }
        return isoString
    }
}