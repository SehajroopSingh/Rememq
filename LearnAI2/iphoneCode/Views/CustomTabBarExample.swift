import SwiftUI

//struct CustomTabBarExample: View {
//    @State private var selectedTab = 0
//
//    var body: some View {
//        NavigationStack {
//            TabView(selection: $selectedTab) {
//                DashboardView()
//                    .tag(0)
//
//                NavigationStack {
//                    SpacesView()
//                }
//                .tag(1)
//                // The Chat tab
//                ChatView()
//                    .tag(2)
//
//                NotificationsView1()
//                    .tag(3)
//
//                SocialView()
//                    .tag(4)
//            }
//            .toolbar(.hidden, for: .tabBar)
//
//            // -- Insert a custom bar at the bottom
//            .safeAreaInset(edge: .bottom) {
//                CustomBarContent(selectedTab: $selectedTab)
//            }
//        }
//    }
//}
struct CustomTabBarExample: View {
    @State private var selected = 0

    var body: some View {
        ZStack(alignment: .bottom) {          // ⬅︎ overlay zone
            TabView(selection: $selected) {

                // 1️⃣ Dashboard tab
                NavigationStack { DashboardView() }
                    .tag(0)

                // 2️⃣ Spaces tab
                NavigationStack { SpacesView() }
                    .tag(1)

                // 3️⃣ Chat tab
                NavigationStack { ChatView() }
                    .tag(2)

                // 4️⃣ Notifications
                NavigationStack { GamificationView() }
                    .tag(3)

                // 5️⃣ Social
                NavigationStack { SocialView() }
                    .tag(4)
            }
            .toolbar(.hidden, for: .tabBar)    // hide Apple’s bar

            CustomBarContent(selectedTab: $selected)   // ⬅︎ always on top
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)     // optional
    }
}

struct CustomBarContent: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            // MARK: Dashboard
            Button {
                selectedTab = 0
            } label: {
                Image(systemName: "house.fill")
            }

            Spacer()

            // MARK: QuickCapturesList
            Button {
                selectedTab = 1
            } label: {
                Image(systemName: "doc.text.fill")
            }

            Spacer()

            // MARK: The plus button => just switch to ChatView tab
            Button {
                selectedTab = 2  // The Chat tab index
            } label: {
                Image("Rabbit_hole")
                    .resizable()
                    .aspectRatio(contentMode: .fit)   // or .fill as desired
                    .frame(width: 60, height: 60)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .offset(y: -10)

            Spacer()

            // MARK: Notifications
            Button {
                selectedTab = 3
            } label: {
                Image(systemName: "chart.bar")
            }

            Spacer()

            // MARK: Social
            Button {
                selectedTab = 4
            } label: {
                Image(systemName: "person.2")
            }
        }
        .padding(.horizontal, 30)
        .frame(height: 60)
        .background(Color(UIColor.systemGray6))
    }
}

//// MARK: - Sample Child Views
//struct DashboardView: View {
//    var body: some View {
//        VStack {
//            Text("DashboardView")
//                .font(.largeTitle)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.yellow.edgesIgnoringSafeArea(.all))
//    }
//}

//struct QuickCapturesListView: View {
//    var body: some View {
//        VStack {
//            Text("QuickCapturesListView")
//                .font(.largeTitle)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.orange.edgesIgnoringSafeArea(.all))
//    }
//}


//struct SocialView: View {
//    var body: some View {
//        VStack {
//            Text("SocialView")
//                .font(.largeTitle)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.purple.edgesIgnoringSafeArea(.all))
//    }
//}

struct PracticeView: View {
    var body: some View {
        VStack {
            Text("Daily Practice View")
                .font(.title)
        }
        .padding()
        .presentationDetents([.medium, .large]) // iOS 16+ optional
    }
}
//
//// MARK: - ChatView from your code (unchanged)
//struct ChatView: View {
//    @StateObject var viewModel: ChatViewModel = ChatViewModel()
//
//    var body: some View {
//        VStack {
//            // Messages list
//            ScrollView {
//                LazyVStack(alignment: .leading, spacing: 12) {
//                    ForEach(viewModel.messages) { message in
//                        MessageBubbleView(message: message) {
//                            viewModel.addTextToCaptures(message.content)
//                        }
//                    }
//                }
//                .padding(.horizontal)
//            }
//
//            // Input area
//            HStack {
//                TextField("Type your message...", text: $viewModel.inputText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                Button("Send") {
//                    viewModel.sendMessage()
//                }
//                .disabled(viewModel.inputText.isEmpty)
//            }
//            .padding()
//        }
//        .navigationTitle("AI Chat")
//    }
//}

// MARK: - Preview
struct CustomTabBarExample_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarExample()
    }
}
