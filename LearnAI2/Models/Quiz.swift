////
////  Quiz.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 3/7/25.
////
//
//
import Foundation
import CoreData
//
//// ✅ Quiz model compatible with Core Data & API
//class Quiz: NSManagedObject, Codable, Identifiable {
//    @NSManaged var id: Int
//    @NSManaged var question: String
//    @NSManaged var choices: [String]?
//    @NSManaged var correct_answer: String
//    @NSManaged var quiz_type: String
//    @NSManaged var attempts: Int
//    @NSManaged var correctAttempts: Int
//    @NSManaged var lastAttemptedAt: Date?
//
//    enum CodingKeys: String, CodingKey {
//        case id, question, choices, correct_answer, quiz_type, attempts, correctAttempts, lastAttemptedAt
//    }
//
//    required convenience init(from decoder: Decoder) throws {
//        let context = PersistenceController.shared.container.viewContext
//        self.init(context: context)
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(Int.self, forKey: .id)
//        self.question = try container.decode(String.self, forKey: .question)
//        self.choices = try container.decodeIfPresent([String].self, forKey: .choices)
//        self.correct_answer = try container.decode(String.self, forKey: .correct_answer)
//        self.quiz_type = try container.decode(String.self, forKey: .quiz_type)
//        self.attempts = try container.decodeIfPresent(Int.self, forKey: .attempts) ?? 0
//        self.correctAttempts = try container.decodeIfPresent(Int.self, forKey: .correctAttempts) ?? 0
//        self.lastAttemptedAt = try container.decodeIfPresent(Date.self, forKey: .lastAttemptedAt)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(question, forKey: .question)
//        try container.encode(choices, forKey: .choices)
//        try container.encode(correct_answer, forKey: .correct_answer)
//        try container.encode(quiz_type, forKey: .quiz_type)
//        try container.encode(attempts, forKey: .attempts)
//        try container.encode(correctAttempts, forKey: .correctAttempts)
//        try container.encode(lastAttemptedAt, forKey: .lastAttemptedAt)
//    }
//}




struct Quiz: Identifiable, Codable {
    let id: Int
    let question: String
    let choices: [String]?
    let correct_answer: String  // ✅ Use this name
    let quiz_type: String       // ✅ Matches API response

    enum CodingKeys: String, CodingKey {
        case id
        case question
        case choices
        case correct_answer = "correct_answer"  // ✅ Matches JSON key from API
        case quiz_type = "quiz_type"            // ✅ Matches JSON key from API
    }
}
