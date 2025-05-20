////
////  SocialView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 3/13/25.
////
//
//
//import SwiftUI
//
//import SwiftUI
//
//struct SocialView: View {
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 24) {
//                Text("Friends")
//                    .font(.title2)
//                    .padding(.horizontal)
//                FriendsListView()
//
//                Divider().padding(.horizontal)
//
//                Text("Activity Feed")
//                    .font(.title2)
//                    .padding(.horizontal)
//                ActivityFeedView()
//                
//                FriendSearchView()
//                    .padding()
//                IncomingRequestsView()
//
//            }
//        }
//    }
//}
//#Preview {
//    SocialView()
//}
//
//
//// Preview
//struct SocialView_Previews: PreviewProvider {
//    static var previews: some View {
//        SocialView()
//    }
//}


import SwiftUI

/// Configure nav bar appearance globally
func configureNavBarAppearance2() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = .clear
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}

struct SocialView: View {
    init() {
        configureNavBarAppearance2()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BlobbyBackground()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {



                        FriendsListView()

                        Divider()
                            .padding(.horizontal)

                        Text("Activity Feed")
                            .font(.title2)
                            .padding(.horizontal)
                        ActivityFeedView()


                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Social")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SocialView()
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
