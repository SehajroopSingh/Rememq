import SwiftUI

struct AccountView: View {
    @State private var username: String = "Loading..."
    @State private var email: String = "Loading..."
    @State private var quickCaptureCount: Int = 0
    @State private var isEditing: Bool = false
    @State private var newUsername: String = ""
    @State private var newEmail: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("User Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Form {
                Section(header: Text("Profile Info")) {
                    HStack {
                        Text("Username:")
                        Spacer()
                        if isEditing {
                            TextField("New username", text: $newUsername)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(username)
                                .foregroundColor(.gray)
                        }
                    }

                    HStack {
                        Text("Email:")
                        Spacer()
                        if isEditing {
                            TextField("New email", text: $newEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(email)
                                .foregroundColor(.gray)
                        }
                    }

                    HStack {
                        Text("Quick Captures:")
                        Spacer()
                        Text("\(quickCaptureCount)")
                            .foregroundColor(.gray)
                    }
                }

                if isEditing {
                    Button("Save Changes") {
                        updateProfile()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                } else {
                    Button("Edit Profile") {
                        newUsername = username
                        newEmail = email
                        isEditing = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            .onAppear {
                fetchUserProfile()
            }
        }
        .navigationTitle("Account")
    }

    // ✅ Fetch User Profile from API
    private func fetchUserProfile() {
        APIService.shared.performRequest(endpoint: "user/profile/", method: "GET") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(UserProfile.self, from: data)
                        self.username = response.username
                        self.email = response.email
                        self.quickCaptureCount = response.quickCaptureCount
                    } catch {
                        self.errorMessage = "Failed to parse profile data."
                    }
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    // ✅ Update User Profile via API
    private func updateProfile() {
        let requestBody: [String: Any] = [
            "username": newUsername,
            "email": newEmail
        ]

        APIService.shared.performRequest(endpoint: "user/profile/", method: "PATCH", body: requestBody) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.username = newUsername
                    self.email = newEmail
                    self.isEditing = false
                case .failure(let error):
                    self.errorMessage = "Update failed: \(error.localizedDescription)"
                }
            }
        }
    }
}



// MARK: - Preview
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
