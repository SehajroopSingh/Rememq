struct LaunchingRootView: View {
    @State private var isActive = true
    @EnvironmentObject var dashboardViewModel: DashboardViewModel

    var body: some View {
        Group {
            if isActive {
                AnimatedSplashView(isActive: $isActive)
            } else {
                RootView()
                    .environmentObject(dashboardViewModel)
            }
        }
    }
}
