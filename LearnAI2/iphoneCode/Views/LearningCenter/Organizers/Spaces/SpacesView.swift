
import SwiftUI

/// Configure nav bar appearance globally
func configureNavBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = .clear
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}

struct SpacesView: View {
    @StateObject private var viewModel = StructureViewModel()
    @State private var showCreateSpaceSheet = false

    init() { configureNavBarAppearance() }

    var body: some View {
        NavigationStack {
            ZStack {
                BlobbyBackground()
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.spaces) { space in
                            SpaceCardView(space: space)
                        }
                    }
                    .padding([.horizontal, .top], 16)
                }
            }
            .navigationTitle("My Spaces")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showCreateSpaceSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateSpaceSheet) {
                CreateSpaceView()
                    .presentationDetents([.medium, .large])
            }
            .onAppear(perform: viewModel.loadStructure)
        }
    }
}

struct SpaceCardView: View {
    let space: Space
    @State private var isExpanded = false
    @State private var showCreateGroupSheet = false
    @State private var isPinned: Bool

    init(space: Space) {
        self.space = space
        self._isPinned = State(initialValue: space.isPinned)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(space.name)
                        .font(.headline)
                    if let desc = space.userFacingDescription, !desc.isEmpty {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Button(action: togglePin) {
                    Image(systemName: isPinned ? "star.fill" : "star")
                        .font(.title3)
                        .foregroundColor(isPinned ? .yellow : .gray)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .onTapGesture { withAnimation { isExpanded.toggle() } }

            if isExpanded {
                Divider()
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    ForEach(space.groups, id: \.id) { group in
                        GroupRowView(group: group)
                    }

                    Button(action: { showCreateGroupSheet = true }) {
                        Label("New Group", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
                .sheet(isPresented: $showCreateGroupSheet) {
                    CreateGroupView(space: space)
                        .presentationDetents([.medium])
                }
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }

    private func togglePin() {
        let newState = !isPinned
        isPinned = newState
        APIService.shared.performRequest(
            endpoint: "organizer/toggle-pin/",
            method: "POST",
            body: ["type": "space", "id": space.id]
        ) { result in
            if case .success(let data) = result,
               let response = try? JSONDecoder().decode([String: String].self, from: data),
               let status = response["status"] {
                DispatchQueue.main.async { isPinned = (status == "pinned") }
            } else {
                DispatchQueue.main.async { isPinned = !newState }
            }
        }
    }
}

struct GroupRowView: View {
    let group: Group
    @State private var isPinned: Bool

    init(group: Group) {
        self.group = group
        self._isPinned = State(initialValue: group.isPinned)
    }

    var body: some View {
        HStack {
            NavigationLink(destination: SetsView(group: group)) {
                Text(group.name)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: togglePin) {
                Image(systemName: isPinned ? "star.fill" : "star")
                    .foregroundColor(isPinned ? .yellow : .gray)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 1)
    }

    private func togglePin() {
        let newState = !isPinned
        isPinned = newState
        APIService.shared.performRequest(
            endpoint: "organizer/toggle-pin/",
            method: "POST",
            body: ["type": "group", "id": group.id]
        ) { result in
            if case .success(let data) = result,
               let response = try? JSONDecoder().decode([String: String].self, from: data),
               let status = response["status"] {
                DispatchQueue.main.async { isPinned = (status == "pinned") }
            } else {
                DispatchQueue.main.async { isPinned = !newState }
            }
        }
    }
}

//
//
//import SwiftUI
//
///// Configure nav bar appearance globally
//func configureNavBarAppearance() {
//    let appearance = UINavigationBarAppearance()
//    appearance.configureWithTransparentBackground()
//    appearance.backgroundColor = .clear
//    UINavigationBar.appearance().standardAppearance = appearance
//    UINavigationBar.appearance().scrollEdgeAppearance = appearance
//}
//
//// MARK: - Custom Styles
//// 3D press animation button style
//struct PressableButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
//            .rotation3DEffect(
//                .degrees(configuration.isPressed ? 5 : 0),
//                axis: (x: 1, y: 0, z: 0)
//            )
//            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: configuration.isPressed)
//    }
//}
//
//// Glassy, modern pin button
//struct GlassyIconButton: View {
//    let systemName: String
//    let isToggled: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Image(systemName: systemName)
//                .font(.title3)
//                .foregroundStyle(
//                    LinearGradient(
//                        gradient: Gradient(colors: isToggled
//                                            ? [Color.yellow, Color.orange]
//                                            : [Color.gray.opacity(0.6), Color.gray.opacity(0.3)]
//                        ),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                )
//                .padding(8)
//                .background(.ultraThinMaterial)
//                .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                )
//                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
//        }
//        .buttonStyle(PressableButtonStyle())
//    }
//}
//
//struct SpacesView: View {
//    @StateObject private var viewModel = StructureViewModel()
//    @State private var showCreateSpaceSheet = false
//
//    init() { configureNavBarAppearance() }
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                BlobbyBackground()
//                    .ignoresSafeArea()
//
//                ScrollView {
//                    LazyVStack(spacing: 20) {
//                        ForEach(viewModel.spaces) { space in
//                            SpaceCardView(space: space)
//                        }
//                    }
//                    .padding([.horizontal, .top], 16)
//                }
//            }
//            .navigationTitle("My Spaces")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button { showCreateSpaceSheet = true } label: {
//                        Image(systemName: "plus")
//                    }
//                    .buttonStyle(PressableButtonStyle())
//                }
//            }
//            .sheet(isPresented: $showCreateSpaceSheet) {
//                CreateSpaceView()
//                    .presentationDetents([.medium, .large])
//            }
//            .onAppear(perform: viewModel.loadStructure)
//        }
//    }
//}
//
//struct SpaceCardView: View {
//    let space: Space
//    @State private var isExpanded = false
//    @State private var showCreateGroupSheet = false
//    @State private var isPinned: Bool
//
//    init(space: Space) {
//        self.space = space
//        self._isPinned = State(initialValue: space.isPinned)
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            HStack {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(space.name)
//                        .font(.headline)
//                    if let desc = space.userFacingDescription, !desc.isEmpty {
//                        Text(desc)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                }
//                Spacer()
//                GlassyIconButton(
//                    systemName: isPinned ? "star.fill" : "star",
//                    isToggled: isPinned,
//                    action: togglePin
//                )
//            }
//            .padding()
//            .background(.ultraThinMaterial)
//            .cornerRadius(16)
//            .onTapGesture { withAnimation { isExpanded.toggle() } }
//
//            if isExpanded {
//                Divider()
//                    .padding(.horizontal)
//
//                VStack(spacing: 12) {
//                    ForEach(space.groups, id: \.id) { group in
//                        GroupRowView(group: group)
//                    }
//
//                    Button(action: { showCreateGroupSheet = true }) {
//                        Label("New Group", systemImage: "plus")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(.ultraThinMaterial)
//                            .cornerRadius(12)
//                    }
//                    .buttonStyle(PressableButtonStyle())
//                    .sheet(isPresented: $showCreateGroupSheet) {
//                        CreateGroupView(space: space)
//                            .presentationDetents([.medium])
//                    }
//                }
//                .padding()
//                .transition(.move(edge: .top).combined(with: .opacity))
//            }
//        }
//        .background(.ultraThinMaterial)
//        .cornerRadius(16)
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(Color.white.opacity(0.3), lineWidth: 1)
//        )
//        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
//    }
//
//    private func togglePin() {
//        let newState = !isPinned
//        isPinned = newState
//        APIService.shared.performRequest(
//            endpoint: "organizer/toggle-pin/", method: "POST", body: ["type": "space", "id": space.id]
//        ) { result in
//            if case .success(let data) = result,
//               let response = try? JSONDecoder().decode([String: String].self, from: data),
//               let status = response["status"] {
//                DispatchQueue.main.async { isPinned = (status == "pinned") }
//            } else {
//                DispatchQueue.main.async { isPinned = !newState }
//            }
//        }
//    }
//}
//
//struct GroupRowView: View {
//    let group: Group
//    @State private var isPinned: Bool
//
//    init(group: Group) {
//        self.group = group
//        self._isPinned = State(initialValue: group.isPinned)
//    }
//
//    var body: some View {
//        HStack {
//            NavigationLink(destination: SetsView(group: group)) {
//                Text(group.name)
//                    .font(.body)
//                    .foregroundColor(.primary)
//            }
//            Spacer()
//            GlassyIconButton(
//                systemName: isPinned ? "star.fill" : "star",
//                isToggled: isPinned,
//                action: togglePin
//            )
//        }
//        .padding()
//        .background(.ultraThinMaterial)
//        .cornerRadius(12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.white.opacity(0.3), lineWidth: 1)
//        )
//        .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 1)
//    }
//
//    private func togglePin() {
//        let newState = !isPinned
//        isPinned = newState
//        APIService.shared.performRequest(
//            endpoint: "organizer/toggle-pin/", method: "POST", body: ["type": "group", "id": group.id]
//        ) { result in
//            if case .success(let data) = result,
//               let response = try? JSONDecoder().decode([String: String].self, from: data),
//               let status = response["status"] {
//                DispatchQueue.main.async { isPinned = (status == "pinned") }
//            } else {
//                DispatchQueue.main.async { isPinned = !newState }
//            }
//        }
//    }
//}
