//////
//////  SpacesView.swift
//////  ReMEMq
//////
//////  Created by Sehaj Singh on 3/16/25.
//////
////
////
////import SwiftUI
////
////struct SpacesView: View {
////    @StateObject private var viewModel = SpacesViewModel()
////    
////    var body: some View {
////        NavigationView {
////            ScrollView {
////                LazyVStack(spacing: 16) {
////                    ForEach(viewModel.spaces) { space in
//////                        NavigationLink(destination: GroupsView(space: space)) {
//////                            CardView(title: space.name)
//////                        }
//////                    }
//////                }
//////                .padding()
//////            }
//////            .navigationTitle("Spaces")
//////            .onAppear {
//////                viewModel.loadSpaces()
//////            }
//////        }
//////    }
//////}
////import SwiftUI
////struct SpacesView: View {
////    @StateObject private var viewModel = SpacesViewModel()
////    @State private var showCreateSheet = false  // optional if using sheet
////    
////    let columns = [
////        GridItem(.flexible()),
////        GridItem(.flexible())
////    ]
////    
////    var body: some View {
////        NavigationView {
////            ScrollView {
////                LazyVGrid(columns: columns, spacing: 16) {
////                    
////                    // Add "New Space" button card
////                    Button(action: {
////                        showCreateSheet = true
////                    }) {
////                        ZStack {
////                            Color.blue
////                                .cornerRadius(10)
////                                .shadow(radius: 5)
////                            
////                            VStack {
////                                Image(systemName: "plus.circle.fill")
////                                    .font(.system(size: 30))
////                                Text("New Space")
////                                    .font(.headline)
////                            }
////                            .foregroundColor(.white)
////                            .padding()
////                        }
////                        .aspectRatio(1, contentMode: .fit)
////                    }
////
////                    // Regular space cards
////                    ForEach(viewModel.spaces) { space in
////                        NavigationLink(destination: GroupsView(space: space)) {
////                            CardView(title: space.name)
////                        }
////                    }
////                }
////                .padding()
////            }
////            .navigationTitle("Spaces")
////            .onAppear {
////                viewModel.loadSpaces()
////            }
////            .sheet(isPresented: $showCreateSheet) {
////                CreateSpaceView()  // Replace with your actual view
////            }
////        }
////    }
////}
////
//import SwiftUI
//struct SpacesView: View {
//    @StateObject private var viewModel = SpacesViewModel()
//    @State private var showCreateSheet = false       // ← keeps your sheet
//
//    private let cols = [GridItem(.flexible()), GridItem(.flexible())]
//
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: cols, spacing: 16) {
//                
//                // ✅ ➊  “New Space” card (unchanged)
//                Button {
//                    showCreateSheet = true
//                } label: {
//                    ZStack {
//                        Color.blue
//                            .cornerRadius(10)
//                            .shadow(radius: 5)
//                        VStack {
//                            Image(systemName: "plus.circle.fill")
//                                .font(.system(size: 30))
//                            Text("New Space")
//                                .font(.headline)
//                        }
//                        .foregroundColor(.white)
//                        .padding()
//                    }
//                    .aspectRatio(1, contentMode: .fit)
//                }
//
//                // ✅ ➋  Existing spaces
//                ForEach(viewModel.spaces) { space in
//                    NavigationLink {
//                        GroupsView(space: space)          // pushes to Groups
//                    } label: {
//                        CardView(title: space.name)
//                    }
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Spaces")
//        .sheet(isPresented: $showCreateSheet) {
//            CreateSpaceView()                           // your add-space sheet
//        }
//        .onAppear { viewModel.loadSpaces() }
//    }
//}

//import SwiftUI
//struct SpacesView: View {
//    @StateObject private var viewModel = StructureViewModel()
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(viewModel.spaces) { space in
//                    Section(header: Text(space.name)) {
//                        if let desc = space.userFacingDescription {
//                            Text(desc).font(.caption).foregroundColor(.gray)
//                        }
//                        ForEach(space.groups) { group in
//                            NavigationLink(destination: SetsView(group: group)) {
//                                NavigationLink(destination: SetsView(group: group)) {
//                                    GroupCard(group: group)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("My Spaces")
//            .onAppear {
//                viewModel.loadStructure()
//            }
//        }
//    }
//}
//


import SwiftUI


import SwiftUI

struct SpacesView: View {
    @StateObject private var viewModel = StructureViewModel()
    @State private var showCreateSpaceSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.spaces) { space in
                        SpaceCardView(space: space)
                    }
                }
                .padding(.top, -30)
                .padding(.horizontal)            }.safeAreaInset(edge: .top) {
                    Color.clear.frame(height: -8) // reduces top space cleanly
                }
            .navigationTitle("My Spaces").navigationBarTitleDisplayMode(.inline)  // 👈 Add this line

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateSpaceSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Create New Space")
                }
            }
            .sheet(isPresented: $showCreateSpaceSheet, onDismiss: {
                viewModel.loadStructure() // Reload after adding a space
            }) {
                CreateSpaceView()
            }
            .onAppear {
                viewModel.loadStructure()
            }
        }
    }
}
import SwiftUI

struct SpaceCardView: View {
    let space: Space
    @State private var userFacingDescription: String
    @State private var showCreateGroupSheet = false
    @State private var isExpanded = false  // 👈 controls dropdown state

    init(space: Space) {
        self.space = space
        self._userFacingDescription = State(initialValue: space.userFacingDescription ?? "")
    }

    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                Divider().padding(.bottom, 4)

                // Groups section
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(spacing: 8) {
                            ForEach(space.groups) { group in
                                NavigationLink(destination: SetsView(group: group)) {
                                    HStack {
                                        Text(group.name)
                                            .font(.body)
                                        Spacer()
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(6)
                                }
                            }

                            Button(action: {
                                showCreateGroupSheet = true
                            }) {
                                HStack {
                                    Text("New Group")
                                        .font(.body)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(6)
                            }

                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                    }
                    .padding(.bottom, 8)
                }
                .frame(maxHeight: 300)
            },
            label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(space.name)
                        .font(.title3)
                        .fontWeight(.bold)

                    if !userFacingDescription.isEmpty {
                        Text(userFacingDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
        )
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
        .sheet(isPresented: $showCreateGroupSheet) {
            CreateGroupView(space: space)
        }
    }
}
