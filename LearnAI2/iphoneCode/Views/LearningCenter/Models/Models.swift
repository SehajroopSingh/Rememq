//struct Space:   Codable, Identifiable, Equatable, Hashable {
//    let id: Int
//    let name: String
//}
//
//struct Group:   Codable, Identifiable, Equatable, Hashable {
//    let id: Int
//    let name: String
//    let space: Int
//}
//
//struct SetItem: Codable, Identifiable, Equatable, Hashable {
//    let id: Int
//    let title: String
//    let group: Int
//}
struct SetItem: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let userFacingDescription: String?
    let llmDescription: String?
    let masteryTime: String
    let group: Int
    let isPinned: Bool  // ✅ New

    enum CodingKeys: String, CodingKey {
        case id, title
        case userFacingDescription = "user_facing_description"
        case llmDescription = "llm_description"
        case masteryTime = "mastery_time"
        case group
        case isPinned = "is_pinned"  // ✅ Map JSON key
    }
}

struct Group: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let userFacingDescription: String?
    let llmDescription: String?
    let image: String?
    let space: Int
    let sets: [SetItem]
    let isPinned: Bool  // ✅ New

    enum CodingKeys: String, CodingKey {
        case id, name, image, sets, space
        case userFacingDescription = "user_facing_description"
        case llmDescription = "llm_description"
        case isPinned = "is_pinned"  // ✅ Map JSON key
    }
}

struct Space: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let userFacingDescription: String?
    let llmDescription: String?
    let groups: [Group]
    let isPinned: Bool  // ✅ New
    var isShared: Bool? = false


    enum CodingKeys: String, CodingKey {
        case id, name, groups
        case userFacingDescription = "user_facing_description"
        case llmDescription = "llm_description"
        case isPinned = "is_pinned"  // ✅ Map JSON key
    }
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
    let updatedAt: String?
    let shortDescription: String?
    let classification: String?
    let set: Int?
    let folder: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case context
        case highlightedSections = "highlighted_sections"
        case masteryTime = "mastery_time"
        case depthOfLearning = "depth_of_learning"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case shortDescription = "short_description"
        case classification
        case set
        case folder
    }
}

//
//
//extension Space {
//    init(from shared: SharedSpace) {
//        self.id = shared.id
//        self.name = shared.name
//        self.userFacingDescription = nil
//        self.llmDescription = nil
//        self.groups = shared.groups.map { Group(from: $0) }
//        self.isPinned = false
//        self.isShared = true
//    }
//}
//
//extension Group {
//    init(from shared: SharedGroup) {
//        self.id = shared.id
//        self.name = shared.name
//        self.userFacingDescription = nil
//        self.llmDescription = nil
//        self.image = nil
//        self.space = -999
//        self.sets = shared.sets.map { SetItem(from: $0) }
//        self.isPinned = false
//    }
//}
//
//extension SetItem {
//    init(from shared: SharedSet) {
//        self.id = shared.id
//        self.title = shared.title
//        self.userFacingDescription = nil
//        self.llmDescription = nil
//        self.masteryTime = "1 Month"
//        self.group = -999
//        self.isPinned = false
//    }
//
//    init(title: String, quickCaptures: [SharedQuickCapture]) {
//        self.id = Int.random(in: -9999...(-1000))  // placeholder
//        self.title = title
//        self.userFacingDescription = nil
//        self.llmDescription = nil
//        self.masteryTime = "1 Month"
//        self.group = -999
//        self.isPinned = false
//        // Add `quickCaptures` if your `SetItem` supports them directly
//    }
//}
