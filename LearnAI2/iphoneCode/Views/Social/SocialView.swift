//
//  SocialView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/13/25.
//


import SwiftUI

struct SocialView: View {
    var body: some View {
        TabView {
            FriendsListView()
                .tabItem {
                    Label("Friends", systemImage: "person.2")
                }
            
            ActivityFeedView()
                .tabItem {
                    Label("Feed", systemImage: "list.bullet.rectangle")
                }
        }
    }
}


// Preview
struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
