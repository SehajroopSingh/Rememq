import SwiftUI

struct SetsView: View {
    let group: Group
    @StateObject private var viewModel = SetsViewModel()
    @State private var showCreateSetSheet = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                
                // "New Set" card
                Button(action: {
                    showCreateSetSheet = true
                }) {
                    ZStack {
                        Color.purple
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 30))
                            Text("New Set")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                    .aspectRatio(1, contentMode: .fit)
                }

                // Set cards
                ForEach(viewModel.sets.filter { $0.group == group.id }) { set in
                    NavigationLink(destination: QuickCapturesView(set: set)) {
                        CardView(title: set.title)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(group.name)
        .onAppear {
            viewModel.loadSets()
        }
        .sheet(isPresented: $showCreateSetSheet) {
            CreateSetView(group: group)  // Placeholder view below
        }
    }
}
