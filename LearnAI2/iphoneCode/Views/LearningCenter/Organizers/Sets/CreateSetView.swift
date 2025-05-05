////
////  CreateSetView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 4/20/25.
////
//
//
//import SwiftUI
//
//struct CreateSetView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var setTitle = ""
//    let group: Group  // to associate set with group
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                TextField("Enter set title", text: $setTitle)
//                    .padding()
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                Button("Create") {
//                    print("Creating set '\(setTitle)' in group \(group.id)")
//                    dismiss()
//                }
//                .padding()
//                .disabled(setTitle.trimmingCharacters(in: .whitespaces).isEmpty)
//            }
//            .padding()
//            .navigationTitle("New Set")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}
import SwiftUI

struct CreateSetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var setTitle = ""
    @State private var description = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?

    let group: Group  // to associate set with group

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Set Details")) {
                    TextField("Set Title", text: $setTitle)
                    TextField("Description (optional)", text: $description)
                }

                Section {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Button("Create") {
                            createSet()
                        }
                        .disabled(setTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                if let error = errorMessage {
                    Section {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("New Set")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func createSet() {
        isSubmitting = true
        errorMessage = nil

        let payload: [String: Any] = [
            "title": setTitle,
            "group": group.id,
            "description": description
        ]

        APIService.shared.performRequest(endpoint: "organizer/sets/create/", method: "POST", body: payload) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success(_):
                    print("✅ Set created successfully")
                    dismiss()
                case .failure(let error):
                    print("❌ Set creation failed: \(error.localizedDescription)")
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
