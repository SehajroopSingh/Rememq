import SwiftUI
import UIKit

struct HighlighterView: View {
    @State private var text: String = "Highlight parts of this text."
    @State private var isHighlighting = false
    @State private var highlightedRanges: [NSRange] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Highlight Mode", isOn: $isHighlighting)
                .padding()

            CustomTextView(text: $text, isHighlighting: $isHighlighting, highlightedRanges: $highlightedRanges)
                .frame(height: 300)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .padding()

            Text("Normal Text:")
            Text(text)
                .padding(.horizontal)

            Text("Highlighted Substrings:")
            ForEach(highlightedSubstrings(), id: \.self) { substr in
                Text(substr)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
            }
        }
    }

    private func highlightedSubstrings() -> [String] {
        highlightedRanges.compactMap { range in
            guard let swiftRange = Range(range, in: text) else { return nil }
            return String(text[swiftRange])
        }
    }
}

struct CustomTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isHighlighting: Bool
    @Binding var highlightedRanges: [NSRange]

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextView

        init(_ parent: CustomTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard parent.isHighlighting,
                  let textView = gesture.view as? UITextView,
                  let layoutManager = textView.layoutManager as NSLayoutManager?,
                  let textContainer = textView.textContainer as NSTextContainer? else { return }

            let location = gesture.location(in: textView)
            let glyphIndex = layoutManager.glyphIndex(for: location, in: textContainer)
            let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)

            // Highlight word at characterIndex
            if characterIndex < textView.textStorage.length {
                let nsText = textView.textStorage.string as NSString
                let wordRange = nsText.rangeOfWord(at: characterIndex)
                if !parent.highlightedRanges.contains(wordRange) {
                    parent.highlightedRanges.append(wordRange)
                    textView.textStorage.addAttribute(.backgroundColor, value: UIColor.yellow, range: wordRange)
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.text = text

        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        textView.addGestureRecognizer(pan)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

extension NSString {
    func rangeOfWord(at index: Int) -> NSRange {
        let tokenizer = UITextInputStringTokenizer(textInput: UITextView())
        var start = index
        var end = index
        while start > 0 && character(at: start - 1).isLetter {
            start -= 1
        }
        while end < length && character(at: end).isLetter {
            end += 1
        }
        return NSRange(location: start, length: end - start)
    }
}

#Preview {
    HighlighterView()
}