//import SwiftUI
//
//class SharedTextViewModel: ObservableObject {
//    @Published var sharedText: String = ""
//
//    func loadSharedText() {
//        do {
//            let text = try SharedContainerManager.loadText()
//            DispatchQueue.main.async {
//                self.sharedText = text
//            }
//            print("✅ Successfully loaded shared text: \(text)")
//        } catch {
//            print("❌ Failed to load shared text: \(error.localizedDescription)")
//        }
//    }
//}
////
////class UserProfileViewModel: ObservableObject {
////    @Published var username: String = ""
////    @Published var email: String = ""
////    @Published var errorMessage: String? = nil
////    
////    @AppStorage("accessToken") private var accessToken: String = ""
////
////    func fetchUserProfile() {
////        guard let url = URL(string: "http://127.0.0.1:8000/api/accounts/user/profile/") else {
////            DispatchQueue.main.async {
////                self.errorMessage = "Invalid URL"
////            }
////            return
////        }
////
////        var request = URLRequest(url: url)
////        request.httpMethod = "GET"
////        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
////
////        // ✅ Attach access token for authentication
////        if !accessToken.isEmpty {
////            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
////        } else {
////            DispatchQueue.main.async {
////                self.errorMessage = "No access token available. Please log in."
////            }
////            return
////        }
////
////        URLSession.shared.dataTask(with: request) { data, response, error in
////            if let error = error {
////                DispatchQueue.main.async {
////                    self.errorMessage = "Network error: \(error.localizedDescription)"
////                }
////                return
////            }
////            
////            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
////                DispatchQueue.main.async {
////                    self.errorMessage = "Invalid response from server"
////                }
////                return
////            }
////
////            if httpResponse.statusCode == 200 {
////                do {
////                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
////                        DispatchQueue.main.async {
////                            self.username = json["username"] as? String ?? "Unknown"
////                            self.email = json["email"] as? String ?? "Unknown"
////                        }
////                    }
////                } catch {
////                    DispatchQueue.main.async {
////                        self.errorMessage = "Failed to parse user data"
////                    }
////                }
////            } else {
////                DispatchQueue.main.async {
////                    self.errorMessage = "Failed to fetch user data (status code: \(httpResponse.statusCode))"
////                }
////            }
////        }.resume()
////    }
////}
//class UserProfileViewModel: ObservableObject {
//    @Published var username: String = ""
//    @Published var email: String = ""
//    @Published var errorMessage: String? = nil
//
//    func fetchUserProfile() {
//        APIService.shared.performRequest(endpoint: "accounts/user/profile/") { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    do {
//                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                            self.username = json["username"] as? String ?? "Unknown"
//                            self.email = json["email"] as? String ?? "Unknown"
//                        }
//                    } catch {
//                        self.errorMessage = "Failed to parse user data"
//                    }
//                case .failure:
//                    self.errorMessage = "Failed to fetch user data"
//                }
//            }
//        }
//    }
//}
//struct iPhoneHomeView: View {
//    @StateObject var sharedTextViewModel = SharedTextViewModel()
//    @StateObject var userProfileViewModel = UserProfileViewModel()
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                // ✅ Display User Profile Info
//                Text("Welcome, \(userProfileViewModel.username)")
//                    .font(.title)
//                    .bold()
//                Text("Email: \(userProfileViewModel.email)")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//
//                // Show any errors
//                if let error = userProfileViewModel.errorMessage {
//                    Text(error)
//                        .foregroundColor(.red)
//                }
//
//                // 🔹 Shared Text Display
//                Text("Shared Text:")
//                    .font(.headline)
//                Text(sharedTextViewModel.sharedText.isEmpty ? "No shared text found" : sharedTextViewModel.sharedText)
//                    .padding()
//                    .multilineTextAlignment(.center)
//
//                Button("Reload Shared Text") {
//                    sharedTextViewModel.loadSharedText()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//                // 🔹 Navigation to Other Views
//                NavigationLink(destination: DetailView()) {
//                    Text("Go to Test Page")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//
//                NavigationLink(destination: QuickCaptureView()) {
//                    Text("Go to Quick Capture Page")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//            }
//            .padding()
//            .onAppear {
//                sharedTextViewModel.loadSharedText()
//                userProfileViewModel.fetchUserProfile()  // ✅ Fetch user data on load
//            }
//            .navigationTitle("Home")
//        }
//    }
//}
//
//
//#Preview {
//    iPhoneHomeView()
//}
