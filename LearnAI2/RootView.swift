
import SwiftUI

struct RootView: View {
    @ObservedObject private var apiService = APIService.shared  // 🔹 Observe logout state

    var isAuthenticated: Bool {
        !apiService.accessToken.isEmpty && !apiService.isLoggedOut
    }
    
    var body: some View {
        if isAuthenticated {
            CustomTabBarExample()
                .onAppear {
                    print("✅ Authenticated. Access Token: \(apiService.accessToken)")
                }
        } else {
            LoginView()
                .onAppear {
                    print("🔴 User is logged out. Showing LoginView.")
                }
        }
    }
}
#Preview {
    RootView()
}
