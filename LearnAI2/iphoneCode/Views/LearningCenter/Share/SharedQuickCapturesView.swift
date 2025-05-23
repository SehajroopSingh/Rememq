import SwiftUI

// MARK: - Shared Quick Captures List
struct SharedQuickCapturesView: View {
    let captures: [SharedQuickCaptureModel]
    @State private var expandedCaptureIDs: Set<Int> = []

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(captures) { capture in
                    VStack(alignment: .leading, spacing: 8) {
                        // Title + navigation

                        NavigationLink(destination: SharedQuickCaptureDetailView(quickCapture: capture)) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(capture.shortDescription)
                                    .font(.headline)
                                if let ctx = capture.context, !ctx.isEmpty {
                                    Text(ctx)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                            }
                        }


                        // Expandable full content
                        Button(action: {
                            withAnimation {
                                toggleExpanded(capture.id)
                            }
                        }) {
                            HStack(alignment: .top) {
                                Text(capture.content)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .lineLimit(expandedCaptureIDs.contains(capture.id) ? nil : 1)
                                Spacer(minLength: 8)
                                Image(systemName: expandedCaptureIDs.contains(capture.id) ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.blue)
                                    .padding(.top, 2)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1))
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .navigationTitle("Shared Captures")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleExpanded(_ id: Int) {
        if expandedCaptureIDs.contains(id) {
            expandedCaptureIDs.remove(id)
        } else {
            expandedCaptureIDs.insert(id)
        }
    }
}

import SwiftUI

struct SharedQuickCaptureDetailView: View {
    
    let quickCapture: SharedQuickCaptureModel
    @StateObject private var viewModel = QuickCaptureDetailViewModel()
    @Environment(\.dismiss) private var dismiss

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
