import SwiftUI

struct CreateSpaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var spaceName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Space Details")) {
                    TextField("Space Name", text: $spaceName)
                }
                
                Section {
                    Button("Create") {
                        // Add logic to create the space
                        print("Creating space: \(spaceName)")
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(spaceName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("New Space")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
