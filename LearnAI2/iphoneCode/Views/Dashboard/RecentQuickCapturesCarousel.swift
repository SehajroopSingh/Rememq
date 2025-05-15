//
//  RecentQuickCapturesCarousel.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/12/25.
//


import SwiftUI

import SwiftUI

struct RecentQuickCapturesCarousel: View {
    let captures: [QuickCaptureItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent QuickCaptures")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)

            GeometryReader { geo in
                let screenCenter = geo.size.width / 2
                let cardWidth: CGFloat = geo.size.width * 0.7
                let spacing: CGFloat = 16

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach(Array(captures.enumerated()), id: \.1.id) { index, capture in
                            GeometryReader { itemGeo in
                                let midX = itemGeo.frame(in: .global).midX
                                let distance = abs(midX - screenCenter)
                                let scale = max(0.95, 1 - distance / screenCenter * 0.1)

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(capture.shortDescription ?? "No Description")
                                        .font(.headline)
                                        .lineLimit(1)
                                        .foregroundColor(.primary)

                                    Text(capture.content)
                                        .font(.caption)
                                        .lineLimit(4)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(width: cardWidth)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.1)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 3)
                                )
                                .scaleEffect(scale)
                                .animation(.easeOut(duration: 0.2), value: scale)
                            }
                            .frame(width: cardWidth, height: 160)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .frame(height: 180)
        }
        .padding(.top)
    }
}
