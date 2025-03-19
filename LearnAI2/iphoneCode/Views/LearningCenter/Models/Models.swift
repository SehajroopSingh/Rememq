struct Space: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Group: Codable, Identifiable {
    let id: Int
    let name: String
    let space: Int?  // space id
}

struct SetItem: Codable, Identifiable { // "Set" is a reserved word in Swift.
    let id: Int
    let title: String
    let group: Int  // group id
}

struct Folder: Codable, Identifiable {
    let id: Int
    let name: String
    let set: Int  // set id
}


struct QuickCaptureModel: Identifiable, Codable {
    let id: Int
    let content: String
    let context: String?
    let highlightedSections: [String]
    let masteryTime: String
    let depthOfLearning: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case context
        case highlightedSections = "highlighted_sections"
        case masteryTime = "mastery_time"
        case depthOfLearning = "depth_of_learning"
        case createdAt = "created_at"
    }
}
