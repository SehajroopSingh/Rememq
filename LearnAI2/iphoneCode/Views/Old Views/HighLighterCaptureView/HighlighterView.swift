import SwiftUI
import UIKit

struct HighlighterView: View {
    enum HighlightColor: String, CaseIterable, Identifiable {
      case yellow = "yellow"
      case blue   = "blue"
      case green  = "green"
      case red    = "red"

      var id: Self { self }
      var uiColor: UIColor {
        switch self {
          case .yellow: return .yellow
          case .blue:   return .systemBlue
          case .green:  return .green
          case .red:    return .systemRed
        }
      }
    }

    
    // Presentation bindings
    @Binding var isExpanded: Bool
    @Binding var showAcknowledgment: Bool

    // Text input
    @State private var thought: String = ""
    @State private var additionalContext: String = ""
    @State private var responseMessage: String = ""

    // Structure loader
    @StateObject private var viewModel = StructureViewModel()

    // Selections (Optional so Picker can bind)
    @State private var selectedSpace: Space?
    @State private var selectedGroup: Group?
    @State private var selectedSet: SetItem?
    // Quiz options
    enum Difficulty: String, CaseIterable, Identifiable {
        case easy = "Easy", mediumEasy = "Medium-Easy", medium = "Medium", mediumHard = "Medium-Hard", hard = "Hard"
        var id: String { rawValue }
    }
    enum MasteryTime: String, CaseIterable, Identifiable {
        case threeDays = "3 days", oneWeek = "1 week", twoWeeks = "2 weeks", threeWeeks = "3 weeks"
        case oneMonth = "1 month", threeMonths = "3 months", oneYear = "1 year", indefinitely = "Indefinitely"
        var id: String { rawValue }
    }
    enum DepthOfLearning: String, CaseIterable, Identifiable {
        case normal = "Normal", college = "College", master = "Master", phd = "Phd"
        var id: String { rawValue }
    }
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var selectedMasteryTime: MasteryTime = .oneMonth
    @State private var selectedDepth: DepthOfLearning = .normal


    // MARK: – State
    @State private var text = "Highlight parts of this text."
    @State private var isHighlighting = false
    @State private var selectedColor: HighlightColor = .yellow
    @State private var highlightedRanges: [(range: NSRange, color: HighlightColor)] = []

    @State private var showWheel = false
    @State private var wheelCenter: CGPoint = .zero
    @State private var dragLocation: CGPoint = .zero
    @State private var isErasing = false



    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                PickerSectionView(
                    viewModel: viewModel,
                    selectedSpace: $selectedSpace,
                    selectedGroup: $selectedGroup,
                    selectedSet: $selectedSet
                )

                QuizOptionsView(
                    selectedDifficulty: $selectedDifficulty,
                    selectedMasteryTime: $selectedMasteryTime,
                    selectedDepth: $selectedDepth
                )

                saveButton

                if !responseMessage.isEmpty {
                    Text(responseMessage)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
            }

            .padding()
            .navigationTitle("Expand Your Thought")

            .onAppear {
                print("[DEBUG] FullCaptureView appeared, loading structure...")
                viewModel.loadStructure()
            }
        }

        GeometryReader { geo in
            ZStack(alignment: .topLeading) {

                ContentEditorView(
                    text: $text,
                    isHighlighting: $isHighlighting,
                    selectedColor: $selectedColor,
                    highlightedRanges: $highlightedRanges,
                    isErasing: $isErasing,
                    showWheel: $showWheel,
                    dragLocation: $dragLocation
                ) { pickedColor in
                    selectedColor = pickedColor
                }



            }
        }
        
        
    }
    

    private var saveButton: some View {
        let disabled = thought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        print("[DEBUG] Rendering save button, disabled: \(disabled)")
        return Button(action: submitCapture) {
            Text("Save Thought")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(disabled)
    }
    private func submitCapture() {
        
        let mergedRanges = highlightedRanges
            .sorted { $0.range.location < $1.range.location }
            .reduce(into: [(range: NSRange, color: HighlightColor)]()) { acc, item in
                if let last = acc.last,
                   last.color == item.color,
                   last.range.upperBound == item.range.location {
                    // Extend the previous range
                    let combinedLength = last.range.length + item.range.length
                    let combinedRange = NSRange(location: last.range.location, length: combinedLength)
                    acc[acc.count - 1] = (range: combinedRange, color: last.color)
                } else {
                    acc.append(item)
                }
            }

        let highlightsData = mergedRanges.map { item -> [String: String] in
            let substring = (text as NSString).substring(with: item.range)
            return [
                "text": substring,
                "color": item.color.rawValue
            ]
        }

        var payload: [String: Any] = [
            "content": thought,
            "context": additionalContext,
            "difficulty": selectedDifficulty.rawValue,
            "mastery_time": selectedMasteryTime.rawValue,
            "depth_of_learning": selectedDepth.rawValue,
            "highlights": highlightsData
        ]
        if let set = selectedSet {
            payload["set"] = set.id
        }
        print("[DEBUG] Payload: \(payload)")

        APIService.shared.performRequest(
            endpoint: "quick-capture/quick_capture/",
            method: "POST",
            body: payload
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let resp = String(data: data, encoding: .utf8) ?? ""
                    print("[DEBUG] Request succeeded: \(resp)")
                    responseMessage = resp.isEmpty ? "Saved!" : resp
                    closeAndFlash()
                case .failure(let error):
                    print("[DEBUG] Request error: \(error.localizedDescription)")
                    responseMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    private func closeAndFlash() {
        print("[DEBUG] closeAndFlash: hiding view and showing acknowledgment")
        isExpanded = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showAcknowledgment = true
        }
    }



    // MARK: – 2) The circle + gestures
    private func highlighterButton(in geo: GeometryProxy) -> some View {
        // same center
        let buttonCenter = CGPoint(x: geo.size.width - 60, y: 60)

        return Circle()
          .fill(isHighlighting
                ? Color(selectedColor.uiColor)
                : .white
          )
          .frame(width: 60, height: 60)
          .shadow(radius: 4)
          .position(buttonCenter)
          .onTapGesture {
              if isHighlighting { isHighlighting = false }
          }
          .onLongPressGesture(minimumDuration: 0.4,
                              pressing: { pressing in
                                  withAnimation { showWheel = pressing }
                                  if pressing { dragLocation = buttonCenter }
                              },
                              perform: { }
          )
          .simultaneousGesture(
              DragGesture(minimumDistance: 0)
                .onChanged { drag in dragLocation = drag.location }
                .onEnded { _ in
                    pickColor(at: dragLocation, center: buttonCenter)
                    isHighlighting = true
                    withAnimation { showWheel = false }
                }
          )
    }


    // MARK: – 3) The flywheel overlay
    private var wheelView: some View {
        FlywheelMenu(
            center: wheelCenter,
            dragLocation: dragLocation,
            colors: HighlightColor.allCases
        )
    }

    // MARK: – 4) Angle math with 2 * .pi
    private func pickColor(at point: CGPoint, center: CGPoint) {
        let dx = point.x - center.x
        let dy = point.y - center.y
        let angle = atan2(dy, dx) + .pi/4
        let count = HighlightColor.allCases.count
        let raw = (angle < 0 ? angle + 2 * .pi : angle)  // <-- 2 * .pi, not 2*.pi
        let idx = Int(raw / (2 * .pi) * CGFloat(count)) % count
        selectedColor = HighlightColor.allCases[idx]
    }
    // inside HighlighterView, below your pickColor(_:)
//    private func highlightedSubstrings() -> [String] {
//        highlightedRanges
//          .sorted { $0.range.location < $1.range.location }
//          .compactMap { item in
//            guard let r = Range(item.range, in: text) else { return nil }
//            return String(text[r])
//          }
//    }
    private func highlightedSubstrings() -> [String] {
        // 1. Sort only the NSRanges by their location
        let sortedRanges = highlightedRanges
            .map { $0.range }
            .sorted { $0.location < $1.location }

        // 2. Group them into “runs” of contiguous words
        var groups: [[NSRange]] = []
        for r in sortedRanges {
            if let last = groups.last?.last,
               // if this word starts ≤ 1 char after the last word ended
               r.location <= last.upperBound + 1
            {
                groups[groups.count-1].append(r)
            } else {
                groups.append([r])
            }
        }

        // 3. For each group, grab from the start of the first to the end of the last
        return groups.compactMap { run in
            guard let first = run.first, let last = run.last else { return nil }
            let length = last.upperBound - first.location
            let ns = text as NSString
            return ns.substring(with: NSRange(first.location..<first.location+length))
        }
    }


}
import SwiftUI
import UIKit

// 1) A Shape that draws one slice of a wheel
struct WheelSlice: Shape {
    /// Which slice is this (0…count-1), and how many total?
    let index: Int
    let count: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let startAngle = Angle(degrees: Double(index)   / Double(count) * 360)
        let endAngle   = Angle(degrees: Double(index+1) / Double(count) * 360)

        var p = Path()
        p.move(to: center)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: false)
        p.closeSubpath()
        return p
    }
}


struct FlywheelMenu: View {
    let center: CGPoint
    let dragLocation: CGPoint
    let colors: [HighlighterView.HighlightColor]

    var body: some View {
        ZStack {
            // 1) The rotated wheel (slices + rim)
            ZStack {
                ForEach(Array(colors.enumerated()), id: \.offset) { idx, color in
                    WheelSlice(index: idx, count: colors.count)
                        .fill(Color(color.uiColor))
                }
                Circle()
                    .stroke(Color.gray.opacity(0.6), lineWidth: 4)
            }
            .frame(width: 160, height: 160)
            // rotate slices & rim by –45° (CCW)
            .rotationEffect(.degrees(-45))

            // 2) Pointer at the top (unrotated)
            Triangle()
                .fill(Color.primary)
                .frame(width: 20, height: 10)
                .offset(y: -85)
        }
        .position(center)
        .scaleEffect( showHighlight(at: dragLocation) ? 1.1 : 1.0 )
    }

    private func showHighlight(at point: CGPoint) -> Bool {
        // your existing –π/2 hit-test math stays the same
        let dx = point.x - center.x
        let dy = point.y - center.y
        var a = atan2(dy, dx) - .pi/2
        if a < 0 { a += 2 * .pi }
        let sliceSize = 2 * .pi / CGFloat(colors.count)
        let idx = Int(a / sliceSize) % colors.count
        return idx >= 0 // or compare to a specific slice if you want per-slice highlighting
    }
}

// 3) A little triangle pointer Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

struct CustomTextView: UIViewRepresentable {
    @Binding var selectedColor: HighlighterView.HighlightColor
    @Binding var text: String
    @Binding var isHighlighting: Bool
   // ← new binding

    @Binding var highlightedRanges: [(range: NSRange, color: HighlighterView.HighlightColor)]
    @Binding var isErasing: Bool

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextView

        init(_ parent: CustomTextView) {
            self.parent = parent
        }
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            // 1️⃣ Allow erasing OR highlighting
            guard (parent.isHighlighting || parent.isErasing),
                  let textView = gesture.view as? UITextView else { return }

            // 2️⃣ Figure out which word is under the finger
            let layout = textView.layoutManager
            let container = textView.textContainer
            let loc = gesture.location(in: textView)
            let textOffset = CGPoint(
                x: loc.x - textView.textContainerInset.left,
                y: loc.y - textView.textContainerInset.top
            )
            layout.ensureLayout(for: container)
            let glyphIdx = layout.glyphIndex(for: textOffset, in: container)
            let charIdx = layout.characterIndexForGlyph(at: glyphIdx)
            guard charIdx < textView.textStorage.length else { return }

            let ns = textView.textStorage.string as NSString
            let wordRange = ns.rangeOfWord(at: charIdx)

            // 3️⃣ If we’re highlighting, add
            if parent.isHighlighting {
                // 1) Remove any existing highlights that overlap this word
                parent.highlightedRanges.removeAll { existing in
                    NSIntersectionRange(existing.range, wordRange).length > 0
                }
                // 2) Update the model
                parent.highlightedRanges.append((range: wordRange, color: parent.selectedColor))

                // 3) Update the view’s attributes:
                //    First clear any old backgroundColor on this wordRange,
                //    then set the new one.
                textView.textStorage.removeAttribute(.backgroundColor, range: wordRange)
                textView.textStorage.addAttribute(
                    .backgroundColor,
                    value: parent.selectedColor.uiColor,
                    range: wordRange
                )
            }
            // 4️⃣ If we’re erasing, remove
            else if parent.isErasing {
                let toRemove = parent.highlightedRanges.filter {
                    NSIntersectionRange($0.range, wordRange).length > 0
                }
                guard !toRemove.isEmpty else { return }

                // remove from state
                parent.highlightedRanges.removeAll { item in
                    toRemove.contains { $0.range == item.range }
                }
                // scrub the attributes
                for rem in toRemove {
                    textView.textStorage.removeAttribute(.backgroundColor, range: rem.range)
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
        textView.isEditable = true
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)


        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        pan.cancelsTouchesInView = false
        textView.addGestureRecognizer(pan)

        return textView
    }

//    func updateUIView(_ uiView: UITextView, context: Context) {
//        let attributed = NSMutableAttributedString(string: text)
//        uiView.isSelectable = !isHighlighting
//
//
//        for item in highlightedRanges {
//            let maxRange = NSRange(location: 0, length: attributed.length)
//            if NSLocationInRange(item.range.location, maxRange),
//               item.range.upperBound <= attributed.length {
//                attributed.addAttribute(.backgroundColor, value: item.color.uiColor, range: item.range)
//            }
//        }
//
//        uiView.attributedText = attributed
//    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        // keep textView's base text in sync only if needed
        if uiView.text != text {
            uiView.text = text
        }

        // turn native selection on/off
        uiView.isSelectable = !isHighlighting
        uiView.isEditable   = !isHighlighting    // (optional: hide keyboard)

        // apply / scrub highlight attributes
        uiView.textStorage.removeAttribute(.backgroundColor,
                                           range: NSRange(location: 0,
                                                          length: uiView.textStorage.length))
        for item in highlightedRanges {
            uiView.textStorage.addAttribute(.backgroundColor,
                                            value: item.color.uiColor,
                                            range: item.range)
        }
    }


}

extension NSString {
    func rangeOfWord(at index: Int) -> NSRange {
        var start = index
        var end = index

        while start > 0 {
            let c = character(at: start - 1)
            guard let scalar = UnicodeScalar(c) else { break }
            if !Character(scalar).isLetter { break }
            start -= 1
        }

        while end < length {
            let c = character(at: end)
            guard let scalar = UnicodeScalar(c) else { break }
            if !Character(scalar).isLetter { break }
            end += 1
        }

        return NSRange(location: start, length: end - start)
    }
}


