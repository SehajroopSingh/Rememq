
//
//  PracticeView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/4/25.
//

import SwiftUI

struct QuizPracticeView: View {
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: PracticeViewModel

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.3),
                    Color.blue.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer(minLength: 40) // ✅ Pushes content away from top overlay (tweak as


                // Main Content State Handling
                if viewModel.isLoading {
                    ProgressView("Loading Quizzes...")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                } else if viewModel.currentIndex >= viewModel.quizzes.count {
                    DailyPracticeQuizCompletionView(viewModel: viewModel)
                } else if viewModel.quizzes.isEmpty {
                    Text("No quizzes found.")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                } else if viewModel.remainingHearts == 0 {
                    DailyPracticeOutOfHeartsView()
                } else {
                    let quiz = viewModel.quizzes[viewModel.currentIndex]


//                    QuizCardViewDailyPractice(quiz: quiz, viewModel: viewModel)
//                        .id(quiz.id)
//                        .environmentObject(viewModel)
//                        .padding()
                    VStack(alignment: .leading, spacing: 12) {
                        // ✅ Shared quiz metadata (short description, difficulty, etc.)
                        QuizMetadataHeaderView(quiz: quiz)
                            .padding(.horizontal)
                            .transition(.opacity)
                        ScrollView {
                            VStack(alignment: .center, spacing: 20) {
                                QuizCardViewDailyPractice(quiz: quiz, viewModel: viewModel)
                                    .id(quiz.id)
                                    .environmentObject(viewModel)

                                    .padding(.top, 5) // pushes away from top bar
                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                        }
                    }
                        Spacer() // Placeholder so nothing breaks

                }
            }
            .padding()
        }
        
        .overlay(alignment: .top) {
            TopBarView(
                progress: viewModel.quizzes.isEmpty ? 0.0 :
                    Double(viewModel.currentIndex + 1) / Double(viewModel.quizzes.count),
                hearts: viewModel.remainingHearts,
                onDismiss: { dismiss() }
            )
            .padding(.top, 30) // Push below notch
            .padding(.horizontal)
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                viewModel.nextQuiz()
            }) {
                Image(systemName: viewModel.currentIndex == viewModel.quizzes.count - 1 ? "checkmark" : "arrow.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue.opacity(viewModel.hasAnsweredCurrentQuiz ? 1.0 : 0.3))
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(radius: 4)
            }
            .padding()
            .disabled(!viewModel.hasAnsweredCurrentQuiz)
            .opacity(viewModel.hasAnsweredCurrentQuiz ? 1 : 0.6)
        }

        .onAppear {
            if viewModel.quizzes.isEmpty {
                switch viewModel.context {
                case .fromSet(let id):
                    viewModel.loadQuizzesFromSet(setId: id)
                case .fromGroup(let id):
                    // Add if you implement group support later
                    break
                case .fromSpace(let id):
                    // Add if you implement space support later
                    break
                case .daily(let limit):
                    viewModel.loadQuizzes(limit: limit)
                case .fromDashboard, .none:
                    viewModel.loadQuizzes()
                }
            }

            if let snapshot = dashboardViewModel.dashboardData {
                viewModel.initialDashboardSnapshot = snapshot
                print("📋 Using shared dashboard snapshot: \(snapshot)")
            } else {
                print("❗️Dashboard data was nil on appear")
            }
        }

        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }
}

struct GlassNavigationButtonStyle: ButtonStyle {
    var isDisabled: Bool = false
    var isHighlighted: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isHighlighted ? Color.blue.opacity(0.2) : Color.white.opacity(0.1))
                        .background(.ultraThinMaterial)
                        .blur(radius: 0.3)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(isHighlighted ? 0.6 : 0.5),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .foregroundColor(isDisabled ? .gray : (isHighlighted ? .white : .primary))
            .shadow(color: .white.opacity(0.15), radius: 2, x: -1, y: -1)
            .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
            .opacity(isDisabled ? 0.6 : 1.0)
    }
}

#Preview {
    QuizPracticeView()
}
struct ProgressBar: View {
    var progress: Double

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundColor(Color.white.opacity(0.2))
            Capsule()
                .frame(width: nil)
                .foregroundColor(Color.blue.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .mask(
                    GeometryReader { geometry in
                        Capsule()
                            .frame(width: geometry.size.width * CGFloat(progress))
                    }
                )
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
}
struct TopBarView: View {
    var progress: Double
    var hearts: Int
    var onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            }

            ProgressBar(progress: progress)
                .frame(height: 8)
                .frame(maxWidth: .infinity)

            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
                Text("\(hearts)")
                    .foregroundColor(.primary)
                    .font(.subheadline)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.5), Color.white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
    }
}
struct QuizMetadataHeaderView: View {
    let quiz: Quiz

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(instructionText(for: quiz.quiz_type))
                .font(.title)
                .foregroundStyle(.blue)
                .padding(.top, 4)

            HStack(alignment: .top, spacing: 12) {
                // 📌 Short description on the left
                if let desc = quiz.short_description {
                    Text(desc)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true) // allow wrapping
                }

                // 📌 Tags (difficulty, author, new) on the right
                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    // Difficulty badge
                    Text(quiz.difficulty)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )

                    // Author if available
                    if let author = quiz.initial_author {
                        Text("Author: #\(author)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    // New badge
                    if let perf = quiz.previous_performance, perf.total_attempts == 0 {
                        Text("New")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }

        }
        .padding(.bottom, 8)
    }

    func instructionText(for type: QuizType) -> String {
        switch type {
        case .multipleChoice: return "Choose the best option."
        case .trueFalse: return "Decide if the statement is true or false."
        case .fillBlank: return "Type in the missing word or phrase."
        case .fillBlankWithOptions: return "Select the best word to complete the sentence."
        }
    }
}
