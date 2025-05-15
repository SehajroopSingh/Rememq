//
//  DashboardData.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/12/25.
//


import Foundation

//struct DashboardData: Codable {
//    var hearts: Int
//    var xp: Int
//    var streak: Int
//    var gems: Int
//    var level: Int?
//    var badges: [String]?
//    var quizzesAttempted: Int?
//    var quizzesCorrect: Int?
//    var dailyGoalProgress: Int?  // 0–100
//    var recentAchievements: [String]?
//    var dailyQuote: String?
//}
//
//struct PinnedItem: Codable, Identifiable {
//    let id: Int
//    let type: String  // "set", "group", "space"
//    let title: String
//}
//
//struct DashboardData: Codable {
//    var hearts: Int
//    var xp: Int
//    var streak: Int
//    var gems: Int
//    var level: Int?
//    var badges: [String]?
//    var quizzesAttempted: Int?
//    var quizzesCorrect: Int?
//    var dailyGoalProgress: Int?
//    var recentAchievements: [String]?
//    var dailyQuote: String?
//    var pinnedItems: [PinnedItem]?  // ✅
//
//    // 👇 Add this to map snake_case → camelCase
//    enum CodingKeys: String, CodingKey {
//        case hearts, xp, streak, gems, level, badges
//        case quizzesAttempted = "quizzes_attempted"
//        case quizzesCorrect = "quizzes_correct"
//        case dailyGoalProgress = "daily_goal_progress"
//        case recentAchievements = "recent_achievements"
//        case dailyQuote = "daily_quote"
//        case pinnedItems = "pinned_items"  // ✅ Fix key mismatch
//    }
//}


struct PinnedItem: Codable, Identifiable {
    let id: Int
    let type: String  // "set", "group", "space"
    let title: String
}

struct QuickCaptureItem: Codable, Identifiable {
    let id: Int
    let shortDescription: String?
    let content: String
    let createdAt: String
    let setId: Int?
    let folderId: Int?
    let classification: String?

    enum CodingKeys: String, CodingKey {
        case id
        case shortDescription = "short_description"
        case content
        case createdAt = "created_at"
        case setId = "set_id"
        case folderId = "folder_id"
        case classification
    }
}

struct DashboardData: Codable {
    var hearts: Int
    var xp: Int
    var streak: Int
    var gems: Int
    var level: Int?
    var badges: [String]?
    var quizzesAttempted: Int?
    var quizzesCorrect: Int?
    var dailyGoalProgress: Int?
    var recentAchievements: [String]?
    var dailyQuote: String?
    var pinnedItems: [PinnedItem]?  // ✅
    var recentQuickCaptures: [QuickCaptureItem]?  // ✅

    enum CodingKeys: String, CodingKey {
        case hearts, xp, streak, gems, level, badges
        case quizzesAttempted = "quizzes_attempted"
        case quizzesCorrect = "quizzes_correct"
        case dailyGoalProgress = "daily_goal_progress"
        case recentAchievements = "recent_achievements"
        case dailyQuote = "daily_quote"
        case pinnedItems = "pinned_items"
        case recentQuickCaptures = "recent_quick_captures"  // ✅ match backend
    }
}
