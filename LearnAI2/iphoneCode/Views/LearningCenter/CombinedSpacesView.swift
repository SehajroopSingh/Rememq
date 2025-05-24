// MARK: - Combined Container
struct CombinedSpacesView: View {
    var body: some View {
        TabView {
            SpacesView()
                .tabItem { Label("My Spaces", systemImage: "folder") }
            SharedSpacesView()
                .tabItem { Label("Shared", systemImage: "person.2") }
        }
    }
}