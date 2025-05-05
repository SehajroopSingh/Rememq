struct FriendsListView: View {
    @State var friends: [User] = []  // Call your /api/friends/ endpoint

    var body: some View {
        List(friends) { friend in
            HStack {
                Image(uiImage: friend.avatar)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(friend.username)
                    Text("Streak: \(friend.streak) 🔥").font(.subheadline)
                }
            }
        }
    }
}
