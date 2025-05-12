//
//  PushNotificationManager.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/9/25.
//


import Foundation
import SwiftUI

enum PushNotificationManager {
    static func sendDeviceTokenToServer(token: String, isActive: Bool, completion: (() -> Void)? = nil) {
        let body: [String: Any] = [
            "device_token": token,
            "is_active": isActive
        ]

        APIService.shared.performRequest(
            endpoint: "notifications/device/",
            method: "POST",
            body: body
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("📲 Device token \(isActive ? "activated" : "deactivated") on server")
                case .failure(let error):
                    print("❌ Failed to update device token: \(error.localizedDescription)")
                }
                completion?()
            }
        }
    }
}
