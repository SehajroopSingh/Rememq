// MARK: - Shared Spaces View
struct SharedSpacesView: View {
    @StateObject private var viewModel = SharedContentViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                BlobbyBackground()
                    .ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.sharedSpaces) { space in
                            SharedSpaceCardView(space: space)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Shared With Me")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { viewModel.fetchSharedContent() }
        }
    }
}