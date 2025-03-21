//import SwiftUI
//
//struct RootView: View {
//    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.learnai2"))
//    var accessToken: String = ""
//    var isAuthenticated: Bool {
//        !accessToken.isEmpty
//    }
//    
//    var body: some View {
//        if isAuthenticated {
//            // If authenticated, show OS-specific home view
//            #if os(macOS)
//            MacHomeView()
//                .onAppear {
//                    // Log user profile details; here we simply print the accessToken.
//                    print("Authenticated on macOS. Access Token: \(accessToken)")
//                    // If you have a user profile object, you could log that instead.
//                }
//            #elseif os(iOS)
//            
////            MainContentView()
//            CustomTabBarExample()
//                .onAppear {
//                    print("Authenticated on iOS. Access Token: \(accessToken)")
//                    // Replace with actual user profile logging if available.
//                }
//            #endif
//        } else {
//            // Otherwise, show the login view
//            LoginView()
//                .onAppear {
//                    print("User not authenticated. Presenting LoginView.")
//                }
//        }
//    }
//}
//
//#Preview {
//    RootView()
//}
//
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