//
//  PinnedItemsSection.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/11/25.
//

import SwiftUI
import SwiftUI

struct PinnedItemsSection: View {
    let pinned: [PinnedItem]
    let onTap: (PinnedItem) -> Void

    var body: some View {
        let groupedPinned = Dictionary(grouping: pinned, by: { $0.type })

        VStack(alignment: .leading, spacing: 24) {
            Text("📌 Pinned Items")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)

            ForEach(["space", "group", "set"], id: \.self) { type in
                if let items = groupedPinned[type] {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(type.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)

                        ForEach(items) { item in
                            Button(action: {
                                onTap(item)
                            }) {
                                HStack(spacing: 14) {
                                    ZStack {
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue.opacity(0.3), .blue.opacity(0.1)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))

                                        Image(systemName: symbolForPinnedType(item.type))
                                            .foregroundColor(.blue)
                                            .font(.system(size: 18, weight: .medium))
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.title)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.primary)

                                        Text(item.type.capitalized)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    BlurView(style: .systemMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .padding(.top)
    }
}

// Optional: Reusable native blur view for iOS
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

