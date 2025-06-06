//
//  SharedSpaceCardView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/20/25.
//
import SwiftUI

// MARK: - Shared Space Card
struct SharedSpaceCardView: View {
    let space: SharedSpaceModel
    @State private var isExpanded = false
    @State private var isPinned = false  // you can tie this to your pin API if desired

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(space.name)
                        .font(.headline)
                    if let by = space.sharedBy {
                        Text("Shared by: \(by)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Button(action: { isPinned.toggle() }) {
                    Image(systemName: isPinned ? "star.fill" : "star")
                        .font(.title3)
                        .foregroundColor(isPinned ? .yellow : .gray)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .onTapGesture { withAnimation { isExpanded.toggle() } }

            // Expanded content
            if isExpanded {
                Divider()
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    // Groups
                    ForEach(space.groups) { group in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(group.name)
                                .font(.subheadline)
                                .bold()
                                .padding(.bottom, 2)

                            // Sets within group
                            ForEach(group.sets) { set in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("↳ \(set.title)")
                                        .font(.footnote)
                                    // QuickCaptures within set
                                    ForEach(set.quickCaptures) { qc in
                                        Text("   • \(qc.shortDescription)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.leading)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                }
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
