//
//  QuizCardView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/4/25.
//
import SwiftUI



struct QuizCardViewDailyPractice: View {
    let quiz: Quiz

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch quiz.quiz_type {
            case .multipleChoice:
                MultipleChoiceView(quiz: quiz)
            case .trueFalse:
                TrueFalseView(quiz: quiz)
            case .fillBlank:
                FillBlankView(quiz: quiz)
            case .fillBlankWithOptions:
                FillBlankWithOptionsView(quiz: quiz)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}
