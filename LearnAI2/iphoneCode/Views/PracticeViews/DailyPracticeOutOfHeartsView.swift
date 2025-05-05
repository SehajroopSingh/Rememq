struct DailyPracticeOutOfHeartsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)

            Text("You're out of hearts for today 💔")
                .font(.title2)
                .multilineTextAlignment(.center)

            Text("Come back tomorrow to try again!")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
