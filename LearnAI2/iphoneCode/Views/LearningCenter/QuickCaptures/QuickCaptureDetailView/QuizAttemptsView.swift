////
////  QuizAttemptsView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 6/5/25.
////
//
//
//import SwiftUI
//struct QuizAttemptsView: View {
//    let attempts: [QuizAttempt]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text("📊 Recent Attempts").bold()
//
//            if attempts.isEmpty {
//                Text("No attempts yet.")
//                    .italic()
//                    .foregroundColor(.secondary)
//                    .font(.caption)
//            } else {
//                ForEach(attempts.prefix(5)) { attempt in
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("• \(formatDate(attempt.attempt_datetime))")
//                        Text("   Correct: \(attempt.was_correct ? "✅ Yes" : "❌ No")")
//                        Text("   Score: \(String(format: "%.2f", attempt.score))")
//                        if let response = attempt.response_data {
//                            Text("   Response: \(response.description)")
//                                .foregroundColor(.secondary)
//                                .font(.caption)
//                        }
//                    }
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                }
//            }
//        }
//    }
//
//    func formatDate(_ isoString: String) -> String {
//        let formatter = ISO8601DateFormatter()
//        if let date = formatter.date(from: isoString) {
//            let output = DateFormatter()
//            output.dateStyle = .medium
//            output.timeStyle = .short
//            return output.string(from: date)
//        }
//        return isoString
//    }
//}
import SwiftUI

struct QuizAttemptsView: View {
    let attempts: [QuizAttempt]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 Recent Attempts")
                .font(.headline)
                .padding(.bottom, 4)

            if attempts.isEmpty {
                Text("No attempts yet.")
                    .italic()
                    .foregroundColor(.secondary)
                    .font(.caption)
            } else {
                ForEach(attempts.prefix(5)) { attempt in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Label {
                                Text(formatDate(attempt.attempt_datetime))
                            } icon: {
                                Image(systemName: "calendar")
                            }

                            Spacer()

                            Label {
                                Text(attempt.was_correct ? "Correct" : "Incorrect")
                                    .foregroundColor(attempt.was_correct ? .green : .red)
                            } icon: {
                                Image(systemName: attempt.was_correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                            }
                        }

                        HStack {
                            Label {
                                Text("Score: \(String(format: "%.2f", attempt.score))")
                            } icon: {
                                Image(systemName: "star.circle")
                            }

                            Spacer()

                            if let response = attempt.response_data {
                                Label {
                                    Text("Response: \(response.description)")
                                        .lineLimit(1)
                                } icon: {
                                    Image(systemName: "text.bubble")
                                }
                                .foregroundColor(.secondary)
                            }
                        }
                        .font(.caption)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2))
                    )
                }
            }
        }
        .padding(.top, 4)
    }

    func formatDate(_ isoString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"

        if let date = formatter.date(from: isoString) {
            let output = DateFormatter()
            output.locale = Locale.current
            output.timeZone = TimeZone.current
            output.dateStyle = .short
            output.timeStyle = .short
            return output.string(from: date)
        } else {
            print("❌ Failed to parse: \(isoString)")
            return isoString
        }
    }

}
