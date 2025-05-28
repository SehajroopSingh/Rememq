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
    
    
    let state: QuizState?  // ✅ Add this
    
    let recent_attempts: [QuizAttempt]?
    
    
    
    
    let difficulty: String

    let short_description: String?
    let initial_author: Int?
    let previous_performance: PerformanceData?


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
        case state
        case recent_attempts  // ✅ add this
        
        case difficulty

        
        
        case short_description
        case initial_author
        case previous_performance

        
        
        


        
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

        state = try? container.decode(QuizState.self, forKey: .state)  // ✅ FIXED
        recent_attempts = try? container.decode([QuizAttempt].self, forKey: .recent_attempts)


        // Manually decode `correct_answer` for both true/false and fill-blank cases
        let raw = try? decoder.container(keyedBy: DynamicCodingKeys.self)
        fillBlankAnswer = try? raw?.decode(String.self, forKey: DynamicCodingKeys(stringValue: "correct_answer")!)
        trueFalseAnswer = try? raw?.decode(String.self, forKey: DynamicCodingKeys(stringValue: "correct_answer")!)
        
        short_description = try? container.decode(String.self, forKey: .short_description)
        initial_author = try? container.decode(Int.self, forKey: .initial_author)
        previous_performance = try? container.decode(PerformanceData.self, forKey: .previous_performance)
        difficulty = try container.decode(String.self, forKey: .difficulty)


    }
}

// Helper for decoding unknown/duplicate keys
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    var intValue: Int? { nil }
    init?(intValue: Int) { return nil }
}




struct QuizState: Codable {
    let interval_days: Double
    let easiness_factor: Double
    let repetition: Int
    let total_attempts: Int
    let correct_attempts: Int
    let last_score: Double?
    let next_due: String?  // Or use Date with custom decoder
    let last_reviewed_at: String?
    let mastery_level: Double
}


struct QuizAttempt: Codable, Identifiable {
    var id: UUID { UUID() }  // if no ID from backend
    let attempt_datetime: String
    let was_correct: Bool
    let score: Double
    let response_data: [String: String]?
}



struct PerformanceData: Codable {
    let correct_attempts: Int
    let total_attempts: Int
    let mastery_level: Double
}
