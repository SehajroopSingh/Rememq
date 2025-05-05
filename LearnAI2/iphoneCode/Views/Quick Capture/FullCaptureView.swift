import SwiftUI

/// A full‑screen sheet for capturing a thought and filing it under
/// an existing **Space → Group → Set** hierarchy pulled from Django.
struct FullCaptureView: View {
    // Presentation bindings
    @Binding var isExpanded: Bool
    @Binding var showAcknowledgment: Bool

    // Text input
    @State private var thought            = ""
    @State private var additionalContext  = ""
    @State private var responseMessage    = ""

    // Remote data
    @State private var spaces: [Space]    = []
    @State private var groups: [Group]    = []
    @State private var sets:   [SetItem]  = []

    // Selections (Optional so Picker can bind)
    @State private var selectedSpace:  Space?
    @State private var selectedGroup:  Group?
    @State private var selectedSet:    SetItem?

    // MARK: ‑ UI
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                pickersSection
                textFieldsSection
                saveButton
                if !responseMessage.isEmpty {
                    Text(responseMessage)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
            }
            .padding()
            .navigationTitle("Expand Your Thought")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isExpanded = false }
                }
            }
            .onAppear(perform: fetchSpaces)
            .onChange(of: selectedSpace)  { newSpace  in handleSpaceChange(newSpace)  }
            .onChange(of: selectedGroup) { newGroup in handleGroupChange(newGroup) }
        }
    }

    // MARK: ‑ Sections
    private var pickersSection: some View {
        SwiftUI.Group {
            // Space Picker
            Picker("Select a Space", selection: $selectedSpace) {
                ForEach(spaces) { space in
                    Text(space.name).tag(Optional(space))
                }
            }

            // Group Picker (enabled after space)
            Picker("Select a Group", selection: $selectedGroup) {
                ForEach(groups) { group in
                    Text(group.name).tag(Optional(group))
                }
            }
            .disabled(selectedSpace == nil)

            // Set Picker (enabled after group)
            Picker("Select a Set", selection: $selectedSet) {
                ForEach(sets) { set in
                    Text(set.title).tag(Optional(set))
                }
            }
            .disabled(selectedGroup == nil)
        }
    }

    private var textFieldsSection: some View {
        SwiftUI.Group {
            TextField("Write your main thought here…", text: $thought)
                .padding()
                .frame(height: 100)
                .background(Color(.systemGray6))
                .cornerRadius(10)

            TextField("Add more context…", text: $additionalContext)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }

    private var saveButton: some View {
        Button(action: submitCapture) {
            Text("Save Thought")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(thought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    // MARK: ‑ Networking Helpers
    private func fetchSpaces() {
        APIService.shared.performRequest(endpoint: "organizer/spaces/") { result in
            DispatchQueue.main.async {
                if case let .success(data) = result {
                    spaces = (try? JSONDecoder().decode([Space].self, from: data)) ?? []
                }
            }
        }
    }

    private func fetchGroups(for spaceID: Int) {
        APIService.shared.performRequest(endpoint: "organizer/groups/") { result in
            DispatchQueue.main.async {
                if case let .success(data) = result {
                    let all = (try? JSONDecoder().decode([Group].self, from: data)) ?? []
                    groups = all.filter { $0.space == spaceID }
                }
            }
        }
    }

    private func fetchSets(for groupID: Int) {
        APIService.shared.performRequest(endpoint: "organizer/sets/") { result in
            DispatchQueue.main.async {
                if case let .success(data) = result {
                    let all = (try? JSONDecoder().decode([SetItem].self, from: data)) ?? []
                    sets = all.filter { $0.group == groupID }
                }
            }
        }
    }

    private func submitCapture() {
        var payload: [String: Any] = [
            "content": thought,
            "context": additionalContext
        ]
        if let set = selectedSet { payload["set"] = set.id }

        APIService.shared.performRequest(
            endpoint: "quick-capture/quick_capture/",
            method: "POST",
            body: payload
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    responseMessage = String(data: data, encoding: .utf8) ?? "Saved!"
                    closeAndFlash()
                case .failure(let error):
                    responseMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: ‑ Selection Handlers
    private func handleSpaceChange(_ space: Space?) {
        groups.removeAll(); sets.removeAll(); selectedGroup = nil; selectedSet = nil
        if let id = space?.id { fetchGroups(for: id) }
    }

    private func handleGroupChange(_ group: Group?) {
        sets.removeAll(); selectedSet = nil
        if let id = group?.id { fetchSets(for: id) }
    }

    private func closeAndFlash() {
        isExpanded = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showAcknowledgment = true
        }
    }
}
