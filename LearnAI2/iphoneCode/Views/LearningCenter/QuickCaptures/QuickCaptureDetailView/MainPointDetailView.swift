//
//  MainPointDetailView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 6/5/25.
//
import SwiftUI

struct MainPointDetailView: View {
    let mp: MainPointWithQuizzes

    var body: some View {
        DisclosureGroup(mp.text) {
            // ─── Context ───
            if let context = mp.context {
                InfoBlock(title: "Context", content: context, bgColor: Color.blue.opacity(0.05))
            }

            // ─── Support ───
            if let support = mp.supportingText {
                InfoBlock(title: "Support", content: support, bgColor: Color.yellow.opacity(0.05))
            }

            // ─── State ───
//            if let state = mp.state {
//                SpacedRepetitionStateView(state: state)
//            }
            if let state = mp.state {
                HStack {
                    Spacer()
                    NavigationLink(destination: QuizPerformanceStatsDetailView(mainPoint: mp)) {
                        HStack {
                            Image(systemName: "chart.bar.xaxis")
                            Text("Show Main Point Performance")
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }
            // ─── Quizzes for Main Point ───
            if !mp.quizzes.isEmpty {
                DisclosureGroup("Quizzes for Main Point") {
                    ForEach(mp.quizzes) { quiz in
                        QuizBlock(quiz: quiz)
                    }
                }
            }

            // ─── Subpoints ───
            if !mp.subpoints.isEmpty {
                DisclosureGroup("Subpoints") {
                    ForEach(mp.subpoints) { sp in
                        SubpointDetailView(sp: sp)
                            .padding(.vertical, 4)
                    }
                }
                .bold()

            }
        }
        .bold()

        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary))
    }
}
