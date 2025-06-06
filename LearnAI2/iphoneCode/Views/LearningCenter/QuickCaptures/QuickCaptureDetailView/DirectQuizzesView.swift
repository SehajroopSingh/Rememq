//
//  DirectQuizzesView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 6/5/25.
//

import SwiftUI
struct DirectQuizzesView: View {
    let directQuizzes: [Quiz]

    var body: some View {
        DisclosureGroup("General Quizzes") {
            ForEach(directQuizzes) { quiz in
                QuizBlock(quiz: quiz)
            }
        }
        .bold()

        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
    }
}
