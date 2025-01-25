//
//  SharedTextModel.swift
//  LearnAI2
//
//  Created by Sehaj Singh on 1/20/25.
//

import Foundation

/// A model representing shared text data.
struct SharedTextModel: Codable {
    // The shared text content
    var text: String

    // Metadata about when the text was shared
    var sharedDate: Date

    // Optional tags or categories for the shared text
    var tags: [String]?

    // MARK: - Initializer
    init(text: String, sharedDate: Date = Date(), tags: [String]? = nil) {
        self.text = text
        self.sharedDate = sharedDate
        self.tags = tags
    }

    // MARK: - Methods

    /// Validates that the text is not empty.
    func isValid() -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Provides a summary of the text (e.g., first 50 characters).
    func summary() -> String {
        return String(text.prefix(50)) + (text.count > 50 ? "..." : "")
    }

    /// Converts the model to a dictionary for storage or networking.
    func toDictionary() -> [String: Any] {
        return [
            "text": text,
            "sharedDate": sharedDate.timeIntervalSince1970,
            "tags": tags ?? []
        ]
    }
}
