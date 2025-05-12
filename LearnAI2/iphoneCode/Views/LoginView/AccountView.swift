import SwiftUI
struct AccountView: View {
    @State private var username: String = "Loading..."
    @State private var email: String = "Loading..."
    @State private var isEditing: Bool = false
    @State private var newUsername: String = ""
    @State private var newEmail: String = ""
    @State private var errorMessage: String?
    @State private var timezone: String = "Loading..."
    @State private var newTimezone: String = ""
    let timezones = TimeZone.knownTimeZoneIdentifiers.sorted()



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
                        Text("Timezone:")
                        Spacer()
                        if isEditing {
                            Picker("Select your timezone", selection: $newTimezone) {
                                ForEach(timezones, id: \.self) { tz in
                                    Text(tz).tag(tz)
                                }
                            }
                            .pickerStyle(.menu) // You can also try .wheel or .inline
                        } else {
                            Text(timezone)
                                .foregroundColor(.gray)
                        }
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

//    private func fetchUserProfile() {
//        APIService.shared.performRequest(endpoint: "accounts/user/profile/", method: "GET") { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    do {
//                        let response = try JSONDecoder().decode(UserProfile.self, from: data)
//                        self.username = response.username
//                        self.email = response.email
//                        self.timezone = response.timezone ?? "Not set"
//
//                    } catch {
//                        self.errorMessage = "Failed to parse profile data."
//                    }
//                case .failure(let error):
//                    self.errorMessage = "Error: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
    private func fetchUserProfile() {
        APIService.shared.performRequest(endpoint: "accounts/user/profile/", method: "GET") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(UserProfile.self, from: data)
                        self.username = response.username
                        self.email = response.email
                        self.timezone = response.timezone ?? "UTC"

                        // 👇 Auto-update timezone if needed
                        if self.timezone == "UTC" || self.timezone.isEmpty {
                            let detectedTZ = TimeZone.current.identifier
                            APIService.shared.performRequest(
                                endpoint: "accounts/profile/update/",
                                method: "PATCH",
                                body: ["timezone": detectedTZ]
                            ) { _ in
                                DispatchQueue.main.async {
                                    self.timezone = detectedTZ
                                }
                            }
                        }

                    } catch {
                        self.errorMessage = "Failed to parse profile data."
                    }
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }


    private func updateProfile() {
        let requestBody: [String: Any] = [
            "username": newUsername,
            "email": newEmail,
            "timezone": newTimezone

        ]

        APIService.shared.performRequest(endpoint: "accounts/profile/update/", method: "PATCH", body: requestBody) { result in
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
