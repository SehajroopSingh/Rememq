import SwiftUI

struct ContentEditorView: View {
    @Binding var text: String
    @Binding var isHighlighting: Bool
    @Binding var selectedColor: HighlighterView.HighlightColor
    @Binding var highlightedRanges: [(range: NSRange, color: HighlighterView.HighlightColor)]
    @Binding var isErasing: Bool

    var body: some View {
        VStack(spacing: 0) {
            // 1. Header
            HStack {
                Text("Enter your thought here…")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                // Highlighter
                Circle()
                    .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        isHighlighting.toggle()
                        isErasing = false
                    }
                // Eraser
                Button {
                    isErasing.toggle()
                    isHighlighting = false
                } label: {
                    Image(systemName: "eraser.fill")
                }
                .frame(width: 32, height: 32)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            Divider().background(Color.white.opacity(0.3))

            // 2. Text Editor
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
    }
}
