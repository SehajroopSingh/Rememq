//
//  AppConfig.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 2/25/25.
//


class AppConfig {
    // A singleton instance
    static let shared = AppConfig()
    
    // An enum for environment modes
        
    // Additional global flags or settings can go here:
    var isAnalyticsEnabled: Bool = false
    var isLoggingEnabled: Bool = true
    
    // Private init so no other copies of AppConfig can be created
    private init() {}
}
