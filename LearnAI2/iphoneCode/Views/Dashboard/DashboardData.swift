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
struct PinnedItem: Codable, Identifiable {
    let id: Int
    let type: String  // "set", "group", "space"
    let title: String
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

    // 👇 Add this to map snake_case → camelCase
    enum CodingKeys: String, CodingKey {
        case hearts, xp, streak, gems, level, badges
        case quizzesAttempted = "quizzes_attempted"
        case quizzesCorrect = "quizzes_correct"
        case dailyGoalProgress = "daily_goal_progress"
        case recentAchievements = "recent_achievements"
        case dailyQuote = "daily_quote"
        case pinnedItems = "pinned_items"  // ✅ Fix key mismatch
    }
}
