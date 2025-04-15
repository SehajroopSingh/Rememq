import Foundation

enum QuizType: String, Codable {
    case multipleChoice = "multiple_choice"
    case trueFalse = "true_false"
    case fillBlank = "fill_in_the_blank"  // updated to match backend
    case fillBlankWithOptions = "fill_in_the_blank_with_options"  // updated to match backend
}

struct Quiz: Codable, Identifiable {
    let id: Int
    let quiz_type: QuizType

    // Common
    let question_text: String?
    let explanation: String?

    // Multiple choice
    let choices: [String]?
    let correctAnswerIndex: Int?

    // True/False
    let statement: String?
    let trueFalseAnswer: String?

    // Fill-in-the-blank
    let fillBlankQuestion: String?
    let fillBlankAnswer: String?
    
    // Fill-in-the-blank with options
    let options: [String]?  // ✅ Added explicitly for fillBlankWithOptions

    enum CodingKeys: String, CodingKey {
        case id
        case quiz_type
        case question_text
        case explanation
        case choices
        case correctAnswerIndex = "correct_answer_index"
        case statement
        case fillBlankQuestion = "question"
        case options  // ✅ Map directly

        
        // ⚠️ DO NOT declare `correct_answer` twice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        quiz_type = try container.decode(QuizType.self, forKey: .quiz_type)
        question_text = try? container.decode(String.self, forKey: .question_text)
        explanation = try? container.decode(String.self, forKey: .explanation)
        choices = try? container.decode([String].self, forKey: .choices)
        correctAnswerIndex = try? container.decode(Int.self, forKey: .correctAnswerIndex)
        statement = try? container.decode(String.self, forKey: .statement)
        fillBlankQuestion = try? container.decode(String.self, forKey: .fillBlankQuestion)
        options = try? container.decode([String].self, forKey: .options)  // ✅ New line


        // Manually decode `correct_answer` for both true/false and fill-blank cases
        let raw = try? decoder.container(keyedBy: DynamicCodingKeys.self)
        fillBlankAnswer = try? raw?.decode(String.self, forKey: DynamicCodingKeys(stringValue: "correct_answer")!)
        trueFalseAnswer = try? raw?.decode(String.self, forKey: DynamicCodingKeys(stringValue: "correct_answer")!)
    }
}

// Helper for decoding unknown/duplicate keys
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    var intValue: Int? { nil }
    init?(intValue: Int) { return nil }
}
