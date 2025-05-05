//
//  FoldersView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/16/25.
//
import SwiftUI

struct FoldersView: View {
    let set: SetItem
    @StateObject private var viewModel = FoldersViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.folders.filter { $0.set == set.id }) { folder in
                    CardView(title: folder.name)
                }
                // If you have quick captures, include them similarly.
            }
            .padding()
        }
        .navigationTitle(set.title)
        .onAppear {
            viewModel.loadFolders()
        }
    }
}
