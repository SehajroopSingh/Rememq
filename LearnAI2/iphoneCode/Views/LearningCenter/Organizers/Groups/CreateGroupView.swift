//////
//////  CreateGroupView.swift
//////  ReMEMq
//////
//////  Created by Sehaj Singh on 4/20/25.
//////
////
////
////import SwiftUI
////
////struct CreateGroupView: View {
////    @Environment(\.dismiss) var dismiss
////    @State private var groupName = ""
////    let space: Space  // to associate group with space
////
////    var body: some View {
////        NavigationView {
////            VStack {
////                TextField("Enter group name", text: $groupName)
////                    .padding()
////                    .textFieldStyle(RoundedBorderTextFieldStyle())
////
////                Button("Create") {
////                    print("Creating group '\(groupName)' in space \(space.id)")
////                    dismiss()
////                }
////                .padding()
////                .disabled(groupName.trimmingCharacters(in: .whitespaces).isEmpty)
////            }
////            .padding()
////            .navigationTitle("New Group")
////            .toolbar {
////                ToolbarItem(placement: .cancellationAction) {
////                    Button("Cancel") {
////                        dismiss()
////                    }
////                }
////            }
////        }
////    }
////}
//import SwiftUI
//
//struct CreateGroupView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var groupName = ""
//    @State private var isSubmitting = false
//    @State private var errorMessage: String?
//
//    let space: Space  // to associate group with space
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Group Details")) {
//                    TextField("Group Name", text: $groupName)
//                }
//
//                Section {
//                    if isSubmitting {
//                        ProgressView()
//                    } else {
//                        Button("Create") {
//                            createGroup()
//                        }
//                        .disabled(groupName.trimmingCharacters(in: .whitespaces).isEmpty)
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
//            .navigationTitle("New Group")
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
//    private func createGroup() {
//        isSubmitting = true
//        errorMessage = nil
//
//        let payload: [String: Any] = [
//            "name": groupName,
//            "space": space.id
//        ]
//
//        APIService.shared.performRequest(endpoint: "organizer/groups/create/", method: "POST", body: payload) { result in
//            DispatchQueue.main.async {
//                isSubmitting = false
//                switch result {
//                case .success(_):
//                    print("✅ Group created successfully")
//                    dismiss()
//                case .failure(let error):
//                    print("❌ Group creation failed: \(error.localizedDescription)")
//                    errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }
//}
import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var groupName = ""
    @State private var userFacingDescription = ""
    @State private var llmDescription = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?

    let space: Space  // To associate group with the correct space

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Details")) {
                    TextField("Group Name", text: $groupName)
                    TextField("Description (optional)", text: $userFacingDescription)
                    TextField("LLM Notes (optional)", text: $llmDescription)
                }

                Section {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Button("Create") {
                            createGroup()
                        }
                        .disabled(groupName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                if let errorMessage = errorMessage {
                    Section {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("New Group")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func createGroup() {
        isSubmitting = true
        errorMessage = nil

        let payload: [String: Any] = [
            "name": groupName,
            "space": space.id,
            "user_facing_description": userFacingDescription,
            "llm_description": llmDescription
        ]

        APIService.shared.performRequest(endpoint: "organizer/groups/create/", method: "POST", body: payload) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success:
                    print("✅ Group created successfully")
                    dismiss()
                case .failure(let error):
                    print("❌ Group creation failed: \(error.localizedDescription)")
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
