//
//  QuizDetailView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/5/25.
//

import SwiftUI

struct QuizDetailView: View {
    let quiz: Quiz

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quiz Question:")
                .font(.headline)
            Text(quiz.question)

            if let choices = quiz.choices {
                Text("Choices:")
                    .font(.headline)
                ForEach(choices, id: \.self) { choice in
                    Text("• \(choice)")
                }
            }

            Text("Correct Answer: \(quiz.correct_answer)")
                .foregroundColor(.green)
                .bold()
        }
        .padding()
        .navigationTitle("Quiz Detail")
    }
}

