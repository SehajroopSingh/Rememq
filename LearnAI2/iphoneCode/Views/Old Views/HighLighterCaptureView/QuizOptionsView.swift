////////
////////  QuizOptionsView.swift
////////  ReMEMq
////////
////////  Created by Sehaj Singh on 5/28/25.
////////
//////import SwiftUI
//////
//////struct QuizOptionsView: View {
//////    @Binding var selectedDifficulty: HighlighterView.Difficulty
//////    @Binding var selectedMasteryTime: HighlighterView.MasteryTime
//////    @Binding var selectedDepth: HighlighterView.DepthOfLearning
//////
//////    var body: some View {
//////        VStack(alignment: .leading, spacing: 12) {
//////            Picker("Difficulty", selection: $selectedDifficulty) {
//////                ForEach(HighlighterView.Difficulty.allCases) { option in
//////                    Text(option.rawValue).tag(option)
//////                }
//////            }
//////            .pickerStyle(.segmented)
//////
//////            Picker("Mastery Time", selection: $selectedMasteryTime) {
//////                ForEach(HighlighterView.MasteryTime.allCases) { option in
//////                    Text(option.rawValue).tag(option)
//////                }
//////            }
//////            .pickerStyle(.menu)
//////
//////            Picker("Depth of Learning", selection: $selectedDepth) {
//////                ForEach(HighlighterView.DepthOfLearning.allCases) { option in
//////                    Text(option.rawValue).tag(option)
//////                }
//////            }
//////            .pickerStyle(.menu)
//////        }
//////    }
//////}
////import SwiftUI
////
////struct QuizOptionsView: View {
////    @Binding var selectedDifficulty: HighlighterView.Difficulty
////    @Binding var selectedMasteryTime: HighlighterView.MasteryTime
////    @Binding var selectedDepth: HighlighterView.DepthOfLearning
////    
////    @State private var selectedTab = 0
////    
////    var body: some View {
////        TabView(selection: $selectedTab) {
////            // Difficulty Picker Page
////            VStack(spacing: 16) {
////                Text("Difficulty")
////                    .font(.headline)
////                Picker("", selection: $selectedDifficulty) {
////                    ForEach(HighlighterView.Difficulty.allCases) { option in
////                        Text(option.rawValue).tag(option)
////                    }
////                }
////                .pickerStyle(WheelPickerStyle())
////                .frame(height: 150)
////            }
////            .tag(0)
////            
////            // Mastery Time Picker Page
////            VStack(spacing: 16) {
////                Text("Mastery Time")
////                    .font(.headline)
////                Picker("", selection: $selectedMasteryTime) {
////                    ForEach(HighlighterView.MasteryTime.allCases) { option in
////                        Text(option.rawValue).tag(option)
////                    }
////                }
////                .pickerStyle(WheelPickerStyle())
////                .frame(height: 150)
////            }
////            .tag(1)
////            
////            // Depth of Learning Picker Page
////            VStack(spacing: 16) {
////                Text("Depth of Learning")
////                    .font(.headline)
////                Picker("", selection: $selectedDepth) {
////                    ForEach(HighlighterView.DepthOfLearning.allCases) { option in
////                        Text(option.rawValue).tag(option)
////                    }
////                }
////                .pickerStyle(WheelPickerStyle())
////                .frame(height: 150)
////            }
////            .tag(2)
////        }
////        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
////        .frame(height: 200)
////    }
////}
//import SwiftUI
//
//struct QuizOptionsView: View {
//    @Binding var selectedDifficulty: HighlighterView.Difficulty
//    @Binding var selectedMasteryTime: HighlighterView.MasteryTime
//    @Binding var selectedDepth: HighlighterView.DepthOfLearning
//    @State private var activeIndex: Int = 0
//
//    var body: some View {
//        GeometryReader { geo in
//            let pageWidth = geo.size.width * 0.6
//
//            TabView(selection: $activeIndex) {
//                // Difficulty
//                pickerView(
//                    title: "Difficulty",
//                    selection: $selectedDifficulty,
//                    options: HighlighterView.Difficulty.allCases
//                )
//                .frame(width: pageWidth, height: 200)
//                .scaleEffect(activeIndex == 0 ? 1.0 : 0.85)
//                .opacity(activeIndex == 0 ? 1.0 : 0.5)
//                .tag(0)
//
//                // Mastery Time
//                pickerView(
//                    title: "Mastery Time",
//                    selection: $selectedMasteryTime,
//                    options: HighlighterView.MasteryTime.allCases
//                )
//                .frame(width: pageWidth, height: 200)
//                .scaleEffect(activeIndex == 1 ? 1.0 : 0.85)
//                .opacity(activeIndex == 1 ? 1.0 : 0.5)
//                .tag(1)
//
//                // Depth of Learning
//                pickerView(
//                    title: "Depth of Learning",
//                    selection: $selectedDepth,
//                    options: HighlighterView.DepthOfLearning.allCases
//                )
//                .frame(width: pageWidth, height: 200)
//                .scaleEffect(activeIndex == 2 ? 1.0 : 0.85)
//                .opacity(activeIndex == 2 ? 1.0 : 0.5)
//                .tag(2)
//            }
//            .frame(width: geo.size.width, height: 220)
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never, interPageSpacing: -30))
//            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: activeIndex)
//        }
//        .frame(height: 220)
//    }
//
//    @ViewBuilder
//    private func pickerView<T: Hashable & RawRepresentable>(
//        title: String,
//        selection: Binding<T>,
//        options: [T]
//    ) -> some View where T.RawValue == String {
//        VStack(spacing: 12) {
//            Text(title)
//                .font(.headline)
//            Picker("", selection: selection) {
//                ForEach(options, id: \.self) { option in
//                    Text(option.rawValue).tag(option)
//                }
//            }
//            .pickerStyle(WheelPickerStyle())
//        }
//        .background(.ultraThinMaterial)
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//    }
////}
//import SwiftUI
//
//struct QuizOptionsView: View {
//    @Binding var selectedDifficulty: HighlighterView.Difficulty
//    @Binding var selectedMasteryTime: HighlighterView.MasteryTime
//    @Binding var selectedDepth: HighlighterView.DepthOfLearning
//    @State private var activeCategory: Category = .difficulty
//
//    enum Category: String, CaseIterable, Identifiable {
//        case difficulty = "Difficulty"
//        case mastery = "Mastery Time"
//        case depth = "Depth of Learning"
//        var id: String { rawValue }
//    }
//
//    var body: some View {
//        VStack(spacing: 8) {
//            // Category selector
//            Picker("", selection: $activeCategory) {
//                ForEach(Category.allCases) { cat in
//                    Text(cat.rawValue).tag(cat)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding(.horizontal)
//
//            // Wheel picker for current category
//            wheelPicker(for: activeCategory)
//                .frame(height: 120)
//                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: activeCategory)
//        }
//    }
//
//    @ViewBuilder
//    private func wheelPicker(for category: Category) -> some View {
//        switch category {
//        case .difficulty:
//            Picker("", selection: $selectedDifficulty) {
//                ForEach(HighlighterView.Difficulty.allCases, id: \.self) { option in
//                    Text(option.rawValue)
//                        .font(.callout)
//                        .frame(maxHeight: 30)
//                        .tag(option)
//                }
//            }
//            .pickerStyle(WheelPickerStyle())
//
//        case .mastery:
//            Picker("", selection: $selectedMasteryTime) {
//                ForEach(HighlighterView.MasteryTime.allCases, id: \.self) { option in
//                    Text(option.rawValue)
//                        .font(.callout)
//                        .frame(maxHeight: 30)
//                        .tag(option)
//                }
//            }
//            .pickerStyle(WheelPickerStyle())
//
//        case .depth:
//            Picker("", selection: $selectedDepth) {
//                ForEach(HighlighterView.DepthOfLearning.allCases, id: \.self) { option in
//                    Text(option.rawValue)
//                        .font(.callout)
//                        .frame(maxHeight: 30)
//                        .tag(option)
//                }
//            }
//            .pickerStyle(WheelPickerStyle())
//        }
//    }
//}
import SwiftUI

struct QuizOptionsView: View {
    @Binding var selectedDifficulty: HighlighterView.Difficulty
    @Binding var selectedMasteryTime: HighlighterView.MasteryTime
    @Binding var selectedDepth: HighlighterView.DepthOfLearning
    @State private var activeCategory: Category = .difficulty

    enum Category: String, CaseIterable, Identifiable {
        case difficulty = "Difficulty"
        case mastery = "Mastery Time"
        case depth = "Depth of Learning"
        var id: String { rawValue }
    }

    var body: some View {
        VStack(spacing: 12) {
            // Glassmorphic segmented control
            Picker("", selection: $activeCategory) {
                ForEach(Category.allCases) { cat in
                    Text(cat.rawValue).tag(cat)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(6)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1))
            .padding(.horizontal)

            // Glassmorphic wheel picker
            wheelPicker(for: activeCategory)
                .frame(height: 120)
                .padding(6)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: activeCategory)
        }
    }

    @ViewBuilder
    private func wheelPicker(for category: Category) -> some View {
        switch category {
        case .difficulty:
            Picker("", selection: $selectedDifficulty) {
                ForEach(HighlighterView.Difficulty.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .font(.callout)
                        .frame(maxHeight: 30)
                        .tag(option)
                }
            }
            .pickerStyle(WheelPickerStyle())

        case .mastery:
            Picker("", selection: $selectedMasteryTime) {
                ForEach(HighlighterView.MasteryTime.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .font(.callout)
                        .frame(maxHeight: 30)
                        .tag(option)
                }
            }
            .pickerStyle(WheelPickerStyle())

        case .depth:
            Picker("", selection: $selectedDepth) {
                ForEach(HighlighterView.DepthOfLearning.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .font(.callout)
                        .frame(maxHeight: 30)
                        .tag(option)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}
