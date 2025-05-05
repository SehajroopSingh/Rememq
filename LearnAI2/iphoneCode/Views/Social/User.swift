//
//  User.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/5/25.
//
import SwiftUI
import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let username: String
    let avatarURL: String
    let streak: Int

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case avatarURL = "avatar"  // match backend field name
        case streak
    }
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
