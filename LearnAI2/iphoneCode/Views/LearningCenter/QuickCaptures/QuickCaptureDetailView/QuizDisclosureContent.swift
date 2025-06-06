//
//  QuizDisclosureContent.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 6/5/25.
//

import SwiftUI
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
//            Divider().padding(.vertical, 4)
//            QuizAttemptsView(attempts: quiz.recent_attempts ?? [])
//


        }
        .padding(.top, 4)
    }
}

import SwiftUI

struct InfoBlock: View {
    let title: String
    let content: String
    let bgColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(content)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(6)
        .background(bgColor)
        .cornerRadius(8)
    }
}

struct QuizBlock: View {
    let quiz: Quiz

    var body: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 8) {
                QuizDisclosureContent(quiz: quiz)
                NavigationLink(destination: QuizPerformanceStatsDetailView(quiz: quiz)) {
                    HStack {
                        Image(systemName: "chart.bar.xaxis")
                        Text("View Performance")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
        } label: {
            Text(quiz.quiz_type.rawValue
                    .replacingOccurrences(of: "_", with: " ")
                    .capitalized
            )
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary))
        .padding(.vertical, 4)
    }
}
