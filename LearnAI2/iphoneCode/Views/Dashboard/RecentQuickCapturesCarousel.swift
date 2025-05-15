import SwiftUI

struct RecentQuickCapturesCarousel: View {
    let captures: [QuickCaptureItem]

    @State private var currentIndex: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🕒 Recent QuickCaptures")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)

            GeometryReader { geo in
                let cardWidth: CGFloat = geo.size.width * 0.7
                let spacing: CGFloat = 16
                let totalSpacing = spacing * CGFloat(captures.count - 1)
                let contentWidth = (cardWidth * CGFloat(captures.count)) + totalSpacing

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach(Array(captures.enumerated()), id: \.1.id) { index, capture in
                            GeometryReader { itemGeo in
                                let xOffset = itemGeo.frame(in: .global).minX
                                let center = UIScreen.main.bounds.width / 2
                                let scale = max(0.9, 1.2 - abs(xOffset - center) / 300)

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(capture.shortDescription ?? "No Description")
                                        .font(.headline)

                                    Text(capture.content)
                                        .font(.caption)
                                        .lineLimit(4)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(width: cardWidth)
                                .background(
                                    BlurView(style: .systemMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                )
                                .scaleEffect(scale)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: scale)
                            }
                            .frame(width: cardWidth, height: 160)
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(width: contentWidth)
                }
            }
            .frame(height: 180)
        }
        .padding(.top)
    }
}
