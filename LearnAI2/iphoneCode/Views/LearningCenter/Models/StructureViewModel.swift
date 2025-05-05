import Combine
import Foundation

class StructureViewModel: ObservableObject {
    @Published var spaces: [Space] = []

    func loadStructure() {
        APIService.shared.performRequest(endpoint: "structure/") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode([Space].self, from: data)
                        self.spaces = decoded
                    } catch {
                        print("Decoding nested structure error: \(error)")
                    }
                }
            case .failure(let error):
                print("Error loading structure: \(error.localizedDescription)")
            }
        }
    }
}
