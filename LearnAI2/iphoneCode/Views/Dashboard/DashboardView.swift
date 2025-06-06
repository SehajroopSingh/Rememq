import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var structureViewModel: StructureViewModel
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    @State private var isProfileMenuOpen = false // Controls profile menu visibility
    @State private var selectedPinnedSet: SetItem?
    @State private var selectedPinnedGroup: Group?
    @State private var selectedPinnedSpace: Space?
    @State private var navigateToSet = false
    @State private var navigateToGroup = false
    @State private var navigateToSpace = false
    @State private var showPractice = false
    @StateObject private var practiceViewModel = PracticeViewModel()



    var body: some View {

                
                    ZStack {


                        BlobbyBackground()
                            
                            // or BlobbyBackground()
                            
                            // Main Dashboard (Shifts left when menu is open)
                            VStack {
                                

                                HStack {
                                    

                                    
                                    
                                    // Dashboard Data Bar
                                    if let data = dashboardViewModel.dashboardData {
                                        HStack(spacing: 20) {
                                            DashboardItemView(
                                                icon: "heart_red_blurred_glasss",
                                                value: data.hearts,
                                                color: .red
                                            )
                                            DashboardItemView(icon: "xp_yellow_glassmorphism", value: data.xp, color: .yellow)
                                            DashboardItemView(icon: "red_yellow_glassy _blurred_ fire", value: data.streak, color: .orange)
                                            DashboardItemView(icon: "gem_blue_blurred_glass", value: data.gems, color: .blue)
                                        }
                                    } else {
                                        Text("Loading...")
                                            .font(.headline)
                                    }
                                    
                                    Spacer()
                                    
                                    // Profile Button (Right)
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isProfileMenuOpen.toggle()
                                        }
                                    }) {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .padding(8)
                                            .background(.ultraThinMaterial)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                            .shadow(radius: 4)
                                    }
                                }
                                .padding(.top, 0.2) // reduce this value or change it to `.padding(.top, 0)` if needed
                                .padding(.top, 10)
                                .padding(.horizontal)
                                .frame(height: 70)
                                .background(.ultraThinMaterial) //
                                
                                QuickCaptureView()
                                
                                

                                Button(action: {
                                    practiceViewModel.context = .fromDashboard
                                    showPractice = true
                                }) {
                                    Text("Start Practice")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            ZStack {
                                                // Frosted glass layer
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.white.opacity(0.15))
                                                    .background(.ultraThinMaterial)
                                                    .blur(radius: 0.5)
                                                    .shadow(color: .white.opacity(0.2), radius: 2, x: -2, y: -2)
                                                    .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 4)

                                                // Inner shine
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(LinearGradient(
                                                        colors: [Color.white.opacity(0.6), Color.white.opacity(0.05)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ), lineWidth: 1.5)
                                            }
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                }
                                .fullScreenCover(isPresented: $showPractice) {
                                    QuizPracticeView()
                                        .environmentObject(practiceViewModel)
                                }


                                
                                // 🔹 New Card-Style Section Below Daily Practice Button 🔹
                                //CardSectionView()
                                if let pinned = dashboardViewModel.dashboardData?.pinnedItems, !pinned.isEmpty {
                                    //                        PinnedItemsSection(pinned: pinned, onTap: routeToPinned)
                                    PinnedItemsTabbedView(pinned: pinned, onTap: routeToPinned)
                                    
                                }
                                
                                if let captures = dashboardViewModel.dashboardData?.recentQuickCaptures, !captures.isEmpty {
                                    RecentQuickCapturesCarousel(captures: captures)
                                }
                                
                                
                                if let error = dashboardViewModel.errorMessage {
                                    Text("Error: \(error)")
                                        .foregroundColor(.red)
                                }
                                
                                NavigationLink(
                                    destination: selectedPinnedSet != nil
                                    ? AnyView(
                                        QuickCapturesView(set: selectedPinnedSet!)
                                        
                                    )
                                    : AnyView(EmptyView()),
                                    isActive: $navigateToSet
                                ) {
                                    EmptyView()
                                }
                                
                                
                                
                                
                                NavigationLink(
                                    destination: selectedPinnedGroup != nil
                                    ? AnyView(
                                        SetsView(group: selectedPinnedGroup!)
                                    )
                                    : AnyView(EmptyView()),
                                    isActive: $navigateToGroup
                                ) {
                                    EmptyView()
                                }
                                
                                
                                NavigationLink(
                                    destination: selectedPinnedSpace != nil
                                    ? AnyView(
                                        SpacesView()
                                        
                                    )
                                    : AnyView(EmptyView()),
                                    isActive: $navigateToSpace
                                ) {
                                    EmptyView()
                                }
                                
                                
                                
                                Spacer()
                            }
                            .offset(x: isProfileMenuOpen ? -UIScreen.main.bounds.width * 0.75 : 0) // Moves the main view left
                            .animation(.easeInOut(duration: 0.3), value: isProfileMenuOpen)
                            
                            
                            // Profile Menu View (Sliding in from the right)
                            if isProfileMenuOpen {
                                ProfileMenuView(isOpen: $isProfileMenuOpen)
                            }
                        }
                    
                    .onAppear {
                        print("👀 DashboardView appeared")
                        
                        dashboardViewModel.loadDashboard() // 🔁 Just re-fetc
                    
                }
            
    }
    
    func routeToPinned(_ item: PinnedItem) {
        switch item.type {
        case "set":
            if let set = structureViewModel.findSet(by: item.id) {
                selectedPinnedSet = set
                navigateToSet = true
            }
        case "group":
            if let group = structureViewModel.findGroup(by: item.id) {
                selectedPinnedGroup = group
                navigateToGroup = true
            }
        case "space":
            if let space = structureViewModel.findSpace(by: item.id) {
                selectedPinnedSpace = space
                navigateToSpace = true
            }
        default:
            break
        }
    }



}

struct DashboardItemView: View {
    let icon: String
    let value: Int
    let color: Color

    var body: some View {
        HStack {
            Image(icon) // Not systemName
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(color) // optional, if image is monochrome
            Text("\(value)")
                .font(.headline)
                .foregroundColor(color)
        }
    }
}
//
//// MARK: - Profile Menu View with Account Navigation
//struct ProfileMenuView: View {
//    @Binding var isOpen: Bool
//    
//    var body: some View {
//        HStack {
//            Spacer()
//            
//            VStack(alignment: .leading) {
//                Text("Profile Menu")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 20)
//                    .padding(.leading)
//                
//                Divider()
//                
//                NavigationLink(destination: AccountView()) {  // ✅ Navigate to AccountView
//                    Text("Account")
//                        .padding()
//                }
//                
//                NavigationLink(destination: SettingsView()) {
//                    Text("Settings").padding()
//                }
//                
//                Button(action: { print("Help tapped") }) {
//                    Text("Help").padding()
//                }
//                
//                Button(action: { print("Log Out tapped") }) {
//                    Text("Log Out")
//                        .foregroundColor(.red)
//                        .padding()
//                }
//                
//                Spacer()
//            }
//            .frame(width: UIScreen.main.bounds.width * 0.75)
//            .background(Color.white)
//            .edgesIgnoringSafeArea(.bottom)
//            .offset(x: isOpen ? 0 : UIScreen.main.bounds.width * 0.75)
//            .animation(.easeInOut(duration: 0.3), value: isOpen)
//        }
//        .background(Color.black.opacity(isOpen ? 0.3 : 0).edgesIgnoringSafeArea(.all))
//        .onTapGesture {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                isOpen = false
//            }
//        }
//    }
//}

import SwiftUI
//
//struct ProfileMenuView: View {
//    @Binding var isOpen: Bool
//    
//    // Utility to get safe area inset for bottom
//    private var bottomSafeArea: CGFloat {
//        UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
//    }
//    
//    var body: some View {
//        HStack {
//            Spacer()
//            VStack(alignment: .leading, spacing: 0) {
//                Text("Profile Menu")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 20)
//                    .padding(.horizontal)
//                Divider()
//                    .background(Color.white.opacity(0.5))
//                    .padding(.horizontal)
//                
//                NavigationLink(destination: AccountView()) {
//                    Text("Account")
//                        .padding()
//                }
//                NavigationLink(destination: SettingsView()) {
//                    Text("Settings")
//                        .padding()
//                }
//                Button(action: { print("Help tapped") }) {
//                    Text("Help")
//                        .padding()
//                }
//                Button(action: { print("Log Out tapped") }) {
//                    Text("Log Out")
//                        .foregroundColor(.red)
//                        .padding()
//                }
//                Spacer(minLength: bottomSafeArea)
//            }
//            .frame(width: UIScreen.main.bounds.width * 0.75)
//            // Glassmorphic background
//            .background(.ultraThinMaterial)
//            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//            .overlay(
//                RoundedRectangle(cornerRadius: 20, style: .continuous)
//                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
//            )
//            .shadow(color: Color.black.opacity(0.2), radius: 10, x: -5, y: 0)
//            .offset(x: isOpen ? 0 : UIScreen.main.bounds.width * 0.75)
//            .animation(.easeInOut(duration: 0.3), value: isOpen)
//        }
//        // Background dimmer
//        .background(
//            Color.black
//                .opacity(isOpen ? 0.3 : 0)
//                .edgesIgnoringSafeArea(.all)
//        )
//        .onTapGesture {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                isOpen = false
//            }
//        }
//    }
//}

import SwiftUI

struct ProfileMenuView: View {
    @Binding var isOpen: Bool
    @State private var showLogoutConfirmation = false

    // Utility to get safe area inset for bottom
    private var bottomSafeArea: CGFloat {
        UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }

    var body: some View {
        ZStack {
            // MARK: – Underlying menu
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text("Profile Menu")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 20)
                        .padding(.horizontal)
                    Divider()
                        .background(Color.white.opacity(0.5))
                        .padding(.horizontal)

                    NavigationLink("Account", destination: AccountView())
                        .padding()
                    NavigationLink("Settings", destination: SettingsView())
                        .padding()
                    Button("Help") { /* … */ }
                        .padding()

                    // ← Our Logout button now triggers the popup
                    Button(action: {
                        withAnimation(.spring()) {
                            showLogoutConfirmation = true
                        }
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                            .padding()
                    }

                    Spacer(minLength: bottomSafeArea)
                }
                .frame(width: UIScreen.main.bounds.width * 0.75)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: -5, y: 0)
                .offset(x: isOpen ? 0 : UIScreen.main.bounds.width * 0.75)
                .animation(.easeInOut(duration: 0.3), value: isOpen)
            }
            .background(Color.black.opacity(isOpen ? 0.3 : 0).edgesIgnoringSafeArea(.all))
            .onTapGesture {
                withAnimation(.easeInOut) { isOpen = false }
            }

            // MARK: – Logout Confirmation Popup
            if showLogoutConfirmation {
                // Dimmed backdrop
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)

                // Glass-morphic card
                VStack(spacing: 20) {
                    Text("Log Out?")
                        .font(.headline)
                    Text("Are you sure you want to log out?")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 16) {
                        Button("Cancel") {
                            withAnimation(.spring()) {
                                showLogoutConfirmation = false
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Button("Log Out") {
                            APIService.shared.logout()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 40)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

func symbolForPinnedType(_ type: String) -> String {
    switch type {
    case "space": return "folder.fill"
    case "group": return "square.stack.fill"
    case "set": return "doc.plaintext.fill"
    default: return "pin.fill"
    }
}


struct CardSectionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Explore More")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading)
            
            // Regular Buttons Scrollable Stack
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { index in
                        Button(action: { print("Button \(index) tapped") }) {
                            Text("Button \(index)")
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            
            // Card-Style Buttons Scrollable Stack
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { index in
                        VStack {
                            Image(systemName: "book.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            
                            Text("Card \(index)")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .frame(width: 120, height: 120)
                        .background(Color.purple.opacity(0.8))
                        .cornerRadius(15)
                    }
                }
                .padding()
            }
        }
        .padding()
        .background(Color(.systemGray6)) // Card-style background
        .cornerRadius(15)
        .padding(.horizontal)
    }
}
//
//// Placeholder View for Practice
//struct PracticeView: View {
//    var body: some View {
//        Text("Practice Session")
//            .font(.largeTitle)
//    }
//}

// MARK: - Preview
struct CustomTabBarExample_Previews1: PreviewProvider {
    static var previews: some View {
        CustomTabBarExample()
    }
}

