//
//  StructureViewModel.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/30/25.
//


import Combine
import Foundation

class StructureViewModel: ObservableObject {
    @Published var spaces: [Space] = []

    func loadStructure() {
        APIService.shared.performRequest(endpoint: "organizer/structure/") { result in
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
    
    func findSet(by id: Int) -> SetItem? {
        for space in spaces {
            for group in space.groups {
                if let match = group.sets.first(where: { $0.id == id }) {
                    return match
                }
            }
        }
        return nil
    }

    func findGroup(by id: Int) -> Group? {
        for space in spaces {
            if let match = space.groups.first(where: { $0.id == id }) {
                return match
            }
        }
        return nil
    }

    func findSpace(by id: Int) -> Space? {
        return spaces.first(where: { $0.id == id })
    }

}
