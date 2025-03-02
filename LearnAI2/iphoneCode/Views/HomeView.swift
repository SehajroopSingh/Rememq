import SwiftUI

// Define the first view
struct HomeView: View {
    // State variable for showing the alert
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                self.showAlert = true
            }) {
                Label("Show Alert", systemImage: "bell.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Alert"),
                    message: Text("This is an alert message!"),
                    dismissButton: .default(Text("OK"))
                )
            }
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
