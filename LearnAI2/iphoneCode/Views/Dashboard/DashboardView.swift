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

    var body: some View {
            ZStack {
                // Main Dashboard (Shifts left when menu is open)
                VStack {
                    HStack {
                        // Menu Button (Left)
                        Menu {
                            Button("Settings", action: { print("Settings tapped") })
                            Button("Profile", action: { print("Profile tapped") })
                            Button("Logout", action: { print("Logout tapped") })
                        } label: {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 24, height: 18)
                                .padding()
                        }
                        
                        Spacer()
                        
                        // Dashboard Data Bar
                        if let data = dashboardViewModel.dashboardData {
                            HStack(spacing: 20) {
                                DashboardItemView(icon: "heart.fill", value: data.hearts, color: .red)
                                DashboardItemView(icon: "star.fill", value: data.xp, color: .yellow)
                                DashboardItemView(icon: "flame.fill", value: data.streak, color: .orange)
                                DashboardItemView(icon: "diamond.fill", value: data.gems, color: .blue)
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
                                .padding()
                        }
                    }
                    .background(Color.gray.opacity(0.2))
                    
                    QuickCaptureView()
                    
                    // Daily Practice Section
                    Text("Daily Practice")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    // Full-width Button
                    NavigationLink(destination: DailyPracticeView()) {
                        Text("Start Practice")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // 🔹 New Card-Style Section Below Daily Practice Button 🔹
                    //CardSectionView()
                    if let pinned = dashboardViewModel.dashboardData?.pinnedItems, !pinned.isEmpty {
//                        PinnedItemsSection(pinned: pinned, onTap: routeToPinned)
                        PinnedItemsTabbedView(pinned: pinned, onTap: routeToPinned)

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

// Subview for Dashboard Icons
struct DashboardItemView: View {
    let icon: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text("\(value)")
                .font(.headline)
        }
    }
}

// MARK: - Profile Menu View with Account Navigation
struct ProfileMenuView: View {
    @Binding var isOpen: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Profile Menu")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 20)
                    .padding(.leading)
                
                Divider()
                
                NavigationLink(destination: AccountView()) {  // ✅ Navigate to AccountView
                    Text("Account")
                        .padding()
                }
                
                NavigationLink(destination: SettingsView()) {
                    Text("Settings").padding()
                }
                
                Button(action: { print("Help tapped") }) {
                    Text("Help").padding()
                }
                
                Button(action: { print("Log Out tapped") }) {
                    Text("Log Out")
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.75)
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
            .offset(x: isOpen ? 0 : UIScreen.main.bounds.width * 0.75)
            .animation(.easeInOut(duration: 0.3), value: isOpen)
        }
        .background(Color.black.opacity(isOpen ? 0.3 : 0).edgesIgnoringSafeArea(.all))
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isOpen = false
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

