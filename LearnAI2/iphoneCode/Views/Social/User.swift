//
//  User.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/5/25.
//
import SwiftUI
import Foundation

struct User: Identifiable, Decodable, Hashable {
    let id: Int
    let username: String
    let avatarURL: String?
    let streak: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case avatarURL = "avatar"  // match backend field name
        case streak
    }
}
extension User {
    static let fakeFriends: [User] = [
        User(id: 1, username: "Alice", avatarURL: "", streak: 5),
        User(id: 2, username: "Bob", avatarURL: "", streak: 3),
        User(id: 3, username: "Charlie", avatarURL: "", streak: 0)
    ]
}


struct Activity: Identifiable, Decodable {
    let id = UUID()  // Generate locally since your API doesn’t send an ID
    let username: String
    let content: String
    let timestamp: Date

    enum CodingKeys: String, CodingKey {
        case username, content, timestamp
    }
}
extension Activity {
    static let fakeFeed: [Activity] = [
        Activity(username: "Alice", content: "Completed a quiz on WWII!", timestamp: Date().addingTimeInterval(-60)),
        Activity(username: "Bob", content: "Earned 30 XP from flashcards.", timestamp: Date().addingTimeInterval(-600)),
        Activity(username: "Charlie", content: "Joined ReMEMq! 🎉", timestamp: Date().addingTimeInterval(-3600))
    ]
}





struct FriendRequest: Identifiable, Decodable {
    let id: Int
    let fromUser: UserSummary

    enum CodingKeys: String, CodingKey {
        case id
        case fromUser = "from_user"
    }
}

struct UserSummary: Identifiable, Decodable {
    let id: Int
    let username: String
    let avatar: String?
    let streak: Int?

    enum CodingKeys: String, CodingKey {
        case id, username, avatar, streak
    }
}

