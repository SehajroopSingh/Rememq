import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var groupName = ""
    let space: Space  // to associate group with space

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter group name", text: $groupName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Create") {
                    print("Creating group '\(groupName)' in space \(space.id)")
                    dismiss()
                }
                .padding()
                .disabled(groupName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
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
}
