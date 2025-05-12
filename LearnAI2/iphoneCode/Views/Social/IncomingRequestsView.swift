import SwiftUI

struct IncomingRequestsView: View {
    @State private var requests: [User] = []
    @State private var loading = true
    @State private var responseMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Incoming Requests")
                .font(.headline)
            
            if loading {
                ProgressView("Loading...")
            } else if requests.isEmpty {
                Text("No pending requests.").foregroundColor(.gray)
            } else {
                ForEach(requests) { user in
                    HStack {
                        Text(user.username)
                        Spacer()
                        Button("Accept") {
                            respond(to: user, action: "accept")
                        }
                        .buttonStyle(.borderedProminent)
                        Button("Reject") {
                            respond(to: user, action: "reject")
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }
            }

            if let msg = responseMessage {
                Text(msg).font(.subheadline).foregroundColor(.gray)
            }
        }
        .padding()
        .onAppear {
            fetchRequests()
        }
    }

    func fetchRequests() {
        loading = true
        APIService.shared.performRequest(endpoint: "social/friend-requests/incoming/") { result in
            DispatchQueue.main.async {
                loading = false
                switch result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode([User].self, from: data)
                        self.requests = decoded
                    } catch {
                        print("❌ Decoding error:", error)
                    }
                case .failure(let error):
                    print("❌ Fetch error:", error)
                }
            }
        }
    }

    func respond(to user: User, action: String) {
        let body = ["request_id": user.id, "action": action]
        APIService.shared.performRequest(endpoint: "social/friend-requests/respond/", method: "POST", body: body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let msg = (try? JSONDecoder().decode([String: String].self, from: data))?["detail"] ?? "\(action.capitalized)ed"
                    responseMessage = "✅ \(msg)"
                    fetchRequests()  // refresh list
                case .failure(let error):
                    responseMessage = "❌ Failed to \(action)"
                    print("❌ Response error:", error)
                }
            }
        }
    }
}
