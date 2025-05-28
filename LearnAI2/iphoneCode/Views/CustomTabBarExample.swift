import SwiftUI

class TabSelectionManager: ObservableObject {
    @Published var selectedTab = 0
}

struct CustomTabBarExample: View {
    @StateObject private var tabManager = TabSelectionManager()

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tabManager.selectedTab) {
                NavigationStack { DashboardView() }
                    .tag(0)
                NavigationStack { CombinedSpacesView() }
                    .tag(1)
                NavigationStack { GamificationView() }
                    .tag(2)
                NavigationStack { SocialView() }
                    .tag(3)
            }
            .toolbar(.hidden, for: .tabBar)

            CustomBarContent(selectedTab: $tabManager.selectedTab)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .environmentObject(tabManager)
    }
}

struct CustomBarContent: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            // Dashboard
            Button {
                selectedTab = 0
            } label: {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    .font(.system(size: 24, weight: .semibold))
            }
            .frame(maxWidth: .infinity)

            // Spaces
            Button {
                selectedTab = 1
            } label: {
                Image(systemName: selectedTab == 1 ? "doc.text.fill" : "doc.text")
                    .font(.system(size: 24, weight: .semibold))
            }
            .frame(maxWidth: .infinity)

            // Notifications
            Button {
                selectedTab = 2
            } label: {
                Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                    .font(.system(size: 24, weight: .semibold))
            }
            .frame(maxWidth: .infinity)

            // Social
            Button {
                selectedTab = 3
            } label: {
                Image(systemName: selectedTab == 3 ? "person.2.fill" : "person.2")
                    .font(.system(size: 24, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
struct CustomTabBarExample_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarExample()
    }
}
