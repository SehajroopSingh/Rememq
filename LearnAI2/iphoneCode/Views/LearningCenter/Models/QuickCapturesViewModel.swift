import Combine
import Foundation

class QuickCapturesViewModel: ObservableObject {
    @Published var quickCaptures: [QuickCaptureModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    func loadQuickCaptures(for setId: Int) {
        let endpoint = "organizer/sets/\(setId)/quickcaptures/"
        APIService.shared.performRequest(endpoint: endpoint)
            .decode(type: [QuickCaptureModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error loading quick captures: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] captures in
                self?.quickCaptures = captures
            })
            .store(in: &cancellables)
    }
}
