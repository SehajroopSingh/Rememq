//
//import SwiftUI
//
//
//// MARK: - Shared Spaces View
//struct SharedSpacesView: View {
//    @StateObject private var viewModel = SharedContentViewModel()
//    @State private var showSharedSpaces = false
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                BlobbyBackground()
//                    .ignoresSafeArea()
//
//                VStack(alignment: .leading, spacing: 16) {
//                    // Shared Spaces Dropdown Button
//                    VStack(alignment: .leading, spacing: 8) {
//                        Button(action: {
//                            withAnimation { showSharedSpaces.toggle() }
//                        }) {
//                            HStack {
//                                Text("Shared Spaces")
//                                    .font(.headline)
//                                Spacer()
//                                Image(systemName: showSharedSpaces ? "chevron.up" : "chevron.down")
//                            }
//                            .padding()
//                            .background(.ultraThinMaterial)
//                            .cornerRadius(12)
//                        }
//
//                        if showSharedSpaces {
//                            ForEach(viewModel.sharedSpaces) { space in
//                                NavigationLink(destination: SharedSpaceCardView(space: space)) {
//                                    Text(space.name)
//                                        .padding(.horizontal)
//                                        .padding(.vertical, 8)
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .background(.ultraThinMaterial)
//                                        .cornerRadius(8)
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.top)
//
//                    // Scrollable Buttons to Other Shared Views
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 12) {
//                            NavigationLink(destination: SharedGroupsView(groups: viewModel.sharedGroups)) {
//                                Label("Groups", systemImage: "person.3")
//                                    .padding()
//                                    .background(.ultraThinMaterial)
//                                    .cornerRadius(10)
//                            }
//                            NavigationLink(destination: SharedSetsView(sets: viewModel.sharedSets)) {
//                                Label("Sets", systemImage: "square.stack")
//                                    .padding()
//                                    .background(.ultraThinMaterial)
//                                    .cornerRadius(10)
//                            }
//                            NavigationLink(destination: SharedQuickCapturesView(captures: viewModel.sharedQuickCaptures)) {
//                                Label("Captures", systemImage: "doc.text")
//                                    .padding()
//                                    .background(.ultraThinMaterial)
//                                    .cornerRadius(10)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//
//                    Spacer()
//                }
//            }
//            .navigationTitle("Shared With Me")
//            .navigationBarTitleDisplayMode(.inline)
//            .onAppear { viewModel.fetchSharedContent() }
//        }
//    }
//}
//
import SwiftUI

struct SharedSpacesView: View {
    @EnvironmentObject var socialVM: SocialViewModel
    @StateObject private var viewModel = SharedContentViewModel()
    
    // Toggle the entire “Shared Spaces” list…
    @State private var showSharedSpaces = false
    // …and track which individual space is expanded
    @State private var expandedSpaces: Set<Int> = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                BlobbyBackground().ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: – Shared Spaces Dropdown Button
                    VStack(alignment: .leading, spacing: 8) {
                        Button {
                            withAnimation { showSharedSpaces.toggle() }
                        } label: {
                            HStack {
                                Text("Shared Spaces")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: showSharedSpaces
                                      ? "chevron.up"
                                      : "chevron.down"
                                )
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        }
                        
                        if showSharedSpaces {
                            SharedSpaceDropdownList(spaces: viewModel.sharedSpaces)
                            
                        }
                        
                        // MARK: – Other shared‐content nav buttons
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                NavigationLink(destination: SharedGroupsView(groups: viewModel.sharedGroups)) {
                                    Label("Groups", systemImage: "person.3")
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(10)
                                }
                                NavigationLink(destination: SharedSetsView(sets: viewModel.sharedSets)) {
                                    Label("Sets", systemImage: "square.stack")
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(10)
                                }
                                NavigationLink(destination: SharedQuickCapturesView(captures: viewModel.sharedQuickCaptures)) {
                                    Label("Captures", systemImage: "doc.text")
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                }
                .navigationTitle("Shared With Me")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear { viewModel.fetchSharedContent() }
            }
            .environmentObject(socialVM)
        }
    }
    
    // MARK: - Shared Group Card
    struct SharedGroupCardView: View {
        let group: SharedGroupModel
        @State private var isExpanded = false
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Text(group.name).font(.headline)
                    Spacer()
                    if let by = group.sharedBy {
                        Text(by).font(.caption).foregroundColor(.secondary)
                    }
                }
                .padding().background(.ultraThinMaterial).cornerRadius(12)
                .onTapGesture { withAnimation { isExpanded.toggle() } }
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(group.sets) { set in
                            SharedSetCardView(set: set)
                        }
                    }
                    .padding(.horizontal).transition(.opacity)
                }
            }
        }
    }
    
    // MARK: - Shared Set Card
    struct SharedSetCardView: View {
        let set: SharedSetModel
        @State private var isExpanded = false
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Text(set.title).font(.headline)
                    Spacer()
                    if let by = set.sharedBy {
                        Text(by).font(.caption).foregroundColor(.secondary)
                    }
                }
                .padding().background(.ultraThinMaterial).cornerRadius(8)
                .onTapGesture { withAnimation { isExpanded.toggle() } }
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(set.quickCaptures) { qc in
                            HStack {
                                Text(qc.shortDescription)
                                    .font(.caption)
                                Spacer()
                                if let by = qc.sharedBy {
                                    Text(by)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(6)
                        }
                    }
                    .padding(.leading).transition(.opacity)
                }
            }
        }
    }
    
}
    
    
    import SwiftUI
    
    struct SharedSpaceDropdownList: View {
        let spaces: [SharedSpaceModel]
        @State private var expandedSpaces: Set<Int> = []
        
        var body: some View {
            ForEach(spaces) { space in
                VStack(spacing: 4) {
                    // Space header row
                    HStack {
                        Text(space.name)
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: expandedSpaces.contains(space.id)
                              ? "chevron.up"
                              : "chevron.down"
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .onTapGesture {
                        withAnimation {
                            if expandedSpaces.contains(space.id) {
                                expandedSpaces.remove(space.id)
                            } else {
                                expandedSpaces.insert(space.id)
                            }
                        }
                    }
                    
                    // If expanded, show its groups
                    if expandedSpaces.contains(space.id) {
                        VStack(spacing: 4) {
                            ForEach(space.groups) { group in
                                NavigationLink(destination: SharedSetsView(sets: group.sets)) {
                                    HStack {
                                        Text(group.name)
                                            .font(.caption)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.leading, 16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
