@MainActor
class SocialViewModel: ObservableObject {
    @Published var friends: [User] = []
    @Published var incomingRequests: [FriendRequest] = []
    @Published var activityFeed: [Activity] = []

    func loadAllSocialData() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.fetchFriends() }
                group.addTask { await self.fetchIncomingRequests() }
                group.addTask { await self.fetchActivityFeed() }
            }
        }
    }

    private func fetchFriends() async {
        do {
            let data = try await APIService.shared.request(endpoint: "social/friends/")
            self.friends = try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("❌ Friends error:", error)
        }
    }

    private func fetchIncomingRequests() async {
        do {
            let data = try await APIService.shared.request(endpoint: "social/friend-requests/incoming/")
            self.incomingRequests = try JSONDecoder().decode([FriendRequest].self, from: data)
        } catch {
            print("❌ Requests error:", error)
        }
    }

    private func fetchActivityFeed() async {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let data = try await APIService.shared.request(endpoint: "social/feed/")
            self.activityFeed = try decoder.decode([Activity].self, from: data)
        } catch {
            print("❌ Feed error:", error)
        }
    }
}
