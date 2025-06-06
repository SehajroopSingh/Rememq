struct FullContentView: View {
    let content: String

    var body: some View {
        ScrollView {
            Text(content)
                .padding()
        }
        .navigationTitle("Full Content")
    }
}
