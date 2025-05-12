//
//  IncomingRequestsView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/5/25.
//


import SwiftUI

struct IncomingRequestsView: View {
    @State private var requests: [FriendRequest] = []
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
                ForEach(requests) { request in
                    HStack {
                        Text(request.fromUser.username)
                        Spacer()
                        Button("Accept") {
                            respond(to: request, action: "accept")
                        }
                        .buttonStyle(.borderedProminent)
                        Button("Reject") {
                            respond(to: request, action: "reject")
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
                        let decoded = try JSONDecoder().decode([FriendRequest].self, from: data)
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

    func respond(to request: FriendRequest, action: String){
    let body: [String: Any] = ["request_id": request.id, "action": action]

        // 🔍 Debug logs
        print("📤 Responding to friend request")
        print("📤 Endpoint: social/friend-requests/respond/")
        print("📤 Method: POST")
        print("📤 Body: \(body)")
        print("📤 Access Token: \(APIService.shared.accessToken.prefix(20))...") // partial token

        APIService.shared.performRequest(endpoint: "social/friend-requests/respond/", method: "POST", body: body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let msg = (try? JSONDecoder().decode([String: String].self, from: data))?["detail"] ?? "\(action.capitalized)ed"
                    print("✅ Server response: \(msg)")
                    responseMessage = "✅ \(msg)"
                    fetchRequests()  // refresh list
                case .failure(let error):
                    responseMessage = "❌ Failed to \(action)"
                    print("❌ Response error:", error.localizedDescription)
                }
            }
        }
    }

}
