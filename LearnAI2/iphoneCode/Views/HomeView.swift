//
//  HomeView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 2/28/25.
//


import SwiftUI

// Define the first view
struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
                .padding()
        }
    }
}

// Define the second view
struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .padding()
        }
    }
}

// Define the third view
struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
        }
    }
}

// Define the fourth view
struct NotificationsView: View {
    var body: some View {
        VStack {
            Text("Notifications")
                .font(.largeTitle)
                .padding()
        }
    }
}

// Define the fifth view
struct MessagesView: View {
    var body: some View {
        VStack {
            Text("Messages")
                .font(.largeTitle)
                .padding()
        }
    }
}

// Main tab bar view
struct ContentView1: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }

            NotificationsView()
                .tabItem {
                    Label("Notifications", systemImage: "bell.fill")
                }

            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: "message.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}
