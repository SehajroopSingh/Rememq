import SwiftUI

struct MultipleChoiceView: View {
    let quiz: Quiz

    var body: some View {
        VStack(alignment: .leading) {
            Text(quiz.question_text ?? "Question")
                .font(.headline)

            ForEach(Array(quiz.choices?.enumerated() ?? [].enumerated()), id: \.offset) { index, choice in
                Text("\(index + 1). \(choice)")
                    .padding(.vertical, 4)
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
