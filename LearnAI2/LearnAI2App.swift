//
//  LearnAI2App.swift
//  LearnAI2
//
//  Created by Sehaj Singh on 12/16/24.
//

import SwiftUI

@main
struct LearnAI2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate  // Add this line
    @AppStorage("grayscaleEnabled") private var grayscaleEnabled: Bool = false  // ✅ Add this line

    var body: some Scene {
        WindowGroup {
            RootView() // Now RootView will decide which view to show based on authentication and OS
                .grayscale(grayscaleEnabled ? 1.0 : 0.0)  // ✅ Apply grayscale globally

        }
    }
}
 
