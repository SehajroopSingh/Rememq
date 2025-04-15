import SwiftUI

struct FillBlankView: View {
    let quiz: Quiz

    var body: some View {
        VStack(alignment: .leading) {
            Text(quiz.fillBlankQuestion ?? "Fill in the blank:")
                .font(.headline)

            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 44)
                .cornerRadius(8)

            if let explanation = quiz.explanation {
                Text("Explanation: \(explanation)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
    }
}
