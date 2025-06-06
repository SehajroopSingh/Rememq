//import SwiftUI
//import SwiftUI
//#if canImport(UIKit)
///// Helper to resign first-responder from anywhere
//extension View {
//    func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
//                                        to: nil, from: nil, for: nil)
//    }
//}
//#endif
///// A full-screen sheet for capturing a thought and filing it under
///// an existing **Space → Group → Set** hierarchy pulled from Django.
//struct FullCaptureView: View {
//    // Presentation bindings
//    @Binding var isExpanded: Bool
//    @Binding var showAcknowledgment: Bool
//
//    // Text input
//    @State private var thought: String = ""
//    @State private var additionalContext: String = ""
//    @State private var responseMessage: String = ""
//
//    // Structure loader
//    @StateObject private var viewModel = StructureViewModel()
//
//    // Selections (Optional so Picker can bind)
//    @State private var selectedSpace: Space?
//    @State private var selectedGroup: Group?
//    @State private var selectedSet: SetItem?
//
//    // Quiz options
//    enum Difficulty: String, CaseIterable, Identifiable {
//        case easy = "Easy", mediumEasy = "Medium-Easy", medium = "Medium", mediumHard = "Medium-Hard", hard = "Hard"
//        var id: String { rawValue }
//    }
//    enum MasteryTime: String, CaseIterable, Identifiable {
//        case threeDays = "3 days", oneWeek = "1 week", twoWeeks = "2 weeks", threeWeeks = "3 weeks"
//        case oneMonth = "1 month", threeMonths = "3 months", oneYear = "1 year", indefinitely = "Indefinitely"
//        var id: String { rawValue }
//    }
//    enum DepthOfLearning: String, CaseIterable, Identifiable {
//        case normal = "Normal", college = "College", master = "Master", phd = "Phd"
//        var id: String { rawValue }
//    }
//    @State private var selectedDifficulty: Difficulty = .easy
//    @State private var selectedMasteryTime: MasteryTime = .oneMonth
//    @State private var selectedDepth: DepthOfLearning = .normal
//
//    // Highlighter state
//    typealias HighlightColor = HighlighterView.HighlightColor
//    @State private var selectedColor: HighlightColor = .yellow
//    @State private var isHighlighting = false
//    @State private var isErasing = false
//    @State private var showWheel = false
//    @State private var dragLocation: CGPoint = .zero
//    @State private var highlightedRanges: [(range: NSRange, color: HighlightColor)] = []
//
////    var body: some View {
////        NavigationView {
////            ZStack {
////                Color.clear
////                ScrollView {
////                    VStack(spacing: 16) {
////                        pickersSection
////                        optionsSection
////                        textFieldsSection
////                        saveButton
////                        
////                        if !responseMessage.isEmpty {
////                            Text(responseMessage)
////                                .foregroundColor(.gray)
////                                .padding(.top, 8)
////                        }
////                    }
////                    .padding()
////                }
////                // ← Prevent the ScrollView from being pushed up when the keyboard appears:
////                .ignoresSafeArea(.keyboard, edges: .bottom)
////                .navigationTitle("Expand Your Thought")
////                .toolbar {
////                    ToolbarItem(placement: .navigationBarLeading) {
////                        Button("Cancel") {
////                            print("[DEBUG] Cancel tapped, collapsing view")
////                            isExpanded = false
////                        }
////                    }
////                }
////                .onAppear {
////                    print("[DEBUG] FullCaptureView appeared, loading structure…")
////                    viewModel.loadStructure()
////                }
////            }
////        }
////
////    }
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 16) {          // <–– NO ScrollView here
//                // 1️⃣ Static controls that must never move
//                pickersSection
//                optionsSection
//                
//                // 2️⃣ Scrolling text areas that *may* be covered
//                ScrollView {
//                    textFieldsSection          // CustomTextView + “additionalContext”
//                        .padding(.bottom, 8)
//                }
//                .scrollDismissesKeyboard(.interactively)
//                
//                saveButton
//                if !responseMessage.isEmpty {
//                    Text(responseMessage)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//            .ignoresSafeArea(.keyboard, edges: .bottom)   // now works — nothing above is inside a ScrollView
//            .onTapGesture { hideKeyboard() }
//            
//            .navigationTitle("Expand Your Thought")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") { isExpanded = false }
//                }
//                ToolbarItemGroup(placement: .keyboard) {
//                    Spacer()
//                    Button("Done") { hideKeyboard() }
//                }
//            }
//            .onAppear { viewModel.loadStructure() }
//        }
//    }
//    // MARK: - Sections
//    private var pickersSection: some View {
//        VStack(spacing: 12) {
//            if viewModel.spaces.isEmpty {
//                ProgressView("Loading spaces…")
//            } else {
//                Picker("Space", selection: $selectedSpace) {
//                    ForEach(viewModel.spaces) { space in
//                        Text(space.name).tag(Optional(space))
//                    }
//                }
//                .pickerStyle(.menu)
//
//                if let groups = selectedSpace?.groups {
//                    Picker("Group", selection: $selectedGroup) {
//                        ForEach(groups) { group in
//                            Text(group.name).tag(Optional(group))
//                        }
//                    }
//                    .pickerStyle(.menu)
//                } else {
//                    Text("Select a space first").foregroundColor(.secondary)
//                }
//
//                if let sets = selectedGroup?.sets {
//                    Picker("Set", selection: $selectedSet) {
//                        ForEach(sets) { set in
//                            Text(set.title).tag(Optional(set))
//                        }
//                    }
//                    .pickerStyle(.menu)
//                } else if selectedGroup != nil {
//                    Text("Loading sets…").foregroundColor(.secondary)
//                } else {
//                    Text("Select a group first").foregroundColor(.secondary)
//                }
//            }
//        }
//        .onAppear {
//            print(viewModel.spaces.isEmpty ? "[DEBUG] No spaces loaded yet" : "[DEBUG] Loaded \(viewModel.spaces.count) spaces")
//        }
//        .onChange(of: selectedSpace) { newSpace in
//            print("[DEBUG] Selected space: \(newSpace?.name ?? "none")")
//            selectedGroup = nil; selectedSet = nil
//        }
//        .onChange(of: selectedGroup) { newGroup in
//            print("[DEBUG] Selected group: \(newGroup?.name ?? "none")")
//            selectedSet = nil
//        }
//        .onChange(of: selectedSet) { newSet in
//            print("[DEBUG] Selected set: \(newSet?.title ?? "none")")
//        }
//    }
//
//    private var optionsSection: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Picker("Difficulty", selection: $selectedDifficulty) {
//                ForEach(Difficulty.allCases) { option in
//                    Text(option.rawValue).tag(option)
//                }
//            }
//            .pickerStyle(.segmented)
//
//            Picker("Mastery Time", selection: $selectedMasteryTime) {
//                ForEach(MasteryTime.allCases) { option in
//                    Text(option.rawValue).tag(option)
//                }
//            }
//            .pickerStyle(.menu)
//
//            Picker("Depth of Learning", selection: $selectedDepth) {
//                ForEach(DepthOfLearning.allCases) { option in
//                    Text(option.rawValue).tag(option)
//                }
//            }
//            .pickerStyle(.menu)
//        }
//        .onAppear {
//            print("[DEBUG] Options: Difficulty=\(selectedDifficulty.rawValue), Mastery=\(selectedMasteryTime.rawValue), Depth=\(selectedDepth.rawValue)")
//        }
//        .onChange(of: selectedDifficulty) { new in
//            print("[DEBUG] Difficulty changed to: \(new.rawValue)")
//        }
//        .onChange(of: selectedMasteryTime) { new in
//            print("[DEBUG] Mastery time changed to: \(new.rawValue)")
//        }
//        .onChange(of: selectedDepth) { new in
//            print("[DEBUG] Depth changed to: \(new.rawValue)")
//        }
//    }
//
//    private var textFieldsSection: some View {
//        VStack(spacing: 12) {
//            ZStack(alignment: .topTrailing) {
//                CustomTextView(
//                    selectedColor: $selectedColor,
//                    text: $thought,
//                    isHighlighting: $isHighlighting,
//                    highlightedRanges: $highlightedRanges,
//                    isErasing: $isErasing
//                )
//                .frame(height: 250)
//                .padding()
//                .background(.ultraThinMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                )
//                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
//
//                let buttonCenter = CGPoint(x: 44, y: 44)
//                VStack(spacing: 12) {
//                    Circle()
//                        .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
//                        .frame(width: 44, height: 44)
//                        .shadow(radius: 4)
//                        .onTapGesture {
//                            isHighlighting.toggle()
//                            isErasing = false
//                        }
//                        .onLongPressGesture(minimumDuration: 0.4,
//                                            pressing: { pressing in
//                                                withAnimation { showWheel = pressing }
//                                                if pressing { dragLocation = buttonCenter }
//                                            }, perform: {})
//
//                    Button {
//                        isErasing.toggle()
//                        isHighlighting = false
//                        showWheel = false
//                    } label: {
//                        Image(systemName: "eraser.fill")
//                            .foregroundColor(isErasing ? .white : .black)
//                            .padding()
//                            .background(Circle().fill(isErasing ? Color.red : Color.white))
//                            .shadow(radius: 4)
//                    }
//                }
//                .padding(.top, 10)
//                .padding(.trailing, 10)
//
//                if showWheel {
//                    FlywheelMenu(
//                        center: buttonCenter,
//                        dragLocation: dragLocation,
//                        colors: HighlightColor.allCases
//                    )
//                }
//            }
//
//            TextField("Add more context…", text: $additionalContext)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//        }
//    }
//
//    private var saveButton: some View {
//        let disabled = thought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//        print("[DEBUG] Rendering save button, disabled: \(disabled)")
//        return Button(action: submitCapture) {
//            Text("Save Thought")
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//        }
//        .disabled(disabled)
//    }
//
//    private func submitCapture() {
//        var payload: [String: Any] = [
//            "content": thought,
//            "context": additionalContext,
//            "difficulty": selectedDifficulty.rawValue,
//            "mastery_time": selectedMasteryTime.rawValue,
//            "depth_of_learning": selectedDepth.rawValue
//        ]
//        if let set = selectedSet {
//            payload["set"] = set.id
//        }
//        print("[DEBUG] Payload: \(payload)")
//
//        APIService.shared.performRequest(
//            endpoint: "quick-capture/quick_capture/",
//            method: "POST",
//            body: payload
//        ) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    let resp = String(data: data, encoding: .utf8) ?? ""
//                    print("[DEBUG] Request succeeded: \(resp)")
//                    responseMessage = resp.isEmpty ? "Saved!" : resp
//                    closeAndFlash()
//                case .failure(let error):
//                    print("[DEBUG] Request error: \(error.localizedDescription)")
//                    responseMessage = "Error: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//
//    private func closeAndFlash() {
//        print("[DEBUG] closeAndFlash: hiding view and showing acknowledgment")
//        isExpanded = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            showAcknowledgment = true
//        }
//    }
//}
import SwiftUI
#if canImport(UIKit)
/// Helper to resign first-responder from anywhere
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
#endif

struct FullCaptureView: View {
    @Binding var isExpanded: Bool
    @Binding var showAcknowledgment: Bool

    @State private var thought: String = ""
    @State private var additionalContext: String = ""
    @State private var responseMessage: String = ""
    @StateObject private var viewModel = StructureViewModel()

    @State private var selectedSpace: Space?
    @State private var selectedGroup: Group?
    @State private var selectedSet: SetItem?

    enum Difficulty: String, CaseIterable, Identifiable {
        case easy = "Easy", mediumEasy = "Medium-Easy", medium = "Medium",
             mediumHard = "Medium-Hard", hard = "Hard"
        var id: String { rawValue }
    }
    enum MasteryTime: String, CaseIterable, Identifiable {
        case threeDays = "3 days", oneWeek = "1 week", twoWeeks = "2 weeks",
             threeWeeks = "3 weeks", oneMonth = "1 month", threeMonths = "3 months",
             oneYear = "1 year", indefinitely = "Indefinitely"
        var id: String { rawValue }
    }
    enum DepthOfLearning: String, CaseIterable, Identifiable {
        case normal = "Normal", college = "College", master = "Master", phd = "Phd"
        var id: String { rawValue }
    }
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var selectedMasteryTime: MasteryTime = .oneMonth
    @State private var selectedDepth: DepthOfLearning = .normal

    typealias HighlightColor = HighlighterView.HighlightColor
    @State private var selectedColor: HighlightColor = .yellow
    @State private var isHighlighting = false
    @State private var isErasing = false
    @State private var showWheel = false
    @State private var dragLocation: CGPoint = .zero
    @State private var highlightedRanges: [(range: NSRange, color: HighlightColor)] = []

    var body: some View {
            ZStack {
                // This gesture helps override the default SwiftUI behavior.
                Color.clear
                    .contentShape(Rectangle()) // Makes full ZStack tappable
                    .simultaneousGesture(
                        TapGesture().onEnded { hideKeyboard() }
                    )
                
                NavigationView {
                    VStack(spacing: 16) {
                        // Controls that should NOT move
                        pickersSection
                        optionsSection
                        
                        // Text input area – may be covered by keyboard
                        ScrollView {
                            VStack(spacing: 12) {
                                textFieldsSection
                                Spacer().frame(height: 300) // absorbs keyboard space
                            }
                        }
                        .scrollDismissesKeyboard(.interactively)
                        
                        saveButton
                        
                        if !responseMessage.isEmpty {
                            Text(responseMessage)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .navigationTitle("Expand Your Thought")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") { isExpanded = false }
                        }
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") { hideKeyboard() }
                        }
                    }
                    .onAppear { viewModel.loadStructure() }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
            .ignoresSafeArea(.keyboard, edges: .bottom) // MOST IMPORTANT
        }
    

    // MARK: - Sections
    private var pickersSection: some View {
        VStack(spacing: 12) {
            if viewModel.spaces.isEmpty {
                ProgressView("Loading spaces…")
            } else {
                Picker("Space", selection: $selectedSpace) {
                    ForEach(viewModel.spaces) { space in
                        Text(space.name).tag(Optional(space))
                    }
                }
                .pickerStyle(.menu)

                if let groups = selectedSpace?.groups {
                    Picker("Group", selection: $selectedGroup) {
                        ForEach(groups) { group in
                            Text(group.name).tag(Optional(group))
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("Select a space first")
                        .foregroundColor(.secondary)
                }

                if let sets = selectedGroup?.sets {
                    Picker("Set", selection: $selectedSet) {
                        ForEach(sets) { set in
                            Text(set.title).tag(Optional(set))
                        }
                    }
                    .pickerStyle(.menu)
                } else if selectedGroup != nil {
                    Text("Loading sets…").foregroundColor(.secondary)
                } else {
                    Text("Select a group first")
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            print(
                viewModel.spaces.isEmpty
                    ? "[DEBUG] No spaces loaded yet"
                    : "[DEBUG] Loaded \(viewModel.spaces.count) spaces"
            )
        }
        .onChange(of: selectedSpace) { newSpace in
            print("[DEBUG] Selected space: \(newSpace?.name ?? "none")")
            selectedGroup = nil; selectedSet = nil
        }
        .onChange(of: selectedGroup) { newGroup in
            print("[DEBUG] Selected group: \(newGroup?.name ?? "none")")
            selectedSet = nil
        }
        .onChange(of: selectedSet) { newSet in
            print("[DEBUG] Selected set: \(newSet?.title ?? "none")")
        }
    }

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Difficulty", selection: $selectedDifficulty) {
                ForEach(Difficulty.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)

            Picker("Mastery Time", selection: $selectedMasteryTime) {
                ForEach(MasteryTime.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)

            Picker("Depth of Learning", selection: $selectedDepth) {
                ForEach(DepthOfLearning.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
        .onAppear {
            print(
                "[DEBUG] Options: Difficulty=\(selectedDifficulty.rawValue), " +
                "Mastery=\(selectedMasteryTime.rawValue), " +
                "Depth=\(selectedDepth.rawValue)"
            )
        }
        .onChange(of: selectedDifficulty) { new in
            print("[DEBUG] Difficulty changed to: \(new.rawValue)")
        }
        .onChange(of: selectedMasteryTime) { new in
            print("[DEBUG] Mastery time changed to: \(new.rawValue)")
        }
        .onChange(of: selectedDepth) { new in
            print("[DEBUG] Depth changed to: \(new.rawValue)")
        }
    }

    private var textFieldsSection: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                CustomTextView(
                    selectedColor: $selectedColor,
                    text: $thought,
                    isHighlighting: $isHighlighting,
                    highlightedRanges: $highlightedRanges,
                    isErasing: $isErasing
                )
                .frame(height: 250)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)

                let buttonCenter = CGPoint(x: 44, y: 44)
                VStack(spacing: 12) {
                    Circle()
                        .fill(isHighlighting ? Color(selectedColor.uiColor) : .white)
                        .frame(width: 44, height: 44)
                        .shadow(radius: 4)
                        .onTapGesture {
                            isHighlighting.toggle()
                            isErasing = false
                        }
                        .onLongPressGesture(minimumDuration: 0.4,
                                            pressing: { pressing in
                                                withAnimation { showWheel = pressing }
                                                if pressing { dragLocation = buttonCenter }
                                            },
                                            perform: {})

                    Button {
                        isErasing.toggle()
                        isHighlighting = false
                        showWheel = false
                    } label: {
                        Image(systemName: "eraser.fill")
                            .foregroundColor(isErasing ? .white : .black)
                            .padding()
                            .background(
                                Circle()
                                    .fill(isErasing ? Color.red : Color.white)
                            )
                            .shadow(radius: 4)
                    }
                }
                .padding(.top, 10)
                .padding(.trailing, 10)

                if showWheel {
                    FlywheelMenu(
                        center: buttonCenter,
                        dragLocation: dragLocation,
                        colors: HighlightColor.allCases
                    )
                }
            }

            TextField("Add more context…", text: $additionalContext)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }

    private var saveButton: some View {
        let disabled = thought
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty

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
        var payload: [String: Any] = [
            "content": thought,
            "context": additionalContext,
            "difficulty": selectedDifficulty.rawValue,
            "mastery_time": selectedMasteryTime.rawValue,
            "depth_of_learning": selectedDepth.rawValue
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
        isExpanded = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showAcknowledgment = true
        }
    }
}
