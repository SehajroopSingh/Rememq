////import SwiftUI
////
////struct GroupsView: View {
////    let space: Space
////    @StateObject private var viewModel = GroupsViewModel()
////    @State private var showCreateGroupSheet = false
////
////    let columns = [
////        GridItem(.flexible()),
////        GridItem(.flexible())
////    ]
////
////    var body: some View {
////        ScrollView {
////            LazyVGrid(columns: columns, spacing: 16) {
////
////                // "New Group" card
////                Button(action: {
////                    showCreateGroupSheet = true
////                }) {
////                    ZStack {
////                        Color.green
////                            .cornerRadius(10)
////                            .shadow(radius: 5)
////                        VStack {
////                            Image(systemName: "plus.circle.fill")
////                                .font(.system(size: 30))
////                            Text("New Group")
////                                .font(.headline)
////                        }
////                        .foregroundColor(.white)
////                        .padding()
////                    }
////                    .aspectRatio(1, contentMode: .fit)
////                }
////
////                // Group cards
////                ForEach(viewModel.groups.filter { $0.space == space.id }) { group in
////                    NavigationLink(destination: SetsView(group: group)) {
////                        CardView(title: group.name)
////                    }
////                }
////            }
////            .padding()
////        }
////        .navigationTitle(space.name)
////        .onAppear {
////            viewModel.loadGroups(for: space.id)
////        }
////        .sheet(isPresented: $showCreateGroupSheet) {
////            CreateGroupView(space: space)  // Placeholder view, defined below
////        }
////    }
////}
//
//import SwiftUI
//struct GroupsView: View {
//    let space: Space
//    @StateObject private var viewModel = GroupsViewModel()
//    @State private var showCreateGroupSheet = false
//
//    let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//
//    var body: some View {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    
//                    Button(action: {
//                        showCreateGroupSheet = true
//                    }) {
//                        ZStack {
//                            Color.green
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                            VStack {
//                                Image(systemName: "plus.circle.fill")
//                                    .font(.system(size: 30))
//                                Text("New Group")
//                                    .font(.headline)
//                            }
//                            .foregroundColor(.white)
//                            .padding()
//                        }
//                        .aspectRatio(1, contentMode: .fit)
//                    }
//
//                    ForEach(viewModel.groups.filter { $0.space == space.id }) { group in
//                        NavigationLink(destination: SetsView(group: group)) {
//                            CardView(title: group.name)
//                        }
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle(space.name)
//            .onAppear {
//                viewModel.loadGroups(for: space.id)
//            }
//            .sheet(isPresented: $showCreateGroupSheet) {
//                CreateGroupView(space: space)
//            }
//    
//    }
//}

import SwiftUI
struct GroupsView: View {
    let space: Space
    @StateObject private var viewModel = GroupsViewModel()
    @State private var showCreateGroupSheet = false

    private let cols = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: cols, spacing: 16) {

                // “New Group” card
                Button(action: {
                    showCreateGroupSheet = true
                }) {
                    ZStack {
                        Color.purple
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 30))
                            Text("New Group")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                }
                .aspectRatio(1, contentMode: .fit)

                // Existing groups
                ForEach(viewModel.groups.filter { $0.space == space.id }) { group in
                    NavigationLink { SetsView(group: group) } label: {
                        CardView(title: group.name)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(space.name)                  // ← works now
        .sheet(isPresented: $showCreateGroupSheet) {
            CreateGroupView(space: space)
        }
        .onAppear { viewModel.loadGroups(for: space.id) }
    }
}
