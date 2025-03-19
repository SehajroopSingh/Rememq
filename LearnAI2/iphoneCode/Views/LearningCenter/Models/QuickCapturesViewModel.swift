import Combine
import Foundation

class QuickCapturesViewModel: ObservableObject {
    @Published var quickCaptures: [QuickCaptureModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    func loadQuickCaptures(for setId: Int) {
        let endpoint = "organizer/sets/\(setId)/quickcaptures/"
        APIService.shared.performRequest(endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                // Print the raw JSON response as a string
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON response: \(jsonString)")
                } else {
                    print("Failed to convert data to string.")
                }
                
                // Attempt to decode the JSON data
                do {
                    let captures = try JSONDecoder().decode([QuickCaptureModel].self, from: data)
                    DispatchQueue.main.async {
                        self?.quickCaptures = captures
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Network request failed: \(error.localizedDescription)")
            }
        }
    }
}
