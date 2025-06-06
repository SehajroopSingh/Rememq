//
//  SharedGroupsView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/20/25.
//

import SwiftUI

// MARK: - Shared Groups View
struct SharedGroupsView: View {
    let groups: [SharedGroupModel]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(groups) { group in
                    NavigationLink(destination: SharedSetsView(sets: group.sets)) {
                        SharedGroupCardView(group: group)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .navigationTitle("Shared Groups")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct SharedGroupCardView: View {
    let group: SharedGroupModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(group.name)
                .font(.title3)
                .fontWeight(.semibold)
            
            if let by = group.sharedBy {
                Text("Shared by \(by)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .modifier(GlassCardStyle())
    }
}

