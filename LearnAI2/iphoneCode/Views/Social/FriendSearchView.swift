

import SwiftUI

struct FriendSearchView: View {
    @State private var isSearching = false
    @State private var usernameToSearch = ""
    @State private var statusMessage: String?
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !isSearching {
                Button(action: { withAnimation { isSearching = true } }) {
                    HStack(spacing: 8) {
                        Image(systemName: "person.badge.plus")
                        Text("Add Friend")
                            .font(.headline)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                .buttonStyle(PlainButtonStyle())
            } else {
                HStack(spacing: 8) {
                    TextField("Username", text: $usernameToSearch)
                        .padding(12)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .font(.body)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)

                    Button(action: sendRequest) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "plus")
                                .font(.headline)
                        }
                    }
                    .disabled(usernameToSearch.isEmpty || isLoading)
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )

                    Button(action: resetSearch) {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))

                if let message = statusMessage {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .onAppear {
            
        }
    }

    private func resetSearch() {
        withAnimation {
            isSearching = false
            usernameToSearch = ""
            statusMessage = nil
        }
    }

    private func sendRequest() {
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
                case .failure:
                    statusMessage = "❌ Request failed."
                }
            }
        }
    }
}

struct FriendSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSearchView()
    }
}
