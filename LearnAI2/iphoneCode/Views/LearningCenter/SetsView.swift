//
//  SetsView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/16/25.
//
import SwiftUI

//struct SetsView: View {
//    let group: Group
//    @StateObject private var viewModel = SetsViewModel()
//    
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 16) {
//                ForEach(viewModel.sets.filter { $0.group == group.id }) { set in
//                    NavigationLink(destination: FoldersView(set: set)) {
//                        CardView(title: set.title)
//                    }
//                }
//            }
//            .padding()
//        }
//        .navigationTitle(group.name)
//        .onAppear {
//            viewModel.loadSets()
//        }
//    }
//}
struct SetsView: View {
    let group: Group
    @StateObject private var viewModel = SetsViewModel()
    
    var body: some View {
        List(viewModel.sets.filter { $0.group == group.id }) { set in
            NavigationLink(destination: QuickCapturesView(set: set)) {
                Text(set.title)
            }
        }
        .navigationTitle(group.name)
        .onAppear {
            viewModel.loadSets()
        }
    }
}
