struct SharedQuickCapture: Identifiable, Decodable {
    let id: Int
    let content: String
    let context: String?
    let shortDescription: String?
    let sharedBy: String?
    // add other fields as needed
}

struct SharedSet: Identifiable, Decodable {
    let id: Int
    let title: String
    let sharedBy: String?
    let quickCaptures: [SharedQuickCapture]
}

struct SharedGroup: Identifiable, Decodable {
    let id: Int
    let name: String
    let sharedBy: String?
    let sets: [SharedSet]
}

struct SharedSpace: Identifiable, Decodable {
    let id: Int
    let name: String
    let sharedBy: String?
    let groups: [SharedGroup]
}

struct SharedContentResponse: Decodable {
    let sharedSpaces: [SharedSpace]
    let sharedGroups: [SharedGroup]
    let sharedSets: [SharedSet]
    let sharedQuickCaptures: [SharedQuickCapture]
}
