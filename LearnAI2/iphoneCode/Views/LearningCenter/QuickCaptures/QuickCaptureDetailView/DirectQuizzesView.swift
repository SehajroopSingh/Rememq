struct DirectQuizzesView: View {
    let directQuizzes: [Quiz]

    var body: some View {
        DisclosureGroup("General Quizzes") {
            ForEach(directQuizzes) { quiz in
                QuizBlock(quiz: quiz)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
    }
}
