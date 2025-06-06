//////
//////  ContentEditorView.swift
//////  ReMEMq
//////
//////  Created by Sehaj Singh on 5/28/25.
//////
////
////
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
//    @Binding var showWheel: Bool
//    @Binding var dragLocation: CGPoint
//    let onColorPicked: (HighlighterView.HighlightColor) -> Void
//    @State private var highlighterButtonCenter: CGPoint = .zero
//    @Namespace private var gestureSpace
//
//
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                VStack(spacing: 0) {
//                    HStack {
//                        Text("Expand your thought here…")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        Spacer()
//
//                        ZStack {
//                            Circle()
//                                .stroke(Color(selectedColor.uiColor).opacity(isHighlighting ? 0.6 : 0.2), lineWidth: isHighlighting ? 4 : 2)
//                                .scaleEffect(isHighlighting ? 1.2 : 1.0)
//                                .animation(.easeInOut, value: isHighlighting)
//
//                            Circle()
//                                .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
//
//                            Image(systemName: "paintpalette")
//                                .foregroundColor(isHighlighting ? .white : .gray)
//                        }
//                        .frame(width: 40, height: 40)
//
//                                .background(
//                                  GeometryReader { gr in
//                                    Color.clear
//                                      .onAppear {
//                                        let f = gr.frame(in: .named("editorSpace"))
//                                        highlighterButtonCenter = CGPoint(x: f.midX, y: f.midY)
//                                      }
//                                      .onChange(of: showWheel) { _ in
//                                        let f = gr.frame(in: .named("editorSpace"))
//                                        highlighterButtonCenter = CGPoint(x: f.midX, y: f.midY)
//                                      }
//                                  }
//                                )
//
//
//                                .onTapGesture {
//                                    // Just toggle highlight mode using current selectedColor
//                                    isErasing = false
//                                    isHighlighting.toggle()
//                                    showWheel = false
//                                }
//                                .simultaneousGesture(
//                                    LongPressGesture(minimumDuration: 0.4)
//                                        .onEnded { _ in
//                                            isErasing = false
//                                            isHighlighting = true
//                                            withAnimation { showWheel = true }
//                                        }
//                                )
//                                .simultaneousGesture(
//                                    DragGesture(minimumDistance: 0, coordinateSpace: .named("editorSpace"))
//                                        .onChanged { value in
//                                            dragLocation = value.location
//                                        }
//                                        .onEnded { _ in
//                                            if showWheel {
//                                                let color = pickColor(at: dragLocation, center: highlighterButtonCenter)
//                                                onColorPicked(color)
//                                                isHighlighting = true
//                                                withAnimation { showWheel = false }
//                                            }
//                                        }
//                                )
//
//
//
//
//
//
//                        // Eraser button
//                        Button {
//                            isErasing.toggle()
//                            isHighlighting = false
//                            showWheel = false
//                        } label: {
//                            Image(systemName: "eraser.fill")
//                        }
//                        .frame(width: 32, height: 32)
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 8)
//
//                    Divider().background(Color.white.opacity(0.3))
//
//                    CustomTextView(
//                        selectedColor: $selectedColor,
//                        text: $text,
//                        isHighlighting: $isHighlighting,
//                        highlightedRanges: $highlightedRanges,
//                        isErasing: $isErasing
//                    )
//                    .frame(minHeight: 200)
//                    .padding()
//                }
////                .background(.ultraThinMaterial)
////                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
////                .overlay(
////                    RoundedRectangle(cornerRadius: 20, style: .continuous)
////                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
////                )
////                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
////                .padding(.horizontal, 16)
//                .frame(maxWidth: .infinity)
//                .background(
//                  ZStack {
//                    // 1) Frosted glass fill + blur + dual shadows
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                      .fill(Color.white.opacity(0.15))
//                      .background(.ultraThinMaterial)
//                      .blur(radius: 0.5)
//                      .shadow(color: .white.opacity(0.2), radius: 5, x: -5, y: -5)
//                      .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 5)
//
//                    // 2) Inner “shine” stroke
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                      .strokeBorder(
//                        LinearGradient(
//                          colors: [Color.white.opacity(0.6), Color.white.opacity(0.05)],
//                          startPoint: .topLeading,
//                          endPoint: .bottomTrailing
//                        ),
//                        lineWidth: 1.5
//                      )
//                  }
//                )
//                .padding(.horizontal, 16)
//                // Flywheel Overlay
//                if showWheel {
//                    FlywheelMenu(
//                        center: highlighterButtonCenter,
//                        dragLocation: dragLocation,
//                        colors: HighlighterView.HighlightColor.allCases
//                    )
//                }
//
//            }
//        }
//        .coordinateSpace(name: "editorSpace")
//    }
//
//    private func pickColor(at point: CGPoint, center: CGPoint) -> HighlighterView.HighlightColor {
//        let dx = point.x - center.x
//        let dy = point.y - center.y
//        let angle = atan2(dy, dx) + .pi / 4
//        let count = HighlighterView.HighlightColor.allCases.count
//        let raw = (angle < 0 ? angle + 2 * .pi : angle)
//        let idx = Int(raw / (2 * .pi) * CGFloat(count)) % count
//        return HighlighterView.HighlightColor.allCases[idx]
//    }
//}
//extension CGPoint {
//    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
//        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
//    }
//}
////
//import SwiftUI
//
//struct ContentEditorView: View {
//    @Binding var text: String
//    @Binding var isHighlighting: Bool
//    @Binding var selectedColor: HighlighterView.HighlightColor
//    @Binding var highlightedRanges: [(range: NSRange, color: HighlighterView.HighlightColor)]
//    @Binding var isErasing: Bool
//
//    @Binding var showWheel: Bool
//    @Binding var dragLocation: CGPoint
//    @Binding var additionalContext: String    // Binding for context field
//    let onColorPicked: (HighlighterView.HighlightColor) -> Void
//
//    @State private var highlighterButtonCenter: CGPoint = .zero
//    @Namespace private var gestureSpace
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                VStack(spacing: 0) {
//                    // Header with palette & eraser
//                    HStack {
//                        Text("Expand your thought here…")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        Spacer()
//
//                        // Highlighter button
//                        ZStack {
//                            Circle()
//                                .stroke(Color(selectedColor.uiColor)
//                                            .opacity(isHighlighting ? 0.6 : 0.2),
//                                        lineWidth: isHighlighting ? 4 : 2)
//                                .scaleEffect(isHighlighting ? 1.2 : 1.0)
//                                .animation(.easeInOut, value: isHighlighting)
//
//                            Circle()
//                                .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
//                            Image(systemName: "paintpalette")
//                                .foregroundColor(isHighlighting ? .white : .gray)
//                        }
//                        .frame(width: 40, height: 40)
//                        .background(
//                          GeometryReader { gr in
//                            Color.clear
//                              .onAppear {
//                                let f = gr.frame(in: .named("editorSpace"))
//                                highlighterButtonCenter = CGPoint(x: f.midX, y: f.midY)
//                              }
//                              .onChange(of: showWheel) { _ in
//                                let f = gr.frame(in: .named("editorSpace"))
//                                highlighterButtonCenter = CGPoint(x: f.midX, y: f.midY)
//                              }
//                          }
//                        )
//                        .onTapGesture {
//                            isErasing = false
//                            isHighlighting.toggle()
//                            showWheel = false
//                        }
//                        .simultaneousGesture(
//                            LongPressGesture(minimumDuration: 0.4)
//                                .onEnded { _ in
//                                    isErasing = false
//                                    isHighlighting = true
//                                    withAnimation { showWheel = true }
//                                }
//                        )
//                        .simultaneousGesture(
//                            DragGesture(minimumDistance: 0, coordinateSpace: .named("editorSpace"))
//                                .onChanged { value in dragLocation = value.location }
//                                .onEnded { _ in
//                                    if showWheel {
//                                        let color = pickColor(at: dragLocation, center: highlighterButtonCenter)
//                                        onColorPicked(color)
//                                        isHighlighting = true
//                                        withAnimation { showWheel = false }
//                                    }
//                                }
//                        )
//
//                        // Eraser button
//                        Button {
//                            isErasing.toggle()
//                            isHighlighting = false
//                            showWheel = false
//                        } label: {
//                            Image(systemName: "eraser.fill")
//                        }
//                        .frame(width: 32, height: 32)
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 8)
//
//                    Divider().background(Color.white.opacity(0.3))
//
//                    // Editable text area
//                    CustomTextView(
//                        selectedColor: $selectedColor,
//                        text: $text,
//                        isHighlighting: $isHighlighting,
//                        highlightedRanges: $highlightedRanges,
//                        isErasing: $isErasing
//                    )
//                    .frame(minHeight: 200)
//                    .padding()
//
//                    // Divider and embedded context editor
//                    Divider()
//                        .padding(.horizontal)
//                        .padding(.top, 8)
//
//                    TextEditor(text: $additionalContext)
//                        .frame(minHeight: 50, maxHeight: 80)
//                        .padding(.horizontal)
//                        .font(.body)
//                        .foregroundColor(.primary)
//
//                }
//                .frame(maxWidth: .infinity)
//                .background(
//                  ZStack {
//                    // Glassmorphic background
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                      .fill(Color.white.opacity(0.15))
//                      .background(.ultraThinMaterial)
//                      .blur(radius: 0.5)
//                      .shadow(color: .white.opacity(0.2), radius: 5, x: -5, y: -5)
//                      .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 5)
//
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                      .strokeBorder(
//                        LinearGradient(
//                          colors: [Color.white.opacity(0.6), Color.white.opacity(0.05)],
//                          startPoint: .topLeading,
//                          endPoint: .bottomTrailing
//                        ),
//                        lineWidth: 1.5
//                      )
//                  }
//                )
//                .padding(.horizontal, 16)
//
//                // Flywheel overlay
//                if showWheel {
//                    FlywheelMenu(
//                        center: highlighterButtonCenter,
//                        dragLocation: dragLocation,
//                        colors: HighlighterView.HighlightColor.allCases
//                    )
//                }
//            }
//        }
//        .coordinateSpace(name: "editorSpace")
//    }
//
//    private func pickColor(at point: CGPoint, center: CGPoint) -> HighlighterView.HighlightColor {
//        let dx = point.x - center.x
//        let dy = point.y - center.y
//        let angle = atan2(dy, dx) + .pi / 4
//        let count = HighlighterView.HighlightColor.allCases.count
//        let raw = angle < 0 ? angle + 2 * .pi : angle
//        let idx = Int(raw / (2 * .pi) * CGFloat(count)) % count
//        return HighlighterView.HighlightColor.allCases[idx]
//    }
//}
//
//extension CGPoint {
//    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
//        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
//    }
//}
import SwiftUI

struct ContentEditorView: View {
    @Binding var thought: String
    @Binding var isHighlighting: Bool
    @Binding var selectedColor: HighlighterView.HighlightColor
    @Binding var highlightedRanges: [(range: NSRange, color: HighlighterView.HighlightColor)]
    @Binding var isErasing: Bool
    
    @Binding var showWheel: Bool
    @Binding var dragLocation: CGPoint
    @Binding var additionalContext: String
    let onColorPicked: (HighlighterView.HighlightColor) -> Void
    
    @State private var highlighterButtonCenter: CGPoint = .zero
    @Namespace private var gestureSpace
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 0) {
                    header
                    Divider().background(Color.white.opacity(0.3))
                    editor
                    Divider()
                        .padding(.horizontal)
                        .blendMode(.overlay)
                        .opacity(0.5)
                    contextSection
                }
                .padding()
                .background(glassBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                if showWheel {
                    FlywheelMenu(
                        center: highlighterButtonCenter,
                        dragLocation: dragLocation,
                        colors: HighlighterView.HighlightColor.allCases
                    )
                }
            }
        }
        .coordinateSpace(name: "editorSpace")
        // ─── ADD THIS TOOLBAR so the TextEditor gets a “Done” button ───
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil
                    )
                }
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("Expand your thought here…")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            highlighterButton
            eraserButton
        }
    }
    
    private var editor: some View {
//        CustomTextView(
//            selectedColor: $selectedColor,
//            text: $text,
//            isHighlighting: $isHighlighting,
//            highlightedRanges: $highlightedRanges,
//            isErasing: $isErasing
//        )
//        .frame(minHeight: 200)
//        .padding(.vertical, 8)
        ZStack(alignment: .topLeading) {
            if thought.isEmpty {
                Text("Start typing your thought...")
                    .foregroundColor(.gray)
                    .padding(.top, 18)
                    .padding(.horizontal, 22)
            }

            CustomTextView(
                selectedColor: $selectedColor,
                text: $thought,
                isHighlighting: $isHighlighting,
                highlightedRanges: $highlightedRanges,
                isErasing: $isErasing
            )
        }
        .frame(minHeight: 200)
        .padding(.vertical, 8)
    }
    
    private var contextSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Divider()
                .background(Color.white.opacity(0.3))

            ZStack(alignment: .topLeading) {
                // Placeholder
                if additionalContext.isEmpty {
                    Text("Additional Context (optional)")
                        .foregroundColor(.gray)
                        .font(.body)
                        .padding(.top, 8)
                        .padding(.horizontal, 5)
                }

                // Editable TextEditor
                TextEditor(text: $additionalContext)
                    .font(.body)
                    .frame(minHeight: 40, maxHeight: 80)
                    .foregroundColor(.primary)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, -4)
            }
        }
    }



    
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.10))
                .background(.ultraThinMaterial)
                .blur(radius: 1)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.5), Color.white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
    
    private var highlighterButton: some View {
        ZStack {
            Circle()
                .stroke(Color(selectedColor.uiColor)
                    .opacity(isHighlighting ? 0.6 : 0.2),
                        lineWidth: isHighlighting ? 4 : 2)
                .scaleEffect(isHighlighting ? 1.2 : 1.0)
                .animation(.easeInOut, value: isHighlighting)
            Circle()
                .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
            Image(systemName: "paintpalette")
                .foregroundColor(isHighlighting ? .white : .gray)
        }
        .frame(width: 40, height: 40)
        .background(
            GeometryReader { gr in
                Color.clear
                    .onAppear {
                        let f = gr.frame(in: .named("editorSpace"))
                        highlighterButtonCenter = CGPoint(x: f.midX, y: f.midY)
                    }
                    .onChange(of: showWheel) { _ in
                        let f = gr.frame(in: .named("editorSpace"))
                        highlighterButtonCenter = CGPoint(x: f.midX, y: f.midY)
                    }
            }
        )
        .onTapGesture {
            isErasing = false; isHighlighting.toggle(); showWheel = false
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4)
                .onEnded { _ in isErasing = false; isHighlighting = true; withAnimation { showWheel = true } }
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named("editorSpace"))
                .onChanged { dragLocation = $0.location }
                .onEnded { _ in
                    if showWheel {
                        let color = pickColor(at: dragLocation, center: highlighterButtonCenter)
                        onColorPicked(color); isHighlighting = true; withAnimation { showWheel = false }
                    }
                }
        )
    }
    
    private var eraserButton: some View {
        Button {
            isErasing.toggle(); isHighlighting = false; showWheel = false
        } label: {
            Image(systemName: "eraser.fill")
                .foregroundColor(.gray)
        }
        .frame(width: 32, height: 32)
    }
    
    private func pickColor(at point: CGPoint, center: CGPoint) -> HighlighterView.HighlightColor {
        let dx = point.x - center.x
        let dy = point.y - center.y
        let angle = atan2(dy, dx) + .pi / 4
        let count = HighlighterView.HighlightColor.allCases.count
        let raw = angle < 0 ? angle + 2 * .pi : angle
        let idx = Int(raw / (2 * .pi) * CGFloat(count)) % count
        return HighlighterView.HighlightColor.allCases[idx]
    }
}

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
