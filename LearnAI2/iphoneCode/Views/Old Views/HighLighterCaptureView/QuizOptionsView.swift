//
//  QuizOptionsView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/28/25.
//
import SwiftUI

struct QuizOptionsView: View {
    @Binding var selectedDifficulty: HighlighterView.Difficulty
    @Binding var selectedMasteryTime: HighlighterView.MasteryTime
    @Binding var selectedDepth: HighlighterView.DepthOfLearning

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Difficulty", selection: $selectedDifficulty) {
                ForEach(HighlighterView.Difficulty.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)

            Picker("Mastery Time", selection: $selectedMasteryTime) {
                ForEach(HighlighterView.MasteryTime.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)

            Picker("Depth of Learning", selection: $selectedDepth) {
                ForEach(HighlighterView.DepthOfLearning.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
    }
}
