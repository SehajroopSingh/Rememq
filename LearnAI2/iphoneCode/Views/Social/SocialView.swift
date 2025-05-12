//
//  SocialView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/13/25.
//


import SwiftUI

import SwiftUI

struct SocialView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Friends")
                    .font(.title2)
                    .padding(.horizontal)
                FriendsListView()

                Divider().padding(.horizontal)

                Text("Activity Feed")
                    .font(.title2)
                    .padding(.horizontal)
                ActivityFeedView()
                
                FriendSearchView()
                    .padding()
                IncomingRequestsView()

            }
        }
    }
}
#Preview {
    SocialView()
}


// Preview
struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
