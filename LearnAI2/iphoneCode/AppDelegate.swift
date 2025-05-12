////
////  AppDelegate.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 3/7/25.
////
//
//
//import UIKit
//
//class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        requestNotificationPermission()
//        return true
//    }
//    
//    func requestNotificationPermission() {
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            } else {
//                print("❌ Push Notification permission denied.")
//            }
//        }
//    }
//    
//    func application(
//        _ application: UIApplication,
//        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//    ) {
//        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
//        print("✅ Device Token: \(tokenString)")
//        print("App Bundle ID: \(Bundle.main.bundleIdentifier ?? "Unknown")")
//        print("Share Extension Access Token:", APIService.shared.accessToken)
//        print("Share Extension Refresh Token:", APIService.shared.refreshToken)
//
//    }
//    
//    func application(
//        _ application: UIApplication,
//        didFailToRegisterForRemoteNotificationsWithError error: Error
//    ) {
//        print("❌ Failed to register for push notifications: \(error.localizedDescription)")
//    }
//    // Called when push notification is received in foreground
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("📩 Push notification received in foreground: \(notification)")
//        completionHandler([.alert, .sound])
//    }
//
//    // Called when user taps notification
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("📩 Push notification tapped: \(response.notification.request.content.userInfo)")
//        completionHandler()
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("📩 Push notification received in background: \(userInfo)")
//        completionHandler(.newData)
//
//
//    }
//    
//    func sendDeviceTokenToServer(token: String) {
//        let body = ["device_token": token]
//
//        APIService.shared.performRequest(
//            endpoint: "notifications/register_device/",
//            method: "POST",
//            body: body
//        ) { result in
//            switch result {
//            case .success:
//                print("✅ Device token registered with server")
//            case .failure(let error):
//                print("❌ Failed to register device token: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    
//    
//    
//}
import UIKit
import UserNotifications
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // Shared user preferences between SwiftUI and AppDelegate
    @AppStorage("deviceToken") var storedDeviceToken: String = ""
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Set self as notification delegate and optionally prompt on launch
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // 📩 Called when the system successfully registers the device with APNs
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        storedDeviceToken = tokenString

        if notificationsEnabled {
            PushNotificationManager.sendDeviceTokenToServer(token: tokenString, isActive: true)
        }
    }


    // ❌ Called if APNs registration fails
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("❌ Failed to register for push notifications: \(error.localizedDescription)")
    }

    // 📬 Called when a notification is received in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("📩 Push notification received in foreground: \(notification)")
        // Decide how to present it (banner + sound in this case)
        completionHandler([.alert, .sound])
    }

    // 📲 Called when user taps a notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("📩 Push notification tapped: \(response.notification.request.content.userInfo)")
        completionHandler()
    }

    // 🔄 Called when a background notification is received (silent push)
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print("📩 Push notification received in background: \(userInfo)")
        completionHandler(.newData)
    }

    // 📡 Helper method to send the device token to your backend
    func sendDeviceTokenToServer(token: String, isActive: Bool) {
        let body: [String: Any] = [
            "device_token": token,
            "is_active": isActive
        ]

        APIService.shared.performRequest(
            endpoint: "notifications/device/",
            method: "POST",
            body: body
        ) { result in
            switch result {
            case .success:
                print("✅ Device token \(isActive ? "activated" : "deactivated") on server")
            case .failure(let error):
                print("❌ Failed to update device token: \(error.localizedDescription)")
            }
        }
    }
}
