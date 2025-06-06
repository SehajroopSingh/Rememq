struct SubpointDetailView: View {
    let sp: Subpoint

    var body: some View {
        DisclosureGroup(sp.text) {
            if let context = sp.context {
                InfoBlock(title: "Context", content: context, bgColor: Color.blue.opacity(0.05))
            }
            if let support = sp.supportingText {
                InfoBlock(title: "Support", content: support, bgColor: Color.yellow.opacity(0.05))
            }
            if let state = sp.state {
                SpacedRepetitionStateView(state: state)
            }
            if !sp.quizzes.isEmpty {
                DisclosureGroup("🧠 Quizzes for Subpoint") {
                    ForEach(sp.quizzes) { quiz in
                        QuizBlock(quiz: quiz)
                    }
                }
            } else {
                Text("No quizzes for this subpoint").italic()
            }
        }
    }
}
