//
//  SubpointDetailView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 6/5/25.
//

import SwiftUI

struct SubpointDetailView: View {
    let sp: SubPointWithQuizzes  
    var body: some View {
        DisclosureGroup(sp.text) {
            if let context = sp.context {
                InfoBlock(title: "Context", content: context, bgColor: Color.blue.opacity(0.05))
            }
            if let support = sp.supportingText {
                InfoBlock(title: "Support", content: support, bgColor: Color.yellow.opacity(0.05))
            }
//            if let state = sp.state {
//                SpacedRepetitionStateView(state: state)
//            }
            if let state = sp.state {
                HStack {
                    Spacer()
                    NavigationLink(destination: QuizPerformanceStatsDetailView(subPoint: sp)) {
                        HStack {
                            Image(systemName: "chart.bar.xaxis")
                            Text("Show Subpoint Performance")
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }

            if !sp.quizzes.isEmpty {
                DisclosureGroup("Quizzes for Subpoint") {
                    ForEach(sp.quizzes) { quiz in
                        QuizBlock(quiz: quiz)
                    }
                }
            } else {
                Text("No quizzes for this subpoint").italic()
            }
        }
    }
}
