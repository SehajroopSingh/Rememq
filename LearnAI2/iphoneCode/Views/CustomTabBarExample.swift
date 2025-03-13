//
//  CustomTabBarExample.swift
//  YourApp
//
//  Created by YourName on [Date].
//

import SwiftUI

struct CustomTabBarExample: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // 1) The pages you want to tab through
            TabView(selection: $selectedTab) {
                QuickCaptureView()
                    .tag(0)
                
                QuickCapturesListView()
                    .tag(1)
                
                // This could be a placeholder or your target view
                // for the "Plus" action if you prefer an actual screen
                Color.clear
                    .tag(2)
                
                NotificationsView()
                    .tag(3)
                
                ProfileView()
                    .tag(4)
            }
            // Hide default tab bar (iOS 16+)
            .toolbar(.hidden, for: .tabBar)
            
            // 2) A custom "tab bar" at the bottom
            VStack {
                Spacer()
                
                HStack {
                    // MARK: Home
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                                .font(.footnote)
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: QuickCapturesList
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack {
                            Image(systemName: "doc.text.fill")
                            Text("Captures")
                                .font(.footnote)
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: The oversized plus button in the center
                    Button(action: {
                        // Action for "Quick Capture" goes here
                        // e.g., show a sheet or navigate
                        selectedTab = 2
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .offset(y: -20) // Float above bar a bit
                    
                    Spacer()
                    
                    // MARK: Notifications
                    Button(action: {
                        selectedTab = 3
                    }) {
                        VStack {
                            Image(systemName: "bell.fill")
                            Text("Alerts")
                                .font(.footnote)
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: Profile
                    Button(action: {
                        selectedTab = 4
                    }) {
                        VStack {
                            Image(systemName: "person.crop.circle.fill")
                            Text("Profile")
                                .font(.footnote)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                // Background for the custom tab bar
                .background(Color(UIColor.systemGray6))
            }
        }
    }
}

// MARK: - Sample child views
// Replace these with your own views

struct QuickCaptureView: View {
    var body: some View {
        VStack {
            Text("QuickCaptureView")
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow.edgesIgnoringSafeArea(.all))
    }
}

struct QuickCapturesListView: View {
    var body: some View {
        VStack {
            Text("QuickCapturesListView")
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orange.edgesIgnoringSafeArea(.all))
    }
}

struct NotificationsView: View {
    var body: some View {
        VStack {
            Text("NotificationsView")
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green.edgesIgnoringSafeArea(.all))
    }
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("ProfileView")
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purple.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Preview
struct CustomTabBarExample_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarExample()
    }
}
