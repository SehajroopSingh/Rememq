//
//  UserProfile.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/4/25.
//


import Foundation

struct UserProfile: Codable {
    let id: Int
    let username: String
    let email: String
    let quickCaptureCount: Int  // ❌ Swift expects "quickCaptureCount" but API returns "quick_capture_count"
}
