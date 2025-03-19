class GroupsViewModel: ObservableObject {
    @Published var groups: [Group] = []
    
    func loadGroups() {
        APIService.shared.performRequest(endpoint: "groups/") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode([Group].self, from: data)
                        self.groups = decoded
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
