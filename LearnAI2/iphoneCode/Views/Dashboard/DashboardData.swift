//
//  DashboardData.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/12/25.
//


import Foundation

struct DashboardData: Codable {
    var hearts: Int
    var xp: Int
    var streak: Int
    var gems: Int
    var level: Int?
    var badges: [String]?
    var quizzesAttempted: Int?
    var quizzesCorrect: Int?
    var dailyGoalProgress: Int?  // 0–100
    var recentAchievements: [String]?
    var dailyQuote: String?
}
