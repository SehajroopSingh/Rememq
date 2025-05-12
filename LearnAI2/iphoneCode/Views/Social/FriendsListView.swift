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
        VStack {
            if friends.isEmpty {
                Text("No friends yet — here are some examples:")
                    .foregroundColor(.gray)
                ForEach(User.fakeFriends) { friend in
                    friendRow(friend)
                }
            } else {
                ForEach(friends) { friend in
                    friendRow(friend)
                }
            }
        }
        .padding(.horizontal)
        .onAppear { fetchFriends() }
    }

    func friendRow(_ friend: User) -> some View {
        HStack {
            avatarView(for: friend)
            VStack(alignment: .leading) {
                Text(friend.username)
                Text("Streak: \(friend.streak) 🔥").font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }

    func fetchFriends() {
        APIService.shared.performRequest(endpoint: "social/friends/") { result in
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
        if let avatar = friend.avatarURL, !avatar.isEmpty, let url = URL(string: avatar) {
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
