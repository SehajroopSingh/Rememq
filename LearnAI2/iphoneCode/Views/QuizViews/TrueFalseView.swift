import SwiftUI

struct TrueFalseView: View {
    let quiz: Quiz

    var body: some View {
        VStack(alignment: .leading) {
            Text(quiz.statement ?? "True or False?")
                .font(.headline)

            HStack {
                Text("True")
                Spacer()
                Text("False")
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
