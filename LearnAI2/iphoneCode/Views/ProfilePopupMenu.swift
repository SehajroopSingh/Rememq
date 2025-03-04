import SwiftUI

struct ProfilePopupMenu: View {
    @Binding var showProfileMenu: Bool  // ✅ Toggle menu visibility
    @Binding var navigateToProfile: Bool  // ✅ Navigate to Profile
    @Binding var navigateToAdvancedSettings: Bool  // ✅ Navigate to Advanced Settings

    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                navigateToProfile = true
                showProfileMenu = false
            }) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            }
            .padding()

            Button(action: {
                navigateToAdvancedSettings = true
                showProfileMenu = false
            }) {
                HStack {
                    Image(systemName: "gearshape.fill")
                    Text("Advanced Settings")
                }
            }
            .padding()

            Divider()

            Button(action: {
                showProfileMenu = false  // Close menu
            }) {
                Text("Cancel")
                    .foregroundColor(.red)
            }
            .padding()
        }
        .padding()
        .frame(width: 220)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
        .shadow(radius: 10)
        .padding(.bottom, 70)  // Move it above the tab bar
    }
}


import SwiftUI

struct AdvancedSettingsView: View {
    var body: some View {
        VStack {
            Text("Advanced Settings")
                .font(.largeTitle)
                .padding()
        }
    }
}
