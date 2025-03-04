//
//  MockGamificationService.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 2/25/25.
//


import Foundation

class MockGamificationService: GamificationServiceProtocol {
    func fetchStats(completion: @escaping (GamificationStats) -> Void) {
        let fakeData = GamificationStats(points: 1200,
                                         level: 5,
                                         achievements: ["First Login", "Streak 7 Days"])
        completion(fakeData)
    }
}
