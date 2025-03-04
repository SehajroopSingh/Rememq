//
//  SharedContainerManager.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/2/25.
//


import Foundation

class SharedContainerManager{
    static let sharedGroupIdentifier = "group.learnai2"  // Ensure this matches your App Group

    /// Saves text to the shared App Group container
    static func saveText(_ text: String) {
        guard let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: sharedGroupIdentifier) else {
            print("❌ Shared container not found")
            return
        }

        let fileURL = sharedContainer.appendingPathComponent("SharedText.txt")

        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            print("✅ Shared text saved successfully at: \(fileURL.path)")
        } catch {
            print("❌ Error saving shared text: \(error.localizedDescription)")
        }
    }

    /// Loads text from the shared App Group container
    static func loadText() throws -> String {
        guard let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: sharedGroupIdentifier) else {
            throw NSError(domain: "SharedContainer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Shared container not found"])
        }

        let fileURL = sharedContainer.appendingPathComponent("SharedText.txt")

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw NSError(domain: "SharedContainer", code: 2, userInfo: [NSLocalizedDescriptionKey: "No shared text file found"])
        }

        return try String(contentsOf: fileURL, encoding: .utf8)
    }
}
