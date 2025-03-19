struct Space: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Group: Codable, Identifiable {
    let id: Int
    let name: String
    let space: Int  // space id
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
