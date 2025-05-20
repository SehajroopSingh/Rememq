

import SwiftUI

struct IncomingRequestsView: View {
    @EnvironmentObject var socialVM: SocialViewModel
    @State private var loading = true
    @State private var responseMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Incoming Requests")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)

            if loading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
            } else if socialVM.incomingRequests.isEmpty {
                Text("No pending requests.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
            } else {
                VStack(spacing: 12) {
                    ForEach(socialVM.incomingRequests) { request in
                        HStack {
                            Text(request.fromUser.username)
                                .font(.body)
                                .foregroundColor(.primary)
                            Spacer()
                            Button(action: { respond(to: request, action: "accept") }) {
                                Text("Accept")
                                    .font(.subheadline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                            }
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(
                                Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                            Button(action: { respond(to: request, action: "reject") }) {
                                Text("Reject")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                            }
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(
                                Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                }
            }

            if let msg = responseMessage {
                Text(msg)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .onAppear {
            Task {
                loading = true
                await socialVM.fetchIncomingRequests()
                loading = false
            }
        }

    }



    private func respond(to request: FriendRequest, action: String) {
        let body: [String: Any] = ["request_id": request.id, "action": action]
        print("📤 Responding to friend request: \(action)")

        APIService.shared.performRequest(endpoint: "social/friend-requests/respond/", method: "POST", body: body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let msg = (try? JSONDecoder().decode([String: String].self, from: data))?["detail"]
                        ?? "\(action.capitalized)ed"
                    responseMessage = "✅ \(msg)"
                    Task {
                        await socialVM.fetchIncomingRequests()
                        await socialVM.fetchFriends()

                    }
                case .failure:
                    responseMessage = "❌ Failed to \(action)"
                }
            }
        }
    }
}

struct IncomingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        IncomingRequestsView()
    }
}
