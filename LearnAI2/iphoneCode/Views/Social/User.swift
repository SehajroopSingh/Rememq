struct User: Identifiable, Decodable {
    let id: Int
    let username: String
    let avatarURL: String
    let streak: Int
}

struct Activity: Identifiable, Decodable {
    let id = UUID()  // Temporary, since your backend may not send unique activity IDs
    let username: String
    let content: String
    let timestamp: Date
}
