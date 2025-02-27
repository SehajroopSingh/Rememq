//
//  ServiceLayer.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 2/25/25.
//

import Foundation

enum AppEnvironment {
    case mock
    case production
}

protocol GamificationServiceProtocol {
    func fetchStats(completion: @escaping (GamificationStats) -> Void)
}

class ServiceLayer {
    static var environment: AppEnvironment = .mock

    static var gamificationService: GamificationServiceProtocol {
        switch environment {
        case .mock:
            return MockGamificationService()
        case .production:
            return RealGamificationService() // You’ll implement this
        }
    }
}

#if DEBUG
extension ServiceLayer {
    static var mockGamificationService: MockGamificationService {
        return gamificationService as! MockGamificationService
    }
}

#endif
