import SwiftUI

class SharedContentViewModel: ObservableObject {
    @Published var sharedSpaces: [SharedSpace] = []
    @Published var sharedGroups: [SharedGroup] = []
    @Published var sharedSets: [SharedSet] = []
    @Published var sharedQuickCaptures: [SharedQuickCapture] = []
    @Published var isLoading = true
    @Published var errorMessage: String?

    func fetchSharedContent() {
        Task {
            do {
                let data = try await APIService.shared.request(endpoint: "organizer/nested_shared/")
                let decoded = try JSONDecoder().decode(SharedContentResponse.self, from: data)
                DispatchQueue.main.async {
                    self.sharedSpaces = decoded.sharedSpaces
                    self.sharedGroups = decoded.sharedGroups
                    self.sharedSets = decoded.sharedSets
                    self.sharedQuickCaptures = decoded.sharedQuickCaptures
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
