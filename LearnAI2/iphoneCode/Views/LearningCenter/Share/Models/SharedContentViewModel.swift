//
//  SharedContentViewModel.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/19/25.
//


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
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase  // ✅ Add this

                let decoded = try decoder.decode(SharedContentResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.sharedSpaces = decoded.sharedSpaces
                    self.sharedGroups = decoded.sharedGroups
                    self.sharedSets = decoded.sharedSets
                    self.sharedQuickCaptures = decoded.sharedQuickCaptures
                    self.isLoading = false
                    
                    print("[DEBUG] Fetched \(decoded.sharedQuickCaptures.count) captures")
                }
            } catch let decodingError as DecodingError {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(decodingError.localizedDescription)"
                    self.isLoading = false
                    print("[DECODING ERROR]", decodingError)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    print("[NETWORK ERROR]", error)
                }
            }
        }
    }

}
