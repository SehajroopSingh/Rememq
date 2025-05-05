import SwiftUI

struct CreateSetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var setTitle = ""
    let group: Group  // to associate set with group

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter set title", text: $setTitle)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Create") {
                    print("Creating set '\(setTitle)' in group \(group.id)")
                    dismiss()
                }
                .padding()
                .disabled(setTitle.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
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
}
