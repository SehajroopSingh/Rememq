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
//
struct SpaceCardView: View {
    let space: Space
    @State private var userFacingDescription: String
    @State private var showCreateGroupSheet = false
    @State private var isExpanded = false
    @State private var isPinned: Bool

    init(space: Space) {
        self.space = space
        self._userFacingDescription = State(initialValue: space.userFacingDescription ?? "")
        self._isPinned = State(initialValue: space.isPinned)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    Divider().padding(.bottom, 4)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(spacing: 8) {
                                ForEach(space.groups, id: \.id) { group in
                                    GroupRowView(group: group)
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

            // ✅ Pin icon floating top-right
            Button(action: {
                togglePin()
            }) {
                Image(systemName: isPinned ? "star.fill" : "star")
                    .foregroundColor(isPinned ? .yellow : .gray)
                    .padding()
            }
        }
    }

    private func togglePin() {
        let newPinnedState = !isPinned
        isPinned = newPinnedState

        APIService.shared.performRequest(
            endpoint: "organizer/toggle-pin/",
            method: "POST",
            body: [
                "type": "space",
                "id": space.id
            ]
        ) { result in
            switch result {
            case .success(let data):
                if let response = try? JSONDecoder().decode([String: String].self, from: data),
                   let status = response["status"] {
                    DispatchQueue.main.async {
                        self.isPinned = (status == "pinned")
                    }
                }
            case .failure(let error):
                print("❌ Pin toggle error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isPinned = !newPinnedState
                }
            }
        }
    }
}


struct GroupRowView: View {
    let group: Group
    @State private var isPinned: Bool

    init(group: Group) {
        self.group = group
        _isPinned = State(initialValue: group.isPinned)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
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

            Button(action: {
                togglePin()
            }) {
                Image(systemName: isPinned ? "star.fill" : "star")
                    .foregroundColor(isPinned ? .yellow : .gray)
                    .padding(6)
            }
        }
    }

    private func togglePin() {
        let newState = !isPinned
        isPinned = newState

        APIService.shared.performRequest(
            endpoint: "organizer/toggle-pin/",
            method: "POST",
            body: [
                "type": "group",
                "id": group.id
            ]
        ) { result in
            switch result {
            case .success(let data):
                if let response = try? JSONDecoder().decode([String: String].self, from: data),
                   let status = response["status"] {
                    DispatchQueue.main.async {
                        self.isPinned = (status == "pinned")
                    }
                }
            case .failure(let error):
                print("❌ Group pin toggle error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isPinned = !newState
                }
            }
        }
    }
}
