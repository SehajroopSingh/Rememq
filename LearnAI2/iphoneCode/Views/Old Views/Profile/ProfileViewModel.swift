import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchUserProfile() {
        isLoading = true
        errorMessage = nil
        
        APIService.shared.performRequest(endpoint: "accounts/user/profile/") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("🔹 Raw API Response: \(jsonString)")
                        }
                        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                        self?.userProfile = profile
                    } catch {
                        print("❌ Decoding Error: \(error)")
                        self?.errorMessage = "Decoding Error: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }

    }
}
