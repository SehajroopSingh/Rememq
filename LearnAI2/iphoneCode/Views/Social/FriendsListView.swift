////
////  FriendsListView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 5/5/25.
////
//import SwiftUI
//
//struct FriendsListView: View {
//    @State var friends: [User] = []
//
//    var body: some View {
//        VStack {
//            if friends.isEmpty {
//                Text("No friends yet — here are some examples:")
//                    .foregroundColor(.gray)
//                ForEach(User.fakeFriends) { friend in
//                    friendRow(friend)
//                }
//            } else {
//                ForEach(friends) { friend in
//                    friendRow(friend)
//                }
//            }
//        }
//        .padding(.horizontal)
//        .onAppear { fetchFriends() }
//    }
//
//    func friendRow(_ friend: User) -> some View {
//        HStack {
//            avatarView(for: friend)
//            VStack(alignment: .leading) {
//                Text(friend.username)
//                Text("Streak: \(friend.streak) 🔥").font(.subheadline)
//            }
//            Spacer()
//        }
//        .padding(.vertical, 4)
//    }
//
//    func fetchFriends() {
//        APIService.shared.performRequest(endpoint: "social/friends/") { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let decoded = try JSONDecoder().decode([User].self, from: data)
//                    DispatchQueue.main.async {
//                        self.friends = decoded
//                    }
//                } catch {
//                    print("❌ Decoding error:", error)
//                }
//            case .failure(let error):
//                print("❌ Request error:", error)
//            }
//        }
//    }
//
//    @ViewBuilder
//    func avatarView(for friend: User) -> some View {
//        if let avatar = friend.avatarURL, !avatar.isEmpty, let url = URL(string: avatar) {
//            AsyncImage(url: url) { image in
//                image.resizable()
//            } placeholder: {
//                defaultAvatar
//            }
//        } else {
//            defaultAvatar
//        }
//    }
//
//    var defaultAvatar: some View {
//        Image(systemName: "person.crop.circle.fill")
//            .resizable()
//            .frame(width: 40, height: 40)
//            .foregroundColor(.gray)
//    }
////}
//import SwiftUI
//
//struct FriendsListView: View {
//    @State var friends: [User] = []
//
//    var body: some View {
//        VStack(spacing: 12) {
//            if friends.isEmpty {
//                Text("No friends yet — here are some examples:")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                    )
//                    .padding(.horizontal)
//
//                ForEach(User.fakeFriends) { friend in
//                    friendRow(friend)
//                }
//            } else {
//                ForEach(friends) { friend in
//                    friendRow(friend)
//                }
//            }
//        }
//        .padding(.top)
//        .onAppear { fetchFriends() }
//    }
//
//    @ViewBuilder
//    private func friendRow(_ friend: User) -> some View {
//        HStack(spacing: 12) {
//            avatarView(for: friend)
//                .frame(width: 50, height: 50)
//                .background(.ultraThinMaterial, in: Circle())
//                .overlay(
//                    Circle().stroke(Color.white.opacity(0.3), lineWidth: 1)
//                )
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text(friend.username)
//                    .font(.body)
//                    .foregroundColor(.primary)
//                Text("Streak: \(friend.streak) 🔥")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//
//            Spacer()
//        }
//        .padding()
//        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(Color.white.opacity(0.3), lineWidth: 1)
//        )
//        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
//        .padding(.horizontal)
//    }
//
//    private func fetchFriends() {
//        APIService.shared.performRequest(endpoint: "social/friends/") { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let decoded = try JSONDecoder().decode([User].self, from: data)
//                    DispatchQueue.main.async { self.friends = decoded }
//                } catch {
//                    print("❌ Decoding error:", error)
//                }
//            case .failure(let error):
//                print("❌ Request error:", error)
//            }
//        }
//    }
//
//    @ViewBuilder
//    private func avatarView(for friend: User) -> some View {
//        if let avatar = friend.avatarURL, let url = URL(string: avatar), !avatar.isEmpty {
//            AsyncImage(url: url) { image in
//                image.resizable().scaledToFill()
//            } placeholder: {
//                defaultAvatar
//            }
//        } else {
//            defaultAvatar
//        }
//    }
//
//    private var defaultAvatar: some View {
//        Image(systemName: "person.crop.circle.fill")
//            .resizable()
//            .scaledToFit()
//            .foregroundColor(.gray)
//    }
//}
//
//struct FriendsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsListView()
//    }
//}
import SwiftUI

struct FriendsListView: View {
    //@State var friends: [User] = []
    @EnvironmentObject var socialVM: SocialViewModel


    var body: some View {
        VStack(spacing: 16) {
            // Friend search at top
            FriendSearchView()
                .frame(maxWidth: .infinity)
                .padding(.horizontal)

            if socialVM.friends.isEmpty{
                Text("No friends yet — here are some examples:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)

                ForEach(User.fakeFriends) { friend in
                    friendRow(friend)
                }
            } else {
                ForEach(socialVM.friends) { friend in
                    friendRow(friend)
                }
            }
            
            IncomingRequestsView()
        }
        .padding(.top)
        .onAppear {
            Task {
                await socialVM.fetchFriends()
            }
        }
    }

    @ViewBuilder
    private func friendRow(_ friend: User) -> some View {
        HStack(spacing: 12) {
            avatarView(for: friend)
                .frame(width: 50, height: 50)
                .background(.ultraThinMaterial, in: Circle())
                .overlay(
                    Circle().stroke(Color.white.opacity(0.3), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(friend.username)
                    .font(.body)
                    .foregroundColor(.primary)
                Text("Streak: \(friend.streak) 🔥")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

//    private func fetchFriends() {
//        APIService.shared.performRequest(endpoint: "social/friends/") { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let decoded = try JSONDecoder().decode([User].self, from: data)
//                    DispatchQueue.main.async { self.friends = decoded }
//                } catch {
//                    print("❌ Decoding error:", error)
//                }
//            case .failure(let error):
//                print("❌ Request error:", error)
//            }
//        }
//    }

    @ViewBuilder
    private func avatarView(for friend: User) -> some View {
        if let avatar = friend.avatarURL, let url = URL(string: avatar), !avatar.isEmpty {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                defaultAvatar
            }
        } else {
            defaultAvatar
        }
    }

    private var defaultAvatar: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView()
    }
}
