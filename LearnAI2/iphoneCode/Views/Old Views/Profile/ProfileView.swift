import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading Profile...")
            } else if let user = viewModel.userProfile {
                VStack(spacing: 10) {
                    Text("Profile").font(.largeTitle).padding()
                    
                    Text("Username: \(user.username)").font(.title2)
                    Text("Email: \(user.email)").font(.title3)
                    //Text("User ID: \(user.id)").font(.footnote)

                    //Text("Quick Captures: \(user.quickCaptureCount)")
                     //   .font(.headline)
                     //   .foregroundColor(.blue)
                }
                .padding()
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }

            Spacer()
        }
        .onAppear {
            viewModel.fetchUserProfile()
        }
    }
}
