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
import SwiftUI

struct MainContentView: View {
    @State private var selectedTab = 0  // Track which tab is selected
    @State private var showProfileMenu = false  // ✅ Toggle profile menu
    @State private var navigateToProfile = false  // ✅ Navigate to Profile
    @State private var navigateToAdvancedSettings = false  // ✅ Navigate to Advanced Settings

    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedTab) {
                    QuickCaptureView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)
                    SpacesView()  // Replacing MessagesView with new view
                        .tabItem {
                            Label("Quick Captures", systemImage: "doc.text.fill")
                        }
                        .tag(3)
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        .tag(1)

                    NotificationsView()
                        .tabItem {
                            Label("Notifications", systemImage: "bell.fill")
                        }
                        .tag(2)


                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.crop.circle.fill")
                        }
                        .tag(4)
                        .onAppear {
                            showProfileMenu = true  // ✅ Show menu when tab is tapped
                        }
                }

                // ✅ Pop-up menu appears above Profile tab
                if showProfileMenu {
                    VStack {
                        Spacer()
                        ProfilePopupMenu(
                            showProfileMenu: $showProfileMenu,
                            navigateToProfile: $navigateToProfile,
                            navigateToAdvancedSettings: $navigateToAdvancedSettings
                        )
                        .transition(.opacity)  // Smooth fade-in effect
                        .animation(.easeInOut, value: showProfileMenu)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))  // Tap outside to dismiss
                    .onTapGesture {
                        showProfileMenu = false  // ✅ Close menu when tapping outside
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToProfile) {
                ProfileView()
            }
            .navigationDestination(isPresented: $navigateToAdvancedSettings) {
                AdvancedSettingsView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
