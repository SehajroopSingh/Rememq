////
////  SpacedRepetitionStateView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 6/5/25.
////
//
//import SwiftUI
//
//struct SpacedRepetitionStateView: View {
//    let state: QuizState
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text("📈 Mastery: \(String(format: "%.2f", state.mastery_level))")
//            Text("🧠 Easiness Factor: \(String(format: "%.2f", state.easiness_factor))")
//            Text("🔁 Repetition: \(state.repetition)")
//            Text("📆 Interval (days): \(String(format: "%.1f", state.interval_days))")
//            Text("✅ Correct Attempts: \(state.correct_attempts)/\(state.total_attempts)")
//            if let score = state.last_score {
//                Text("📝 Last Score: \(String(format: "%.2f", score))")
//            }
//            if let lastReviewed = state.last_reviewed_at {
//                Text("📅 Last Reviewed: \(formatDate(lastReviewed))")
//            }
//            if let nextDue = state.next_due {
//                Text("⏭️ Next Due: \(formatDate(nextDue))")
//            }
//        }
//        .font(.caption)
//        .foregroundColor(.gray)
//        .padding(.bottom, 4)
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

struct SpacedRepetitionStateView: View {
    let state: QuizState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🔁 Spaced Repetition State")
                .font(.subheadline)
                .bold()
                .padding(.bottom, 2)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Label("Mastery", systemImage: "flame.fill")
                    Spacer()
                    Text(String(format: "%.2f", state.mastery_level))
                }

                HStack {
                    Label("Easiness Factor", systemImage: "brain.head.profile")
                    Spacer()
                    Text(String(format: "%.2f", state.easiness_factor))
                }

                HStack {
                    Label("Repetitions", systemImage: "arrow.2.circlepath")
                    Spacer()
                    Text("\(state.repetition)")
                }

                HStack {
                    Label("Interval (days)", systemImage: "calendar.badge.clock")
                    Spacer()
                    Text(String(format: "%.1f", state.interval_days))
                }

                HStack {
                    Label("Correct Attempts", systemImage: "checkmark.seal")
                    Spacer()
                    Text("\(state.correct_attempts)/\(state.total_attempts)")
                }

                if let score = state.last_score {
                    HStack {
                        Label("Last Score", systemImage: "pencil.and.outline")
                        Spacer()
                        Text(String(format: "%.2f", score))
                    }
                }
            }
            .font(.caption)

            if let lastReviewed = state.last_reviewed_at,
               let nextDue = state.next_due {
                Divider().padding(.vertical, 6)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Label("Last Reviewed", systemImage: "clock.arrow.circlepath")
                        Spacer()
                        Text(formatDate(lastReviewed))
                    }

                    HStack {
                        Label("Next Due", systemImage: "calendar.badge.plus")
                        Spacer()
                        Text(formatDate(nextDue))
                    }
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2))
        )
    }

    func formatDate(_ isoString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX" // handles microseconds and Z
        
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
