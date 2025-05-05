//import SwiftUI
//
//struct CreateSpaceView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var spaceName: String = ""
//    @State private var isSubmitting = false
//    @State private var errorMessage: String?
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Space Details")) {
//                    TextField("Space Name", text: $spaceName)
//                }
//
//                Section {
//                    if isSubmitting {
//                        ProgressView()
//                    } else {
//                        Button("Create") {
//                            createSpace()
//                        }
//                        .disabled(spaceName.trimmingCharacters(in: .whitespaces).isEmpty)
//                    }
//                }
//
//                if let errorMessage = errorMessage {
//                    Section {
//                        Text("Error: \(errorMessage)")
//                            .foregroundColor(.red)
//                    }
//                }
//            }
//            .navigationTitle("New Space")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//
//    private func createSpace() {
//        isSubmitting = true
//        errorMessage = nil
//
//        let payload: [String: Any] = ["name": spaceName]
//
//        APIService.shared.performRequest(endpoint: "organizer/spaces/create/", method: "POST", body: payload) { result in
//            DispatchQueue.main.async {
//                isSubmitting = false
//                switch result {
//                case .success(_):
//                    print("✅ Space created!")
//                    dismiss()
//                case .failure(let error):
//                    print("❌ Error creating space: \(error.localizedDescription)")
//                    errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }
//}



import SwiftUI

struct CreateSpaceView: View {
    @Environment(\.dismiss) var dismiss
    @State private var spaceName: String = ""
    @State private var userFacingDescription: String = ""
    @State private var llmDescription: String = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Space Details")) {
                    TextField("Space Name", text: $spaceName)
                    TextField("Description (optional)", text: $userFacingDescription)
                    TextField("LLM Notes (optional)", text: $llmDescription)
                }

                Section {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Button("Create") {
                            createSpace()
                        }
                        .disabled(spaceName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                if let errorMessage = errorMessage {
                    Section {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("New Space")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func createSpace() {
        isSubmitting = true
        errorMessage = nil

        let payload: [String: Any] = [
            "name": spaceName,
            "user_facing_description": userFacingDescription,
            "llm_description": llmDescription
        ]

        APIService.shared.performRequest(endpoint: "organizer/spaces/create/", method: "POST", body: payload) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success:
                    print("✅ Space created!")
                    dismiss()
                case .failure(let error):
                    print("❌ Error creating space: \(error.localizedDescription)")
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
