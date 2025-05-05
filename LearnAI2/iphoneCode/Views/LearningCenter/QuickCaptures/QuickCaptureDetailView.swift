//
//  QuickCaptureDetailView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/21/25.
//


//import SwiftUI
//
//struct QuickCaptureDetailView: View {
//    let quickCapture: QuickCaptureModel
//    @StateObject private var viewModel = QuickCaptureDetailViewModel()
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                // … your existing Content/Context/Highlights …
//
//                Text("Quizzes")
//                  .font(.headline)
//                
//                if let error = viewModel.errorMessage {
//                    Text("Error: \(error)")
//                        .foregroundColor(.red)
//                } else if viewModel.quizzes.isEmpty {
//                    Text("Loading quizzes…")
//                        .italic()
//                } else {
//                    ForEach(viewModel.quizzes) { quiz in
//                        DisclosureGroup(
//                            isExpanded: .constant(false),
//                            content: {
//                                switch quiz.quiz_type {
//                                case .multipleChoice:
//                                    if let q = quiz.question_text {
//                                        Text(q)
//                                            .font(.subheadline)
//                                            .padding(.bottom, 4)
//                                    }
//                                    ForEach(quiz.choices ?? [], id: \.self) { choice in
//                                        Text("• \(choice)")
//                                    }
//                                    if let idx = quiz.correctAnswerIndex,
//                                       idx < (quiz.choices?.count ?? 0) {
//                                        Text("Answer: \(quiz.choices![idx])")
//                                            .italic()
//                                            .padding(.top, 4)
//                                    }
//                                    
//                                case .trueFalse:
//                                    if let stmt = quiz.statement {
//                                        Text(stmt)
//                                            .font(.subheadline)
//                                            .padding(.bottom, 4)
//                                    }
//                                    if let ans = quiz.trueFalseAnswer {
//                                        Text("Answer: \(ans)")
//                                            .italic()
//                                    }
//                                    
//                                case .fillBlank:
//                                    if let q = quiz.fillBlankQuestion {
//                                        Text(q)
//                                            .font(.subheadline)
//                                            .padding(.bottom, 4)
//                                    }
//                                    if let ans = quiz.fillBlankAnswer {
//                                        Text("Answer: \(ans)")
//                                            .italic()
//                                    }
//                                    
//                                case .fillBlankWithOptions:
//                                    if let q = quiz.fillBlankQuestion {
//                                        Text(q)
//                                            .font(.subheadline)
//                                            .padding(.bottom, 4)
//                                    }
//                                    ForEach(quiz.options ?? [], id: \.self) { opt in
//                                        Text("• \(opt)")
//                                    }
//                                    if let ans = quiz.fillBlankAnswer {
//                                        Text("Answer: \(ans)")
//                                            .italic()
//                                            .padding(.top, 4)
//                                    }
//                                }
//                            },
//                            label: {
//                                Text(quiz.quiz_type.rawValue
//                                      .replacingOccurrences(of: "_", with: " ")
//                                      .capitalized)
//                                  .font(.body)
//                                  .bold()
//                            }
//                        )
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.secondary)
//                        )
//                    }
//                }
//                
//                Spacer()
//            }
//            .padding()
//        }
//        .navigationTitle("Quick Capture Details")
//        .onAppear {
//            viewModel.loadQuizzes(for: quickCapture.id)
//        }
//    }
//}
import SwiftUI

import SwiftUI
//
//struct QuickCaptureDetailView: View {
//    let quickCapture: QuickCaptureModel
//    @StateObject private var viewModel = QuickCaptureDetailViewModel()
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                Text("Quizzes")
//                    .font(.headline)
//
//                if let err = viewModel.errorMessage {
//                    Text("Error: \(err)")
//                        .foregroundColor(.red)
//                } else if viewModel.directQuizzes.isEmpty && viewModel.mainPointsWithQuizzes.isEmpty {
//                    Text("No quizzes found.")
//                        .italic()
//                } else {
//                    // 🔹 Section for direct quizzes
//                    if !viewModel.directQuizzes.isEmpty {
//                        DisclosureGroup("General Quizzes") {
//                            ForEach(viewModel.directQuizzes) { quiz in
//                                DisclosureGroup {
//                                    QuizDisclosureContent(quiz: quiz)
//                                } label: {
//                                    Text(quiz.quiz_type.rawValue
//                                        .replacingOccurrences(of: "_", with: " ")
//                                        .capitalized
//                                    )
//                                    .font(.body)
//                                    .bold()
//                                }
//                                .padding(.vertical, 4)
//                            }
//                        }
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//                    }
//
//                    // 🔹 Sections for each main point and its quizzes
//                    ForEach(viewModel.mainPointsWithQuizzes, id: \.id) { mp in
//                        DisclosureGroup(mp.text) {
//                            if mp.quizzes.isEmpty {
//                                Text("No quizzes for this main point")
//                                    .italic()
//                                    .padding(.leading)
//                            } else {
//                                ForEach(mp.quizzes) { quiz in
//                                    DisclosureGroup {
//                                        QuizDisclosureContent(quiz: quiz)
//                                    } label: {
//                                        Text(quiz.quiz_type.rawValue
//                                            .replacingOccurrences(of: "_", with: " ")
//                                            .capitalized
//                                        )
//                                        .font(.body)
//                                        .bold()
//                                    }
//                                    .padding(.vertical, 4)
//                                }
//                            }
//                        }
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary))
//                    }
//                }
//
//                Spacer()
//            }
//            .padding()
//        }
//        .navigationTitle("Quick Capture Details")
//        .onAppear {
//            viewModel.loadQuizzes(for: quickCapture.id)
//        }
//    }
//}
import SwiftUI

struct QuickCaptureDetailView: View {
    let quickCapture: QuickCaptureModel
    @StateObject private var viewModel = QuickCaptureDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // 🔹 Summary
                Text(quickCapture.shortDescription ?? "No summary available")
                    .font(.title2)
                    .bold()

                // 🔹 Classification
                if let classification = quickCapture.classification {
                    Text(classification.capitalized)
                        .font(.caption)
                        .padding(6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.blue)
                }

                // 🔹 Context
                if let context = quickCapture.context {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Context")
                            .font(.headline)
                        Text(context)
                            .foregroundColor(.secondary)
                    }
                }

                // 🔹 Full Content
                VStack(alignment: .leading, spacing: 4) {
                    Text("Full Content")
                        .font(.headline)
                    Text(quickCapture.content)
                        .font(.body)
                }

                // 🔹 Highlighted Sections
                if !quickCapture.highlightedSections.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Highlights")
                            .font(.headline)
                        ForEach(quickCapture.highlightedSections, id: \.self) { section in
                            Text("• \(section)")
                        }
                    }
                }

                // 🔹 Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text("Learning Settings")
                        .font(.headline)
                    Text("Mastery Time: \(quickCapture.masteryTime)")
                    Text("Depth of Learning: \(quickCapture.depthOfLearning.capitalized)")
                    Text("Created: \(quickCapture.createdAt)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Divider()

                // 🔹 Quizzes Section
                Text("Quizzes")
                    .font(.headline)

                if let err = viewModel.errorMessage {
                    Text("Error: \(err)")
                        .foregroundColor(.red)
                } else if viewModel.directQuizzes.isEmpty && viewModel.mainPointsWithQuizzes.isEmpty {
                    Text("No quizzes found.")
                        .italic()
                } else {
                    // General quizzes
                    if !viewModel.directQuizzes.isEmpty {
                        DisclosureGroup("General Quizzes") {
                            ForEach(viewModel.directQuizzes) { quiz in
                                DisclosureGroup {
                                    if let state = quiz.state {
                                        SpacedRepetitionStateView(state: state)
                                    }
                                    QuizDisclosureContent(quiz: quiz)
                                } label: {
                                    Text(quiz.quiz_type.rawValue
                                        .replacingOccurrences(of: "_", with: " ")
                                        .capitalized
                                    )
                                    .bold()
                                }
                                .padding(.vertical, 4)
                            }

                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    }

                    // Main Point Quizzes
                    ForEach(viewModel.mainPointsWithQuizzes, id: \.id) { mp in
                        DisclosureGroup(mp.text) {
                            if let state = mp.state {
                                SpacedRepetitionStateView(state: state)
                            }
                            if mp.quizzes.isEmpty {
                                Text("No quizzes for this main point")
                                    .italic()
                                    .padding(.leading)
                            } else {
                                ForEach(mp.quizzes) { quiz in
                                    DisclosureGroup {
                                        if let state = quiz.state {
                                            SpacedRepetitionStateView(state: state)
                                        }
                                        QuizDisclosureContent(quiz: quiz)
                                    } label: {
                                        Text(quiz.quiz_type.rawValue
                                            .replacingOccurrences(of: "_", with: " ")
                                            .capitalized
                                        )
                                        .bold()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary))
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Quick Capture Details")
        .onAppear {
            viewModel.loadQuizzes(for: quickCapture.id)
        }
    }
}

// Reuse your QuizDisclosureContent from before:
struct QuizDisclosureContent: View {
    let quiz: Quiz

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch quiz.quiz_type {
            case .multipleChoice:
                if let q = quiz.question_text {
                    Text(q).font(.subheadline)
                }
                ForEach(quiz.choices ?? [], id: \.self) { choice in
                    Text("• \(choice)")
                }
                if let idx = quiz.correctAnswerIndex,
                   idx < (quiz.choices?.count ?? 0) {
                    Text("Answer: \(quiz.choices![idx])")
                        .italic()
                }
                
            case .trueFalse:
                if let stmt = quiz.statement {
                    Text(stmt).font(.subheadline)
                }
                if let ans = quiz.trueFalseAnswer {
                    Text("Answer: \(ans)").italic()
                }
                
            case .fillBlank:
                if let q = quiz.fillBlankQuestion {
                    Text(q).font(.subheadline)
                }
                if let ans = quiz.fillBlankAnswer {
                    Text("Answer: \(ans)").italic()
                }
                
            case .fillBlankWithOptions:
                if let q = quiz.fillBlankQuestion {
                    Text(q).font(.subheadline)
                }
                ForEach(quiz.options ?? [], id: \.self) { opt in
                    Text("• \(opt)")
                }
                if let ans = quiz.fillBlankAnswer {
                    Text("Answer: \(ans)").italic()
                }
            }
            Divider().padding(.vertical, 4)
            QuizAttemptsView(attempts: quiz.recent_attempts ?? [])
            
        }
        .padding(.top, 4)
    }
}
struct SpacedRepetitionStateView: View {
    let state: QuizState

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("📈 Mastery: \(String(format: "%.2f", state.mastery_level))")
            Text("🧠 Easiness Factor: \(String(format: "%.2f", state.easiness_factor))")
            Text("🔁 Repetition: \(state.repetition)")
            Text("📆 Interval (days): \(String(format: "%.1f", state.interval_days))")
            Text("✅ Correct Attempts: \(state.correct_attempts)/\(state.total_attempts)")
            if let score = state.last_score {
                Text("📝 Last Score: \(String(format: "%.2f", score))")
            }
            if let lastReviewed = state.last_reviewed_at {
                Text("📅 Last Reviewed: \(formatDate(lastReviewed))")
            }
            if let nextDue = state.next_due {
                Text("⏭️ Next Due: \(formatDate(nextDue))")
            }
        }
        .font(.caption)
        .foregroundColor(.gray)
        .padding(.bottom, 4)
    }

    func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoString) {
            let output = DateFormatter()
            output.dateStyle = .medium
            output.timeStyle = .short
            return output.string(from: date)
        }
        return isoString
    }
}

struct QuizAttemptsView: View {
    let attempts: [QuizAttempt]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("📊 Recent Attempts").bold()

            if attempts.isEmpty {
                Text("No attempts yet.")
                    .italic()
                    .foregroundColor(.secondary)
                    .font(.caption)
            } else {
                ForEach(attempts.prefix(5)) { attempt in
                    VStack(alignment: .leading, spacing: 2) {
                        Text("• \(formatDate(attempt.attempt_datetime))")
                        Text("   Correct: \(attempt.was_correct ? "✅ Yes" : "❌ No")")
                        Text("   Score: \(String(format: "%.2f", attempt.score))")
                        if let response = attempt.response_data {
                            Text("   Response: \(response.description)")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
            }
        }
    }

    func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoString) {
            let output = DateFormatter()
            output.dateStyle = .medium
            output.timeStyle = .short
            return output.string(from: date)
        }
        return isoString
    }
}
