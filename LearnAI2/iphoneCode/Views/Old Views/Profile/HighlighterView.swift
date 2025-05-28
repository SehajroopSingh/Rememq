
//
//import SwiftUI
//import UIKit
//
//struct HighlighterView: View {
//    enum HighlightColor: String, CaseIterable, Identifiable {
//        case yellow, green, pink
//        var id: String { self.rawValue }
//        var uiColor: UIColor {
//            switch self {
//            case .yellow: return .yellow
//            case .green: return .green
//            case .pink: return .systemPink
//            }
//        }
//    }
//    @State private var text: String = "Highlight parts of this text."
//    @State private var isHighlighting = false
//    @State private var highlightedRanges: [(range: NSRange, color: HighlightColor)] = []
//    @State private var selectedColor: HighlightColor = .yellow
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Toggle("Highlight Mode", isOn: $isHighlighting)
//
//            Picker("Highlight Color", selection: $selectedColor) {
//                ForEach(HighlightColor.allCases) { color in
//                    Text(color.rawValue.capitalized)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//                .padding()
//
//            CustomTextView(selectedColor: $selectedColor, text: $text, isHighlighting: $isHighlighting, highlightedRanges: $highlightedRanges)
//
//                .frame(height: 300)
//                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//                .padding()
//
//            Text("Normal Text:")
//            Text(text)
//                .padding(.horizontal)
//
//            Text("Highlighted Substrings:")
//            ForEach(highlightedSubstrings(), id: \.self) { substr in
//                Text(substr)
//                    .foregroundColor(.blue)
//                    .padding(.horizontal)
//            }
//        }
//    }
//
//    private func highlightedSubstrings() -> [String] {
//    return highlightedRanges
//        .sorted(by: { $0.range.location < $1.range.location })
//        .compactMap { item in
//            guard let swiftRange = Range(item.range, in: text) else { return nil }
//            return String(text[swiftRange])
//        }
//    }
//    
//}
//struct CustomTextView: UIViewRepresentable {
//    @Binding var selectedColor: HighlighterView.HighlightColor
//    @Binding var text: String
//    @Binding var isHighlighting: Bool
//    @Binding var highlightedRanges: [(range: NSRange, color: HighlighterView.HighlightColor)]
//
//    class Coordinator: NSObject, UITextViewDelegate {
//        var parent: CustomTextView
//
//        init(_ parent: CustomTextView) {
//            self.parent = parent
//        }
//
//        func textViewDidChange(_ textView: UITextView) {
//            parent.text = textView.text
//        }
//
//        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//            guard parent.isHighlighting,
//                  let textView = gesture.view as? UITextView else { return }
//
//            let layoutManager = textView.layoutManager
//            let textContainer = textView.textContainer
//            let location = gesture.location(in: textView)
//
//            let textOffset = CGPoint(
//                x: location.x - textView.textContainerInset.left,
//                y: location.y - textView.textContainerInset.top
//            )
//
//            layoutManager.ensureLayout(for: textContainer)
//
//            let glyphIndex = layoutManager.glyphIndex(for: textOffset, in: textContainer)
//            let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
//
//            if characterIndex < textView.textStorage.length {
//                let nsText = textView.textStorage.string as NSString
//                let wordRange = nsText.rangeOfWord(at: characterIndex)
//
//                if !parent.highlightedRanges.contains(where: { NSIntersectionRange($0.range, wordRange).length > 0 }) {
//                    parent.highlightedRanges.append((range: wordRange, color: parent.selectedColor))
//                    textView.textStorage.addAttribute(.backgroundColor, value: parent.selectedColor.uiColor, range: wordRange)
//                }
//            }
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> UITextView {
//        let textView = UITextView()
//        textView.font = UIFont.systemFont(ofSize: 18)
//        textView.delegate = context.coordinator
//        textView.isScrollEnabled = true
//        textView.isEditable = true
//        textView.isSelectable = true
//
//        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
//        pan.cancelsTouchesInView = false
//        textView.addGestureRecognizer(pan)
//
//        return textView
//    }
//
//    func updateUIView(_ uiView: UITextView, context: Context) {
//        let attributed = NSMutableAttributedString(string: text)
//        for item in highlightedRanges {
//            attributed.addAttribute(.backgroundColor, value: item.color.uiColor, range: item.range)
//        }
//        uiView.attributedText = attributed
//    }
//}
//
//extension NSString {
//    func rangeOfWord(at index: Int) -> NSRange {
//        var start = index
//        var end = index
//
//        while start > 0 {
//            let c = character(at: start - 1)
//            guard let scalar = UnicodeScalar(c) else { break }
//            if !Character(scalar).isLetter { break }
//            start -= 1
//        }
//
//        while end < length {
//            let c = character(at: end)
//            guard let scalar = UnicodeScalar(c) else { break }
//            if !Character(scalar).isLetter { break }
//            end += 1
//        }
//
//        return NSRange(location: start, length: end - start)
//    }
//}
//
//#Preview {
//    HighlighterView()
//}
