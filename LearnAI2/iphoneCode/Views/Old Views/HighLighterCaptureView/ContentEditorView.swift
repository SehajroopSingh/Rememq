////
////  ContentEditorView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 5/28/25.
////
//
//
//import SwiftUI
//
//struct ContentEditorView: View {
//    @Binding var text: String
//    @Binding var isHighlighting: Bool
//    @Binding var selectedColor: HighlighterView.HighlightColor
//    @Binding var highlightedRanges: [(range: NSRange, color: HighlighterView.HighlightColor)]
//    @Binding var isErasing: Bool
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // 1. Header
//            HStack {
//                Text("Enter your thought here…")
//                    .font(.headline)
//                    .foregroundColor(.secondary)
//                Spacer()
//                // Highlighter
//                Circle()
//                    .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
//                    .frame(width: 32, height: 32)
//                    .onTapGesture {
//                        isHighlighting.toggle()
//                        isErasing = false
//                    }
//                // Eraser
//                Button {
//                    isErasing.toggle()
//                    isHighlighting = false
//                } label: {
//                    Image(systemName: "eraser.fill")
//                }
//                .frame(width: 32, height: 32)
//            }
//            .padding(.horizontal)
//            .padding(.top, 8)
//
//            Divider().background(Color.white.opacity(0.3))
//
//            // 2. Text Editor
//            CustomTextView(
//                selectedColor: $selectedColor,
//                text: $text,
//                isHighlighting: $isHighlighting,
//                highlightedRanges: $highlightedRanges,
//                isErasing: $isErasing
//            )
//            .frame(minHeight: 200)
//            .padding()
//        }
//        .background(.ultraThinMaterial)
//        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//        .overlay(
//            RoundedRectangle(cornerRadius: 20, style: .continuous)
//                .stroke(Color.white.opacity(0.3), lineWidth: 1)
//        )
//        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
//        .padding(.horizontal, 16)
//    }
//}
import SwiftUI

struct ContentEditorView: View {
    @Binding var text: String
    @Binding var isHighlighting: Bool
    @Binding var selectedColor: HighlighterView.HighlightColor
    @Binding var highlightedRanges: [(range: NSRange, color: HighlighterView.HighlightColor)]
    @Binding var isErasing: Bool

    @Binding var showWheel: Bool
    @Binding var dragLocation: CGPoint
    let onColorPicked: (HighlighterView.HighlightColor) -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("Enter your thought here…")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        // Highlighter button
                        Circle()
                            .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                withAnimation { showWheel.toggle() }
                                isErasing = false
                            }
                            .gesture(
                                LongPressGesture(minimumDuration: 0.4)
                                    .onEnded { _ in
                                        dragLocation = CGPoint(
                                            x: geo.frame(in: .global).midX,
                                            y: geo.frame(in: .global).minY + 60
                                        )
                                        withAnimation { showWheel = true }
                                    }
                            )
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { drag in dragLocation = drag.location }
                                    .onEnded { _ in
                                        let color = pickColor(
                                            at: dragLocation,
                                            center: CGPoint(x: geo.size.width / 2, y: 60)
                                        )
                                        onColorPicked(color)
                                        isHighlighting = true
                                        withAnimation { showWheel = false }
                                    }
                            )

                        // Eraser button
                        Button {
                            isErasing.toggle()
                            isHighlighting = false
                            showWheel = false
                        } label: {
                            Image(systemName: "eraser.fill")
                        }
                        .frame(width: 32, height: 32)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Divider().background(Color.white.opacity(0.3))

                    CustomTextView(
                        selectedColor: $selectedColor,
                        text: $text,
                        isHighlighting: $isHighlighting,
                        highlightedRanges: $highlightedRanges,
                        isErasing: $isErasing
                    )
                    .frame(minHeight: 200)
                    .padding()
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 16)

                // Flywheel Overlay
                if showWheel {
                    FlywheelMenu(
                        center: CGPoint(x: geo.size.width / 2, y: 60),
                        dragLocation: dragLocation,
                        colors: HighlighterView.HighlightColor.allCases
                    )
                }
            }
        }
    }

    private func pickColor(at point: CGPoint, center: CGPoint) -> HighlighterView.HighlightColor {
        let dx = point.x - center.x
        let dy = point.y - center.y
        let angle = atan2(dy, dx) + .pi / 4
        let count = HighlighterView.HighlightColor.allCases.count
        let raw = (angle < 0 ? angle + 2 * .pi : angle)
        let idx = Int(raw / (2 * .pi) * CGFloat(count)) % count
        return HighlighterView.HighlightColor.allCases[idx]
    }
}
