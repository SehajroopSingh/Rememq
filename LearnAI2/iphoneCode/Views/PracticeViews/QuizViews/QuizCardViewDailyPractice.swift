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
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.15))
                    .background(.ultraThinMaterial)
                    .blur(radius: 0.5)
                
                // Subtle inner shadow
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.6), Color.white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
        )
        .shadow(color: .white.opacity(0.2), radius: 2, x: -2, y: -2)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 4)
        .cornerRadius(20)
    }
}
func instructionText(for type: QuizType) -> String {
    switch type {
    case .multipleChoice: return "Choose the best option."
    case .trueFalse: return "Decide if the statement is true or false."
    case .fillBlank: return "Fill in the missing word or phrase."
    case .fillBlankWithOptions: return "Select the best option to fill the blank."
    }
}
