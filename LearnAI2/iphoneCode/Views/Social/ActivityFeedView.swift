struct ActivityFeedView: View {
    @State var activities: [Activity] = []  // From /api/social/feed/

    var body: some View {
        ScrollView {
            ForEach(activities) { activity in
                VStack(alignment: .leading) {
                    Text(activity.content)
                        .font(.body)
                    Text(activity.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                .padding(.horizontal)
            }
        }
    }
}
