struct GroupsView: View {
    let space: Space
    @StateObject private var viewModel = GroupsViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.groups.filter { $0.space == space.id }) { group in
                    NavigationLink(destination: SetsView(group: group)) {
                        CardView(title: group.name)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(space.name)
        .onAppear {
            viewModel.loadGroups()
        }
    }
}
