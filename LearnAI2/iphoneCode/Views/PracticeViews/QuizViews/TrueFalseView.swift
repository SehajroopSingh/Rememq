import SwiftUI

struct TrueFalseView: View {
    let quiz: Quiz

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quiz.statement ?? "True or False?")
                .font(.headline)

            HStack {
                Button("True") {
                    print("✅ Choose true")
                }
                .buttonStyle(.bordered)

                Button("False") {
                    print("❌ Choose false")
                }
                .buttonStyle(.bordered)
            }

            if let explanation = quiz.explanation {
                Text("Explanation: \(explanation)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
