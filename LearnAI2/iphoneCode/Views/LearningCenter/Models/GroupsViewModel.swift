import Combine
import Foundation

class GroupsViewModel: ObservableObject {
    @Published var groups: [Group] = []
    
    func loadGroups(for spaceID: Int) {
        APIService.shared.performRequest(endpoint: "organizer/groups/") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode([Group].self, from: data)
                        // Filter groups for the given space
                        self.groups = decoded.filter { $0.space == spaceID }
                    } catch {
                        print("Decoding Groups error: \(error)")
                    }
                }
            case .failure(let error):
                print("Error loading groups: \(error.localizedDescription)")
            }
        }
    }

}
