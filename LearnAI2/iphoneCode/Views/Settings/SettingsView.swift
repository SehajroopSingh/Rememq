////
////  SettingsView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 5/4/25.
////
//import SwiftUI
//import UserNotifications
//
//struct SettingsView: View {
//    @AppStorage("grayscaleEnabled") private var grayscaleEnabled: Bool = false
//    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
//    @State private var isProcessing = false
//
//    var body: some View {
//        Form {
//            Toggle("Enable Grayscale Mode", isOn: $grayscaleEnabled)
//
//            Toggle("Enable Push Notifications", isOn: $notificationsEnabled)
//                .onChange(of: notificationsEnabled) { newValue in
//                    handleNotificationToggle(enabled: newValue)
//                }
//
//            if isProcessing {
//                ProgressView("Updating...")
//            }
//        }
//        .navigationTitle("Settings")
//    }
//
//    func handleNotificationToggle(enabled: Bool) {
//        isProcessing = true
//
//        if enabled {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//                guard granted else {
//                    DispatchQueue.main.async {
//                        notificationsEnabled = false
//                        isProcessing = false
//                    }
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            }
//        } else {
//            // 🔴 Optionally PATCH to deactivate device token
//            deactivateDeviceTokenOnServer()
//        }
//    }
//
//    func deactivateDeviceTokenOnServer() {
//        // Replace this with your actual logic
//        APIService.shared.performRequest(
//            endpoint: "notifications/deactivate_device/",
//            method: "PATCH",
//            body: ["is_active": false]
//        ) { result in
//            DispatchQueue.main.async {
//                isProcessing = false
//                switch result {
//                case .success:
//                    print("🔕 Device token deactivated")
//                case .failure(let error):
//                    print("❌ Failed to deactivate: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}
import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("grayscaleEnabled") private var grayscaleEnabled: Bool = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("deviceToken") private var storedDeviceToken: String = ""
    @State private var isProcessing = false

    var body: some View {
        Form {
            Toggle("Enable Grayscale Mode", isOn: $grayscaleEnabled)

            Toggle("Enable Push Notifications", isOn: $notificationsEnabled)
                .onChange(of: notificationsEnabled) { newValue in
                    handleNotificationToggle(enabled: newValue)
                }

            if isProcessing {
                ProgressView("Updating...")
            }
        }
        .navigationTitle("Settings")
    }

    func handleNotificationToggle(enabled: Bool) {
        isProcessing = true

        if enabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        UIApplication.shared.registerForRemoteNotifications()
                        // Let AppDelegate handle sending the token
                        isProcessing = false  // ✅ Add this
                    } else {
                        notificationsEnabled = false
                        isProcessing = false
                    }
                }
            }
        } else {
            // ✅ Disabling — call API directly
            updateDeviceTokenOnServer(isActive: false)
        }
    }


    func updateDeviceTokenOnServer(isActive: Bool) {
        guard !storedDeviceToken.isEmpty else {
            print("⚠️ No stored device token to update.")
            isProcessing = false
            return
        }

        PushNotificationManager.sendDeviceTokenToServer(token: storedDeviceToken, isActive: isActive) {
            isProcessing = false
        }
    }

}
