//
//  LearnAI2App.swift
//  LearnAI2
//
//  Created by Sehaj Singh on 12/16/24.
//

import SwiftUI

@main
struct LearnAI2App: App {
    var body: some Scene {
        WindowGroup {
            RootView() // Now RootView will decide which view to show based on authentication and OS
        }
    }
}
