import SwiftUI

struct FillBlankWithOptionsView: View {
    let quiz: Quiz

    @State private var selectedOption: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quiz.question_text ?? "Choose the correct word to fill in:")
                .font(.headline)

            if let options = quiz.choices {
                ForEach(options.indices, id: \.self) { index in
                    Button(action: {
                        selectedOption = index
                    }) {
                        HStack {
                            Image(systemName: selectedOption == index ? "largecircle.fill.circle" : "circle")
                            Text(options[index])
                        }
                    }
                    .foregroundColor(.primary)
                }
            }

            if let explanation = quiz.explanation {
                Text("Explanation: \(explanation)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
    }
}
