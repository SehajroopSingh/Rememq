struct PinnedItemsSection: View {
    let pinned: [PinnedItem]
    let onTap: (PinnedItem) -> Void

    var body: some View {
        let groupedPinned = Dictionary(grouping: pinned, by: { $0.type })

        VStack(alignment: .leading, spacing: 16) {
            Text("📌 Pinned Items")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            ForEach(["space", "group", "set"], id: \.self) { type in
                if let items = groupedPinned[type] {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(type.capitalized)
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)

                        ForEach(items) { item in
                            Button(action: {
                                onTap(item)
                            }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue.opacity(0.1))
                                            .frame(width: 32, height: 32)
                                        Image(systemName: symbolForPinnedType(item.type))
                                            .foregroundColor(.blue)
                                    }

                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                            .font(.body)
                                            .fontWeight(.medium)
                                        Text(item.type.capitalized)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
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
