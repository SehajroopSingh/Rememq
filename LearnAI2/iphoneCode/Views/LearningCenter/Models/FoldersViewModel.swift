//
//  FoldersViewModel.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/16/25.
//
import Foundation


class FoldersViewModel: ObservableObject {
    @Published var folders: [Folder] = []
    
    func loadFolders() {
        APIService.shared.performRequest(endpoint: "organizer/folders/") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode([Folder].self, from: data)
                        self.folders = decoded
                    } catch {
                        print("Decoding Folders error: \(error)")
                    }
                }
            case .failure(let error):
                print("Error loading folders: \(error.localizedDescription)")
            }
        }
    }
}
