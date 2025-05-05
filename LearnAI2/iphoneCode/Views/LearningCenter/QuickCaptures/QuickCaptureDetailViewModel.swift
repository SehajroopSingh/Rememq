//
//  QuickCaptureDetailViewModel.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/21/25.
//


import Foundation
import Combine

class QuickCaptureDetailViewModel: ObservableObject {
    @Published var quizzes: [Quiz] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadQuizzes(for qcID: Int) {
        guard let token = /* pull your auth token */ nil else { return }
        let url = URL(string: "https://your.api.server/api/quickcaptures/\(qcID)/quizzes/")!
        var req = URLRequest(url: url)
        req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: req)
            .map(\.data)
            .decode(type: [Quiz].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { quizzes in
                self.quizzes = quizzes
            }
            .store(in: &cancellables)
    }
}
