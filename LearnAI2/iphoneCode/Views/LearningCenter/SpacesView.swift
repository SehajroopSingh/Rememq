import SwiftUI

struct SpacesView: View {
    @StateObject private var viewModel = SpacesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.spaces) { space in
                        NavigationLink(destination: GroupsView(space: space)) {
                            CardView(title: space.name)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Spaces")
            .onAppear {
                viewModel.loadSpaces()
            }
        }
    }
}
