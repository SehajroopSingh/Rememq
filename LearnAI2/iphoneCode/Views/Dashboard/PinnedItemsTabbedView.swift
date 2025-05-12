import SwiftUI

struct PinnedItemsTabbedView: View {
    let pinned: [PinnedItem]
    let onTap: (PinnedItem) -> Void

    @State private var selectedTab: String = "space"

    private var typesInPinned: [String] {
        let types = Set(pinned.map { $0.type })
        return ["space", "group", "set"].filter { types.contains($0) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !typesInPinned.isEmpty {
                HStack {
                    ForEach(typesInPinned, id: \.self) { type in
                        Button(action: {
                            selectedTab = type
                        }) {
                            Text(type.capitalized)
                                .font(.subheadline)
                                .fontWeight(selectedTab == type ? .bold : .regular)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedTab == type ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(10)
                        }
                        .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(pinned.filter { $0.type == selectedTab }) { item in
                        Button(action: {
                            onTap(item)
                        }) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: symbolForPinnedType(item.type))
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20, weight: .medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }

                                Text(item.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text(item.type.capitalized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(width: 220)
                            .background(
                                BlurView(style: .systemMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            )
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
}

//// MARK: - Blur Background Utility
//struct BlurView: UIViewRepresentable {
//    var style: UIBlurEffect.Style
//    func makeUIView(context: Context) -> UIVisualEffectView {
//        UIVisualEffectView(effect: UIBlurEffect(style: style))
//    }
//    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
//}
//
//// MARK: - Icon Helper
//func symbolForPinnedType(_ type: String) -> String {
//    switch type {
//    case "space": return "folder.fill"
//    case "group": return "square.stack.fill"
//    case "set": return "doc.plaintext.fill"
//    default: return "pin.fill"
//    }
//}
