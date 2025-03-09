import SwiftUI
import AuthenticationServices
import SwiftUI
import AuthenticationServices
//
//struct LoginView: View {
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var errorMessage: String = ""
//    @AppStorage("accessToken") var accessToken: String = ""
//    @AppStorage("refreshToken") var refreshToken: String = ""
//
//    @State private var isAuthenticated = false  // ✅ Track login state
//    @State private var navigateToSignup = false // ✅ Track signup navigation
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                TextField("Username", text: $username)
//                    .autocapitalization(.none)
//                    .padding()
//                    .border(Color.gray)
//
//                SecureField("Password", text: $password)
//                    .padding()
//                    .border(Color.gray)
//
//                Button("Login") {
//                    loginUser()
//                }
//                .padding()
//
//                // 🔹 Button to navigate to SignupView
//                Button("Don't have an account? Sign up") {
//                    navigateToSignup = true
//                }
//                .padding()
//                .foregroundColor(.blue)
//
//                // 🔹 Apple Sign-in
//                AppleSignInButton()
//                    .frame(width: 200, height: 50)
//                    .padding()
//
//                Text(errorMessage).foregroundColor(.red)
//            }
//            .padding()
//            
//            // ✅ Modern navigation method for iOS 16+
//            .navigationDestination(isPresented: $navigateToSignup) {
//                SignupView()
//            }
//            .navigationDestination(isPresented: $isAuthenticated) {
//                MainContentView()
//            }
//        }
//    }
//
//    func loginUser() {
//        guard let url = URL(string: "https://1479-58-8-65-88.ngrok-free.app/api/token/") else {
//            errorMessage = "Bad URL"
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: String] = ["username": username, "password": password]
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
//        } catch {
//            errorMessage = "JSON serialization error"
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    errorMessage = "Network error: \(error.localizedDescription)"
//                }
//                return
//            }
//            guard let data = data,
//                  let httpResponse = response as? HTTPURLResponse else {
//                DispatchQueue.main.async {
//                    errorMessage = "No data or invalid response"
//                }
//                return
//            }
//            if httpResponse.statusCode == 200 {
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
//                       let access = json["access"], let refresh = json["refresh"] {
//                        
//                        DispatchQueue.main.async {
//                            self.accessToken = access
//                            self.refreshToken = refresh
//                            self.password = ""
//                            self.errorMessage = ""
//                            self.isAuthenticated = true  // ✅ Navigate to Home after login
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            errorMessage = "Invalid JSON response."
//                        }
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        errorMessage = "JSON parse error: \(error.localizedDescription)"
//                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    errorMessage = "Invalid credentials (status code: \(httpResponse.statusCode))"
//                }
//            }
//        }.resume()
//    }
//}
//
//
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @AppStorage("accessToken") var accessToken: String = ""
    @AppStorage("refreshToken") var refreshToken: String = ""

    @State private var isAuthenticated = false  // ✅ Track login state
    @State private var navigateToSignup = false // ✅ Track signup navigation

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .padding()
                    .border(Color.gray)

                SecureField("Password", text: $password)
                    .padding()
                    .border(Color.gray)

                Button("Login") {
                    loginUser()
                }
                .padding()

                // 🔹 Button to navigate to SignupView
                Button("Don't have an account? Sign up") {
                    navigateToSignup = true
                }
                .padding()
                .foregroundColor(.blue)

                // 🔹 Apple Sign-in
                AppleSignInButton()
                    .frame(width: 200, height: 50)
                    .padding()

                Text(errorMessage).foregroundColor(.red)
            }
            .padding()
            
            // ✅ Modern navigation method for iOS 16+
            .navigationDestination(isPresented: $navigateToSignup) {
                SignupView()
            }
            .navigationDestination(isPresented: $isAuthenticated) {
                MainContentView()
            }
        }
    }

    /// 🔄 **Updated function to use `APIService.shared`**
    func loginUser() {
        let body: [String: String] = ["username": username, "password": password]

        APIService.shared.performRequest(endpoint: "token/", method: "POST", body: body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                           let access = json["access"], let refresh = json["refresh"] {
                            
                            self.accessToken = access
                            self.refreshToken = refresh
                            self.password = ""
                            self.errorMessage = ""
                            self.isAuthenticated = true  // ✅ Navigate to Home after login
                        } else {
                            self.errorMessage = "Invalid JSON response."
                        }
                    } catch {
                        self.errorMessage = "JSON parse error: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            }
        }
    }
}


struct AppleSignInButton: View {
    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [ASAuthorization.Scope.fullName, ASAuthorization.Scope.email]
        } onCompletion: { result in
            switch result {
            case .success(let authResults):
                handleSignInWithApple(authResults)
            case .failure(let error):
                print("Sign in with Apple failed: \(error.localizedDescription)")
            }
        }
        .signInWithAppleButtonStyle(.black)
    }

    func handleSignInWithApple(_ authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("Invalid Apple ID Credential")
            return
        }

        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email

        print("Apple ID User: \(userIdentifier)")
        print("Full Name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
        print("Email: \(email ?? "No email provided")")

        if let identityTokenData = appleIDCredential.identityToken,
           let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
            
            print("Apple Token: \(identityTokenString)")  // ✅ Copy this token for testing
            
            authenticateWithDjango(appleToken: identityTokenString)
        } else {
            print("Failed to retrieve Apple identity token.")
        }
    }

    /// 🔄 **Updated function to use `APIService.shared`**
    func authenticateWithDjango(appleToken: String) {
        let body: [String: String] = ["apple_token": appleToken]

        APIService.shared.performRequest(endpoint: "apple-login/", method: "POST", body: body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("✅ Apple login successful! Received response.")
                    if let rawString = String(data: data, encoding: .utf8) {
                        print("📜 Raw JSON response:\n\(rawString)")
                    }
                case .failure(let error):
                    print("🔴 Apple login failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
