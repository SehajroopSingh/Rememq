struct SharedAccessEntry: Identifiable, Decodable {
    let id = UUID() // temporary, since backend doesn't return one
    let user: User
    let invitedBy: User
    let permissionLevel: String

    enum CodingKeys: String, CodingKey {
        case user
        case invitedBy = "invited_by"
        case permissionLevel = "permission_level"
    }
}