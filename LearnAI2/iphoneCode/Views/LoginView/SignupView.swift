//
//  SignupView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 2/26/25.
//


import SwiftUI

struct SignupView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @AppStorage("accessToken") var accessToken: String = ""
    @AppStorage("refreshToken") var refreshToken: String = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .padding()
                .border(Color.gray)

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .border(Color.gray)

            SecureField("Password", text: $password)
                .padding()
                .border(Color.gray)

            Button("Sign Up") {
                registerUser()
            }
            .padding()

            Text(errorMessage).foregroundColor(.red)
        }
        .padding()
    }
    
    func registerUser() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/accounts/register/") else {
            errorMessage = "Bad URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["username": username, "email": email, "password": password]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            errorMessage = "JSON serialization error"
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "No data or invalid response"
                }
                return
            }

            if httpResponse.statusCode == 201 {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let access = json["access"] as? String,
                       let refresh = json["refresh"] as? String {
                        
                        DispatchQueue.main.async {
                            self.accessToken = access
                            self.refreshToken = refresh
                            self.password = ""
                            self.errorMessage = "User registered successfully!"
                        }
                    } else {
                        DispatchQueue.main.async {
                            errorMessage = "Invalid JSON response."
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        errorMessage = "JSON parse error: \(error.localizedDescription)"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Registration failed (status code: \(httpResponse.statusCode))"
                }
            }
        }.resume()
    }
}

#Preview {
    SignupView()
}
