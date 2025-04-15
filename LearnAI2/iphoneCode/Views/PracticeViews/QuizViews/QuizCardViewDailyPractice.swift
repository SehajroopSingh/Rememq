//
//  QuizCardView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/4/25.
//
import SwiftUI



struct QuizCardViewDailyPractice: View {
    let quiz: Quiz
    @ObservedObject var viewModel: PracticeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch quiz.quiz_type {
            case .multipleChoice:
                MultipleChoiceView(quiz: quiz, viewModel: viewModel)
            case .trueFalse:
                TrueFalseView(quiz: quiz, viewModel: viewModel)
            case .fillBlank:
                FillBlankView(quiz: quiz, viewModel: viewModel)
            case .fillBlankWithOptions:
                FillBlankWithOptionsView(quiz: quiz, viewModel: viewModel)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}
