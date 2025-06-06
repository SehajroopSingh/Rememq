////
////  QuickCaptureDetailView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 4/21/25.
////
import SwiftUI
//
//
//
//struct QuickCaptureDetailView: View {
//    let quickCapture: QuickCaptureModel
//    @StateObject private var viewModel = QuickCaptureDetailViewModel()
//
//
//    var body: some View {
//
//        ZStack {
//            BlobbyBackground()
//                .ignoresSafeArea()
//            
//            ScrollView {
//                
//                VStack(alignment: .leading, spacing: 16) {
//                    
//                    // 🔹 Summary
//                    Text(quickCapture.shortDescription ?? "No summary available")
//                        .font(.title2)
//                        .bold()
//                    
//                    // 🔹 Classification
//                    if let classification = quickCapture.classification {
//                        Text(classification.capitalized)
//                            .font(.caption)
//                            .padding(6)
//                            .background(Color.blue.opacity(0.1))
//                            .cornerRadius(8)
//                            .foregroundColor(.blue)
//                    }
//
//                    VStack(alignment: .leading, spacing: 12) {
//                        
//                        // Section 1: Context
//                        if let context = quickCapture.context {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Context")
//                                    .font(.headline)
//                                Text(context)
//                                    .foregroundColor(.secondary)
//                                    .font(.body)
//                            }
//                        }
//                        
//                        Divider()
//                        
//                        // Section 2: Full Content
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Full Content")
//                                .font(.headline)
//                            
//                            NavigationLink(destination: FullContentView(content: quickCapture.content)) {
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text(quickCapture.content)
//                                        .font(.body)
//                                        .lineLimit(4)
//                                        .foregroundColor(.primary)
//                                    
//                                    HStack(spacing: 4) {
//                                        Text("Read more")
//                                            .font(.caption)
//                                            .foregroundColor(.blue)
//                                        Image(systemName: "chevron.right")
//                                            .font(.caption)
//                                            .foregroundColor(.blue)
//                                    }
//                                }
//                            }
//                        }
//                        
//                        Divider()
//                        
//                        // Section 3: Highlights
//                        if !quickCapture.highlightedSections.isEmpty {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Highlights")
//                                    .font(.headline)
//                                ForEach(quickCapture.highlightedSections, id: \.self) { section in
//                                    Text("• \(section)")
//                                        .font(.body)
//                                }
//                            }
//                        }
//                        
//                        Divider()
//                        
//                        // Section 4: Metadata (Mastery Time, Depth, Created At)
//                        VStack(alignment: .leading, spacing: 6) {
//                            HStack(spacing: 12) {
//                                Text("Mastery Time")
//                                Divider().frame(height: 16)
//                                Text("Depth")
//                                Divider().frame(height: 16)
//                                Text("Created")
//                            }
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                            
//                            Divider()
//                            
//                            HStack(spacing: 12) {
//                                Text(quickCapture.masteryTime)
//                                Divider().frame(height: 16)
//                                Text(quickCapture.depthOfLearning.capitalized)
//                                Divider().frame(height: 16)
//                                Text(formatDateToDayMonthYear(quickCapture.createdAt))
//                            }
//                            .font(.footnote)
//                        }
//                        
//                    }
//                    .padding()
//                    .background(.ultraThinMaterial)
//                    .cornerRadius(16)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
//                    )
//                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
//                    
//                    Divider()
//                    
//                    // 🔹 Quizzes Section
//                    Text("Quizzes")
//                        .font(.headline)
//                    
//                    if let err = viewModel.errorMessage {
//                        Text("Error: \(err)")
//                            .foregroundColor(.red)
//                    } else if viewModel.directQuizzes.isEmpty && viewModel.mainPointsWithQuizzes.isEmpty {
//                        Text("No quizzes found.")
//                            .italic()
//                    } else {
//                        // General quizzes
//                        if !viewModel.directQuizzes.isEmpty {
//                            DisclosureGroup("General Quizzes") {
//                                ForEach(viewModel.directQuizzes) { quiz in
//                                    //                                DisclosureGroup {
//                                    //                                    if let state = quiz.state {
//                                    //                                        SpacedRepetitionStateView(state: state)
//                                    //                                    }
//                                    //                                    QuizDisclosureContent(quiz: quiz)
//                                    //                                } label: {
//                                    //                                    Text(quiz.quiz_type.rawValue
//                                    //                                        .replacingOccurrences(of: "_", with: " ")
//                                    //                                        .capitalized
//                                    //                                    )
//                                    //                                    .bold()
//                                    //                                }
//                                    //                                .padding(.vertical, 4)
//                                    DisclosureGroup {
//                                        VStack(alignment: .leading, spacing: 8) {
//                                            QuizDisclosureContent(quiz: quiz)
//                                            
//                                            NavigationLink(destination: QuizPerformanceStatsDetailView(quiz: quiz)) {
//                                                HStack {
//                                                    Image(systemName: "chart.bar.xaxis")
//                                                    Text("View Performance")
//                                                }
//                                                .font(.caption)
//                                                .foregroundColor(.blue)
//                                            }
//                                        }
//                                    } label: {
//                                        Text(quiz.quiz_type.rawValue
//                                            .replacingOccurrences(of: "_", with: " ")
//                                            .capitalized
//                                        )
//                                        .bold()
//                                    }
//                                    .padding()
//                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary))
//                                    .padding(.vertical, 4)
//                                    
//                                }
//                                
//                            }
//                            .padding()
//                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//                        }
//                        
//                        ForEach(viewModel.mainPointsWithQuizzes, id: \.id) { mp in
//                            DisclosureGroup(mp.text) {
//                                // 🌐 Context and Support
////                                if let context = mp.context {
////                                    Text("🧭 Context: \(context)").font(.caption)
////                                }
////                                if let support = mp.supportingText {
////                                    Text("💡 Support: \(support)").font(.caption)
////                                }
//                                if let context = mp.context {
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("Context")
//                                            .font(.caption)
//                                            .foregroundColor(.secondary)
//                                        Text(context)
//                                            .font(.caption)
//                                            .foregroundColor(.primary)
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .leading) // 👈 FIXED
//                                    .padding(6)
//                                    .background(Color.blue.opacity(0.05))
//                                    .cornerRadius(8)
//
//                                }
//
//                                if let support = mp.supportingText {
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("Supporting Text from Quick Captures")
//                                            .font(.caption)
//                                            .foregroundColor(.secondary)
//                                        Text(support)
//                                            .font(.caption)
//                                            .foregroundColor(.primary)
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .leading) // 👈 FIXED
//
//                                    .padding(6)
//                                    .background(Color.blue.opacity(0.05))
//                                    .cornerRadius(8)
//                                }
//
//
//                                // 🧠 MainPoint Repetition State
//                                if let state = mp.state {
//                                    SpacedRepetitionStateView(state: state)
//                                }
//                                
//                                // ❓ MainPoint Quizzes
//                                if mp.quizzes.isEmpty {
//                                    Text("No quizzes for this main point")
//                                        .italic()
//                                        .padding(.leading)
//                                } else {
//                                    ForEach(mp.quizzes) { quiz in
//
//                                        DisclosureGroup {
//                                            VStack(alignment: .leading, spacing: 8) {
//                                                QuizDisclosureContent(quiz: quiz)
//                                                
//                                                NavigationLink(destination: QuizPerformanceStatsDetailView(quiz: quiz)) {
//                                                    HStack {
//                                                        Image(systemName: "chart.bar.xaxis")
//                                                        Text("View Performance")
//                                                    }
//                                                    .font(.caption)
//                                                    .foregroundColor(.blue)
//                                                }
//                                            }
//                                        } label: {
//                                            Text(quiz.quiz_type.rawValue
//                                                .replacingOccurrences(of: "_", with: " ")
//                                                .capitalized
//                                            )
//                                            .bold()
//                                        }
//                                        .padding()
//                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary))
//                                        .padding(.vertical, 4)
//                                        
//                                        
//                                    }
//                                }
//                                
//                                // 📌 Subpoints (if any)
//                                if !mp.subpoints.isEmpty {
//                                    Text("📌 Subpoints").font(.subheadline).padding(.top, 4)
//                                    
//                                    ForEach(mp.subpoints, id: \.id) { sp in
//                                        DisclosureGroup(sp.text) {
////                                            if let context = sp.context {
////                                                Text("🧭 Context: \(context)").font(.caption)
////                                            }
////                                            
////                                            if let state = sp.state {
////                                                SpacedRepetitionStateView(state: state)
////                                            }
//                                            if let context = mp.context {
//                                                VStack(alignment: .leading, spacing: 4) {
//                                                    Text("Context")
//                                                        .font(.caption)
//                                                        .foregroundColor(.secondary)
//                                                    Text(context)
//                                                        .font(.caption)
//                                                        .foregroundColor(.primary)
//                                                }
//                                                .frame(maxWidth: .infinity, alignment: .leading) // 👈 FIXED
//
//                                                .padding(6)
//                                                .background(Color.blue.opacity(0.05))
//                                                .cornerRadius(8)
//                                            }
//
//                                            if let support = mp.supportingText {
//                                                VStack(alignment: .leading, spacing: 4) {
//                                                    Text("Supporting Text from Quick Captures")
//                                                        .font(.caption)
//                                                        .foregroundColor(.secondary)
//                                                    Text(support)
//                                                        .font(.caption)
//                                                        .foregroundColor(.primary)
//                                                }
//                                                .frame(maxWidth: .infinity, alignment: .leading) // 👈 FIXED
//
//                                                .padding(6)
//                                                .background(Color.blue.opacity(0.05))
//                                                .cornerRadius(8)
//                                            }
//
//                                            if sp.quizzes.isEmpty {
//                                                Text("No quizzes for this subpoint")
//                                                    .italic()
//                                                    .padding(.leading)
//                                            } else {
//                                                ForEach(sp.quizzes) { quiz in
//                                                    //                                                DisclosureGroup {
//                                                    //                                                    if let state = quiz.state {
//                                                    //                                                        SpacedRepetitionStateView(state: state)
//                                                    //                                                    }
//                                                    //                                                    QuizDisclosureContent(quiz: quiz)
//                                                    //                                                } label: {
//                                                    //                                                    Text(quiz.quiz_type.rawValue
//                                                    //                                                        .replacingOccurrences(of: "_", with: " ")
//                                                    //                                                        .capitalized
//                                                    //                                                    ).bold()
//                                                    //                                                }
//                                                    //                                                .padding(.vertical, 4)
//                                                    DisclosureGroup {
//                                                        VStack(alignment: .leading, spacing: 8) {
//                                                            QuizDisclosureContent(quiz: quiz)
//                                                            
//                                                            NavigationLink(destination: QuizPerformanceStatsDetailView(quiz: quiz)) {
//                                                                HStack {
//                                                                    Image(systemName: "chart.bar.xaxis")
//                                                                    Text("View Performance")
//                                                                }
//                                                                .font(.caption)
//                                                                .foregroundColor(.blue)
//                                                            }
//                                                        }
//                                                    } label: {
//                                                        Text(quiz.quiz_type.rawValue
//                                                            .replacingOccurrences(of: "_", with: " ")
//                                                            .capitalized
//                                                        )
//                                                        .bold()
//                                                    }
//                                                    .padding()
//                                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary))
//                                                    .padding(.vertical, 4)
//                                                    
//                                                    
//                                                }
//                                            }
//                                        }
//                                        .padding(.vertical, 4)
//                                    }
//                                }
//                                
//                            }
//                            .padding()
//                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary))
//                        }
//                        
//                    }
//                    
//                    Spacer()
//                }
//                .padding()
//            }
//            .navigationTitle("Quick Capture Details")
//            .onAppear {
//                viewModel.loadQuizzes(for: quickCapture.id)
//            }
//            .background(Color.clear) // 👈 add this
//        }
//    }
//}
//func formatDateToDayMonthYear(_ isoString: String) -> String {
//    let isoFormatter = ISO8601DateFormatter()
//    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//
//    guard let date = isoFormatter.date(from: isoString) ??
//                    ISO8601DateFormatter().date(from: isoString) else {
//        return isoString
//    }
//
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .none
//    formatter.locale = .current
//    formatter.timeZone = .current
//
//    return formatter.string(from: date)
//}

//// Reuse your QuizDisclosureContent from before:
//struct QuizDisclosureContent: View {
//    let quiz: Quiz
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            switch quiz.quiz_type {
//            case .multipleChoice:
//                if let q = quiz.question_text {
//                    Text(q).font(.subheadline)
//                }
//                ForEach(quiz.choices ?? [], id: \.self) { choice in
//                    Text("• \(choice)")
//                }
//                if let idx = quiz.correctAnswerIndex,
//                   idx < (quiz.choices?.count ?? 0) {
//                    Text("Answer: \(quiz.choices![idx])")
//                        .italic()
//                }
//                
//            case .trueFalse:
//                if let stmt = quiz.statement {
//                    Text(stmt).font(.subheadline)
//                }
//                if let ans = quiz.trueFalseAnswer {
//                    Text("Answer: \(ans)").italic()
//                }
//                
//            case .fillBlank:
//                if let q = quiz.fillBlankQuestion {
//                    Text(q).font(.subheadline)
//                }
//                if let ans = quiz.fillBlankAnswer {
//                    Text("Answer: \(ans)").italic()
//                }
//                
//            case .fillBlankWithOptions:
//                if let q = quiz.fillBlankQuestion {
//                    Text(q).font(.subheadline)
//                }
//                ForEach(quiz.options ?? [], id: \.self) { opt in
//                    Text("• \(opt)")
//                }
//                if let ans = quiz.fillBlankAnswer {
//                    Text("Answer: \(ans)").italic()
//                }
//            }
////            Divider().padding(.vertical, 4)
////            QuizAttemptsView(attempts: quiz.recent_attempts ?? [])
////
//
//
//        }
//        .padding(.top, 4)
//    }
//}
//
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
