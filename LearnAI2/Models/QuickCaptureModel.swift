//
//  QuickCapture.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/7/25.
//


import Foundation
import CoreData

// ✅ QuickCapture model compatible with Core Data & API
class QuickCapture: NSManagedObject, Codable, Identifiable {
    @NSManaged var id: Int
    @NSManaged var content: String
    @NSManaged var summary: String
    @NSManaged var category: String?
    @NSManaged var created_at: Date?
    @NSManaged var quizzes: Set<Quiz>  // Relationship with quizzes

    enum CodingKeys: String, CodingKey {
        case id, content, summary, category, created_at, quizzes
    }

    required convenience init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.container.viewContext
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.content = try container.decode(String.self, forKey: .content)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.created_at = try container.decodeIfPresent(Date.self, forKey: .created_at)
        self.quizzes = Set(try container.decode([Quiz].self, forKey: .quizzes))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(summary, forKey: .summary)
        try container.encode(category, forKey: .category)
        try container.encode(created_at, forKey: .created_at)
        try container.encode(Array(quizzes), forKey: .quizzes)
    }
}
