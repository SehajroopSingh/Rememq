//
//  FullCaptureView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/20/25.
//


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

//    // Remote data
//    @State private var spaces: [Space]    = []
//    @State private var groups: [Group]    = []
//    @State private var sets:   [SetItem]  = []
    @StateObject private var viewModel = StructureViewModel()


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
            .onAppear {
                viewModel.loadStructure()
            }
            .onChange(of: selectedSpace) { _ in
                selectedGroup = nil
                selectedSet = nil
            }
            .onChange(of: selectedGroup) { _ in
                selectedSet = nil
            }

        }
    }

    // MARK: ‑ Sections
    private var pickersSection: some View {
        // --- inside pickersSection ---
        SwiftUI.Group {
            if viewModel.spaces.isEmpty {
                ProgressView("Loading spaces…")
            } else {
                // Space Picker
                Picker("Space", selection: $selectedSpace) {
                    ForEach(viewModel.spaces) { space in
                        Text(space.name).tag(Optional(space))
                    }
                }
                .pickerStyle(.menu)

                // Group Picker
                if let groups = selectedSpace?.groups {
                    Picker("Group", selection: $selectedGroup) {
                        ForEach(groups) { group in
                            Text(group.name).tag(Optional(group))
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("Select a space first").foregroundColor(.secondary)
                }

                // Set Picker
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
                    Text("Select a group first").foregroundColor(.secondary)
                }
            }

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


    private func submitCapture() {
        var payload: [String: Any] = [
            "content": thought,
            "context": additionalContext
        ]
        if let set = selectedSet { payload["set"] = set.id }
        
        print("🚀 Sending payload:", payload)

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



    private func closeAndFlash() {
        isExpanded = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showAcknowledgment = true
        }
    }
}


