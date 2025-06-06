struct InfoBlock: View {
    let title: String
    let content: String
    let bgColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(content)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(6)
        .background(bgColor)
        .cornerRadius(8)
    }
}

struct QuizBlock: View {
    let quiz: Quiz

    var body: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 8) {
                QuizDisclosureContent(quiz: quiz)
                NavigationLink(destination: QuizPerformanceStatsDetailView(quiz: quiz)) {
                    HStack {
                        Image(systemName: "chart.bar.xaxis")
                        Text("View Performance")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
        } label: {
            Text(quiz.quiz_type.rawValue
                    .replacingOccurrences(of: "_", with: " ")
                    .capitalized
            )
            .bold()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary))
        .padding(.vertical, 4)
    }
}
