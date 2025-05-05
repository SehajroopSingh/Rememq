//
//  FriendsListView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/5/25.
//
import SwiftUI


struct FriendsListView: View {
    @State var friends: [User] = []

    var body: some View {
        List(friends) { friend in
            HStack {
                avatarView(for: friend)
                VStack(alignment: .leading) {
                    Text(friend.username)
                    Text("Streak: \(friend.streak) 🔥").font(.subheadline)
                }
            }
        }
        .onAppear {
            fetchFriends()
        }
    }

    func fetchFriends() {
        APIService.shared.performRequest(endpoint: "friends/") { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode([User].self, from: data)
                    DispatchQueue.main.async {
                        self.friends = decoded
                    }
                } catch {
                    print("❌ Decoding error:", error)
                }
            case .failure(let error):
                print("❌ Request error:", error)
            }
        }
    }


    @ViewBuilder
    func avatarView(for friend: User) -> some View {
        if let url = URL(string: friend.avatarURL), !friend.avatarURL.isEmpty {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                defaultAvatar
            }
        } else {
            defaultAvatar
        }
    }

    var defaultAvatar: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.gray)
    }
}
