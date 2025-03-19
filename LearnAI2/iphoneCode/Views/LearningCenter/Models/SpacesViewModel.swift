import Combine
import SwiftUI

class SpacesViewModel: ObservableObject {
    @Published var spaces: [Space] = []
    
    func loadSpaces() {
        APIService.shared.performRequest(endpoint: "spaces/") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode([Space].self, from: data)
                        self.spaces = decoded
                    } catch {
                        print("Decoding Spaces error: \(error)")
                    }
                }
            case .failure(let error):
                print("Error loading spaces: \(error.localizedDescription)")
            }
        }
    }
}
