
struct QuizAttemptsView: View {
    let attempts: [QuizAttempt]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("📊 Recent Attempts").bold()

            if attempts.isEmpty {
                Text("No attempts yet.")
                    .italic()
                    .foregroundColor(.secondary)
                    .font(.caption)
            } else {
                ForEach(attempts.prefix(5)) { attempt in
                    VStack(alignment: .leading, spacing: 2) {
                        Text("• \(formatDate(attempt.attempt_datetime))")
                        Text("   Correct: \(attempt.was_correct ? "✅ Yes" : "❌ No")")
                        Text("   Score: \(String(format: "%.2f", attempt.score))")
                        if let response = attempt.response_data {
                            Text("   Response: \(response.description)")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
            }
        }
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
