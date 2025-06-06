//
//  SharedSetsView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/20/25.
//
import SwiftUI

// MARK: - SharedSetsView
struct SharedSetsView: View {
    let sets: [SharedSetModel]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(sets) { set in
                    NavigationLink(destination: SharedQuickCapturesView(captures: set.quickCaptures)) {
                        SharedSetCardView(set: set)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .navigationTitle("Shared Sets")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - SharedSetCardView
struct SharedSetCardView: View {
    let set: SharedSetModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(set.title)
                .font(.title3)
                .fontWeight(.semibold)
            
            if let by = set.sharedBy {
                Text("Shared by \(by)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }


        }
        .padding(20)
        .modifier(GlassCardStyle())
    }
}
