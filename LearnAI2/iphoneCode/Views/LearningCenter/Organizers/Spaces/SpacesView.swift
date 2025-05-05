////
////  SpacesView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 3/16/25.
////
//
//
//import SwiftUI
//
//struct SpacesView: View {
//    @StateObject private var viewModel = SpacesViewModel()
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                LazyVStack(spacing: 16) {
//                    ForEach(viewModel.spaces) { space in
//                        NavigationLink(destination: GroupsView(space: space)) {
//                            CardView(title: space.name)
//                        }
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("Spaces")
//            .onAppear {
//                viewModel.loadSpaces()
//            }
//        }
//    }
//}
import SwiftUI
struct SpacesView: View {
    @StateObject private var viewModel = SpacesViewModel()
    @State private var showCreateSheet = false  // optional if using sheet
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    
                    // Add "New Space" button card
                    Button(action: {
                        showCreateSheet = true
                    }) {
                        ZStack {
                            Color.blue
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                            VStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                                Text("New Space")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .padding()
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }

                    // Regular space cards
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
            .sheet(isPresented: $showCreateSheet) {
                CreateSpaceView()  // Replace with your actual view
            }
        }
    }
}

