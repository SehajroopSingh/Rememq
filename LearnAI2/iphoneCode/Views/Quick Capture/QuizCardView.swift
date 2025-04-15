////
////  QuizCardView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 3/6/25.
////
//
//
//import SwiftUI
//
//struct QuizCardView: View {
//    let quiz: Quiz
//    @State private var selectedAnswer: String? = nil  // Track user selection
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            Text(quiz.question)
//                .font(.headline)
//
//            if let choices = quiz.choices {
//                ForEach(choices, id: \.self) { choice in
//                    Button(action: {
//                        selectedAnswer = choice  // Set selected answer
//                    }) {
//                        HStack {
//                            Text(choice)
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(selectedAnswer == choice
//                                            ? (choice == quiz.correct_answer ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
//                                            : Color.clear) // Highlight selection
//                                .cornerRadius(8)
//                        }
//                    }
//                    .disabled(selectedAnswer != nil)  // Disable after selection
//                    .buttonStyle(PlainButtonStyle())  // Removes default button styling
//                }
//            }
//
//            // ✅ Show feedback after selection
//            if let selected = selectedAnswer {
//                Text(selected == quiz.correct_answer ? "✅ Correct!" : "❌ Incorrect!")
//                    .font(.subheadline)
//                    .foregroundColor(selected == quiz.correct_answer ? .green : .red)
//                    .bold()
//                    .padding(.top, 5)
//            }
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(8)
//    }
//}
