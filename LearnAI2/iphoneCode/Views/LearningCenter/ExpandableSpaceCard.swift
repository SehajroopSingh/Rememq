import SwiftUI

struct ExpandableSpaceCard: View {
    let space: Space
    @State private var isExpanded = false
    @StateObject private var groupsViewModel = GroupsViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header button for the space card
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                    if isExpanded {
                        // Load only groups for this space.
                        groupsViewModel.loadGroups(for: space.id)
                    }
                }
            }) {
                HStack {
                    Text(space.name)
                        .font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            // Expanded list of groups for the space
            if isExpanded {
                ForEach(groupsViewModel.groups) { group in
                    // Ensure these groups belong to this space.
                    // Either filter here or have loadGroups(for:) do the filtering.
                    if group.space == space.id {
                        Text(group.name)
                            .padding(.leading, 16)
                            .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
