
import SwiftUI

struct RootView: View {
    @ObservedObject private var apiService = APIService.shared  // 🔹 Observe logout state
    @AppStorage("grayscaleEnabled") private var grayscaleEnabled: Bool = false

    var isAuthenticated: Bool {
        !apiService.accessToken.isEmpty && !apiService.isLoggedOut
    }
    
    var body: some View {
        if isAuthenticated {
            CustomTabBarExample()
                .grayscale(grayscaleEnabled ? 1.0 : 0.0)  // 🔁 Re-apply this here

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


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
