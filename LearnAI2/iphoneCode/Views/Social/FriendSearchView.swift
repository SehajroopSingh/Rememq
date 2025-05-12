import SwiftUI

struct FriendSearchView: View {
    @State private var usernameToSearch = ""
    @State private var statusMessage: String?
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Send Friend Request")
                .font(.headline)

            TextField("Enter username", text: $usernameToSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            Button(action: sendRequest) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Send Request")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(usernameToSearch.isEmpty || isLoading)

            if let statusMessage = statusMessage {
                Text(statusMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    func sendRequest() {
        guard !usernameToSearch.isEmpty else { return }
        isLoading = true
        statusMessage = nil

        let body = ["to_username": usernameToSearch]

        APIService.shared.performRequest(endpoint: "social/friend-requests/send/", method: "POST", body: body) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let data):
                    if let response = try? JSONDecoder().decode([String: String].self, from: data),
                       let detail = response["detail"] {
                        statusMessage = "✅ \(detail)"
                    } else {
                        statusMessage = "✅ Request sent."
                    }
                case .failure(let error):
                    if let errorData = (error as? URLError)?.userInfo[NSLocalizedDescriptionKey] as? String {
                        statusMessage = "❌ \(errorData)"
                    } else {
                        statusMessage = "❌ Request failed."
                    }
                }
            }
        }
    }
}
