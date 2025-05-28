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
    @State private var highlighterButtonCenter: CGPoint = .zero
    @Namespace private var gestureSpace



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
//                        Circle()
//                            .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
//                            .frame(width: 32, height: 32)
//                            .onTapGesture {
//                                withAnimation { showWheel.toggle() }
//                                isErasing = false
//                            }
//                            .gesture(
//                                LongPressGesture(minimumDuration: 0.4)
//                                    .onEnded { _ in
//                                        dragLocation = CGPoint(
//                                            x: geo.frame(in: .global).midX,
//                                            y: geo.frame(in: .global).minY + 60
//                                        )
//                                        withAnimation { showWheel = true }
//                                    }
//                            )
//                            .simultaneousGesture(
//                                DragGesture(minimumDistance: 0)
//                                    .onChanged { drag in dragLocation = drag.location }
//                                    .onEnded { _ in
//                                        let color = pickColor(
//                                            at: dragLocation,
//                                            center: CGPoint(x: geo.size.width / 2, y: 60)
//                                        )
//                                        onColorPicked(color)
//                                        isHighlighting = true
//                                        withAnimation { showWheel = false }
//                                    }
//                            )
                        // Highlighter button (with position tracking)
//                        GeometryReader { buttonGeo in
                            Circle()
                                .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
                                .frame(width: 32, height: 32)
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


//                                .onTapGesture {
//                                    isErasing = false
//
//                                    if isHighlighting {
//                                        // Exit highlighting mode & hide flywheel
//                                        isHighlighting = false
//                                        showWheel = false
//                                    } else {
//                                        // Enter highlighting mode
//                                        isHighlighting = true
//
//                                        // Use consistent coordinate space
//                                        let btnFrame = buttonGeo.frame(in: .named("editorSpace"))
//                                        highlighterButtonCenter = CGPoint(x: btnFrame.midX, y: btnFrame.midY)
//
//                                        // Show flywheel with animation
//                                        withAnimation { showWheel = true }
//
//                                        // Auto-close flywheel after 3 seconds
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                            if showWheel {
//                                                withAnimation { showWheel = false }
//                                            }
//                                        }
//                                    }
//                                }
                                .onTapGesture {
                                  isErasing = false
                                  if isHighlighting {
                                    isHighlighting = false
                                    showWheel = false
                                  } else {
                                    isHighlighting = true
                                    withAnimation { showWheel = true }
                                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                      if showWheel { withAnimation { showWheel = false } }
                                    }
                                  }
                                }


//                                .gesture(
//                                    LongPressGesture(minimumDuration: 0.2)
//                                        .onEnded { _ in
//                                            dragLocation = highlighterButtonCenter
//                                            withAnimation { showWheel = true }
//                                        }
//                                )
//                                .simultaneousGesture(
//                                    DragGesture(minimumDistance: 0)
////                                        .onChanged { drag in
////                                            dragLocation = drag.location
////                                        }
////                                        .onEnded { drag in
////                                            // Convert drag.location relative to buttonGeo into editorSpace coordinates
////                                            let buttonOrigin = buttonGeo.frame(in: .named("editorSpace")).origin
////                                            dragLocation = buttonOrigin + drag.location
////
////                                            let color = pickColor(at: dragLocation, center: highlighterButtonCenter)
////                                            onColorPicked(color)
////                                            isHighlighting = true
////                                            withAnimation { showWheel = false }
////                                        }
//                                        .onChanged { drag in
//                                            // local-to-global, then global-to-editor
//                                            let btnFrameGlobal = buttonGeo.frame(in: .global)
//                                            let editorOrigin   = geo.frame(in: .global).origin
//                                            let globalPoint    = CGPoint(x: btnFrameGlobal.minX + drag.location.x,
//                                                                         y: btnFrameGlobal.minY + drag.location.y)
//                                            dragLocation = CGPoint(x: globalPoint.x - editorOrigin.x,
//                                                                   y: globalPoint.y - editorOrigin.y)
//                                        }
//                                        .onEnded { _ in
//                                            let color = pickColor(at: dragLocation, center: highlighterButtonCenter)
//                                            onColorPicked(color)
//                                            isHighlighting = true
//                                            withAnimation { showWheel = false }
//                                        }
//
//                                )
//
////                        }
//                        .frame(width: 32, height: 32)
                                .gesture(
                                  DragGesture(minimumDistance: 0, coordinateSpace: .named("editorSpace"))
                                    .onChanged { value in
                                      dragLocation = value.location
                                    }
                                    .onEnded { _ in
                                      let color = pickColor(at: dragLocation, center: highlighterButtonCenter)
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
                        center: highlighterButtonCenter,
                        dragLocation: dragLocation,
                        colors: HighlighterView.HighlightColor.allCases
                    )
                }

            }
        }
        .coordinateSpace(name: "editorSpace")
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
extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

