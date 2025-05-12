//  PinnedItemsSection.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/11/25.

import SwiftUI

struct PinnedItemsTabbedView: View {
    let pinned: [PinnedItem]
    let onTap: (PinnedItem) -> Void

    @State private var selectedTab: String = "space"

    var availableTabs: [String] {
        let types = Set(pinned.map { $0.type })
        return ["space", "group", "set"].filter { types.contains($0) }
    }

    var body: some View {
        let groupedPinned = Dictionary(grouping: pinned, by: { $0.type })

        VStack(alignment: .leading, spacing: 16) {
            Text("📌 Pinned Items")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            // Tab Selector
            HStack(spacing: 12) {
                ForEach(availableTabs, id: \.") { type in
                    Button(action: {
                        selectedTab = type
                    }) {
                        Text(type.capitalized)
                            .fontWeight(selectedTab == type ? .bold : .regular)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                Capsule()
                                    .fill(selectedTab == type ? Color.blue.opacity(0.2) : Color.clear)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)

            // Horizontal Scrollable Cards
            if let items = groupedPinned[selectedTab] {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(items) { item in
                            Button(action: {
                                onTap(item)
                            }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Image(systemName: symbolForPinnedType(item.type))
                                        .font(.system(size: 24))
                                        .foregroundColor(.blue)
                                        .padding(10)
                                        .background(Color.blue.opacity(0.1))
                                        .clipShape(Circle())

                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    Text(item.type.capitalized)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(width: 180, height: 140)
                                .background(BlurView(style: .systemMaterial))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("No pinned \(selectedTab)s")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

// Native blur view
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

func symbolForPinnedType(_ type: String) -> String {
    switch type {
    case "space": return "folder.fill"
    case "group": return "square.stack.fill"
    case "set": return "doc.plaintext.fill"
    default: return "pin.fill"
    }
}
