//
//  AppDelegate.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/7/25.
//


import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        requestNotificationPermission()
        return true
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("❌ Push Notification permission denied.")
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("✅ Device Token: \(tokenString)")
        print("App Bundle ID: \(Bundle.main.bundleIdentifier ?? "Unknown")")
        print("Share Extension Access Token:", APIService.shared.accessToken)
        print("Share Extension Refresh Token:", APIService.shared.refreshToken)

    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("❌ Failed to register for push notifications: \(error.localizedDescription)")
    }
    // Called when push notification is received in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("📩 Push notification received in foreground: \(notification)")
        completionHandler([.alert, .sound])
    }

    // Called when user taps notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("📩 Push notification tapped: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("📩 Push notification received in background: \(userInfo)")
        completionHandler(.newData)


    }
    
    
    
}
