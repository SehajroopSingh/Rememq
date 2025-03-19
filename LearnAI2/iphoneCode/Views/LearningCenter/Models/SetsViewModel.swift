//
//  SetsViewModel.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/16/25.
//
import Combine
import Foundation

class SetsViewModel: ObservableObject {
    @Published var sets: [SetItem] = []
    
    func loadSets() {
        APIService.shared.performRequest(endpoint: "organizer/sets/") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode([SetItem].self, from: data)
                        self.sets = decoded
                    } catch {
                        print("Decoding Sets error: \(error)")
                    }
                }
            case .failure(let error):
                print("Error loading sets: \(error.localizedDescription)")
            }
        }
    }
}
