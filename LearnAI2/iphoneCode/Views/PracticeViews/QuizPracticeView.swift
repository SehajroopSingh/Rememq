//
//  PracticeView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/4/25.
//
import SwiftUI
//
//
//struct QuizPracticeView: View {
//    @StateObject private var viewModel = PracticeViewModel()
//
//    var body: some View {
//        VStack {
//            if !viewModel.quizzes.isEmpty {
//                ProgressView(value: Double(viewModel.currentIndex + 1), total: Double(viewModel.quizzes.count))
//                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
//                    .padding(.horizontal)
//                    .padding(.top)
//            }
//            if viewModel.isLoading {
//                ProgressView("Loading Quizzes...")
//            } else if let error = viewModel.errorMessage {
//                Text("Error: \(error)")
//            } else if viewModel.quizzes.isEmpty {
//                Text("No quizzes found.")
//            } else {
//                let quiz = viewModel.quizzes[viewModel.currentIndex]
//                QuizCardViewDailyPractice(quiz: quiz, viewModel: viewModel)
//                    .id(quiz.id)  // 👈 THIS resets the view state
//                    .environmentObject(viewModel)
//                    .padding()
//
//                HStack {
//                    Button("Previous") {
//                        viewModel.prevQuiz()
//                    }
//                    .disabled(viewModel.currentIndex == 0)
//
//                    Spacer()
//
//                    Button("Next") {
//                        viewModel.nextQuiz()
//                    }
//                    .disabled(viewModel.currentIndex == viewModel.quizzes.count - 1)
//                }
//            }
//        }
//        .onAppear {
//            viewModel.loadQuizzes(limit: 10)
//        }
//        .navigationTitle("Daily Practice")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}

struct QuizPracticeView: View {
    @StateObject private var viewModel = PracticeViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading Quizzes...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
            } else if viewModel.currentIndex >= viewModel.quizzes.count {
                DailyPracticeQuizCompletionView(viewModel: viewModel)
            } else if viewModel.quizzes.isEmpty {
                Text("No quizzes found.")
            } else {
                let quiz = viewModel.quizzes[viewModel.currentIndex]
                QuizCardViewDailyPractice(quiz: quiz, viewModel: viewModel)
                    .id(quiz.id)
                    .environmentObject(viewModel)
                    .padding()

                HStack {
                    Button("Previous") {
                        viewModel.prevQuiz()
                    }
                    .disabled(viewModel.currentIndex == 0)

                    Spacer()

                    if viewModel.currentIndex == viewModel.quizzes.count - 1 {
                        Button("Finish") {
                            viewModel.nextQuiz()  // This will trigger the completion view
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Next") {
                            viewModel.nextQuiz()
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadQuizzes(limit: 10)
        }
        .navigationTitle("Daily Practice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    QuizPracticeView()
}
