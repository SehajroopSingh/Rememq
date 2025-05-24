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
    @EnvironmentObject var socialVM: SocialViewModel
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
                                .environmentObject(socialVM)
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
        .environmentObject(socialVM)
    }
}

struct SpaceCardView: View {
    let space: Space
    @State private var isExpanded = false
    @State private var showCreateGroupSheet = false
    @State private var isPinned: Bool
    @State private var showShareSheet = false

    @EnvironmentObject var socialVM: SocialViewModel

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
                HStack(spacing: 12) {
                    Button(action: togglePin) {
                        Image(systemName: isPinned ? "star.fill" : "star")
                            .font(.title3)
                            .foregroundColor(isPinned ? .yellow : .gray)
                    }
                    Button(action: { showShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
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
                            .environmentObject(socialVM)
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
        .sheet(isPresented: $showShareSheet) {
            ShareSpaceModal(space: space)
                .environmentObject(socialVM)
        }
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
    @State private var showShareSheet = false

    @EnvironmentObject var socialVM: SocialViewModel

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
            HStack(spacing: 12) {
                Button(action: togglePin) {
                    Image(systemName: isPinned ? "star.fill" : "star")
                        .foregroundColor(isPinned ? .yellow : .gray)
                }
                Button(action: { showShareSheet = true }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(Color.white.opacity(0.3), lineWidth: 1))
        .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
        .sheet(isPresented: $showShareSheet) {
            ShareGroupModal(group: group)
                .environmentObject(socialVM)
        }
    }

    private func togglePin() {
        let newState = !isPinned
        isPinned = newState
        APIService.shared.performRequest(
            endpoint: "organizer/toggle-pin/", method: "POST",
            body: ["type": "group", "id": group.id]
        ) { result in
            if case .success(let data) = result,
               let resp = try? JSONDecoder().decode([String: String].self, from: data),
               resp["status"] == "pinned" {
                DispatchQueue.main.async { isPinned = true }
            } else {
                DispatchQueue.main.async { isPinned = false }
            }
        }
    }
}

struct ShareSpaceModal: View {
    let space: Space

    @EnvironmentObject var socialVM: SocialViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedUser: User?
    @State private var selectedPermission = "read_only"
    @State private var isSharing = false
    @State private var errorMessage: String?
    
    @State private var sharedAccessList: [SharedAccessEntry] = []


    let permissionOptions = [
        ("read_only", "Read Only"),
        ("add_only", "Add Only"),
        ("edit", "Edit"),
        ("admin", "Admin")
    ]

    var body: some View {
        NavigationView {
            Form {
                
                if !sharedAccessList.isEmpty {
                    Section(header: Text("Already Shared With")) {
                        ForEach(sharedAccessList.indices, id: \.self) { index in
                            let entry = sharedAccessList[index]
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(entry.user.username)
                                        .font(.subheadline)
                                    Text("Invited by \(entry.invitedBy.username)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Menu {
                                    ForEach(permissionOptions, id: \.0) { level, label in
                                        Button {
                                            updatePermissionAndUpdateList(user: entry.user, to: level, at: index)
                                        } label: {
                                            Text(label)
                                        }
                                    }

                                    Divider()

                                    Button(role: .destructive) {
                                        Task {
                                            await removeAccess(for: entry.user)
                                            sharedAccessList.remove(at: index)
                                        }
                                    } label: {
                                        Text("Remove Access")
                                    }

                                } label: {
                                    Text(permissionLabel(for: entry.permissionLevel))
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .padding(6)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Friend")) {
                    Picker("Select a Friend", selection: $selectedUser) {
                        ForEach(socialVM.friends) { user in
                            Text(user.username).tag(Optional(user))
                        }
                    }
                }

                Section(header: Text("Permission")) {
                    Picker("Permission", selection: $selectedPermission) {
                        ForEach(permissionOptions, id: \.0) { value, label in
                            Text(label).tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if let error = errorMessage {
                    Section {
                        Text(error).foregroundColor(.red)
                    }
                }

                Section {
                    Button {
                        Task { await share() }
                    } label: {
                        if isSharing {
                            ProgressView()
                        } else {
                            Text("Share \"\(space.name)\"")
                        }
                    }
                    .disabled(selectedUser == nil || isSharing)
                }
            }
            .navigationTitle("Share Space")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .onAppear {
            Task { await fetchSharedAccess() }
        }

    }
    func permissionLabel(for code: String) -> String {
        switch code {
        case "read_only": return "Read Only"
        case "add_only": return "Add Only"
        case "edit": return "Can Edit"
        case "admin": return "Admin"
        default: return code.capitalized
        }
    }

    private func share() async {
        guard let user = selectedUser else { return }
        isSharing = true
        errorMessage = nil

        do {
            let body: [String: Any] = [
                "target_type": "space",
                "target_id": space.id,
                "target_username": user.username,
                "permission_level": selectedPermission
            ]

            _ = try await APIService.shared.request(
                endpoint: "organizer/share_object/",
                method: "PATCH",
                body: body
            )

            dismiss()
        } catch {
            errorMessage = "Failed to share. Try again."
        }

        isSharing = false
    }
    
    func fetchSharedAccess() async {
        do {
            let url = "organizer/shared_access/?target_type=space&target_id=\(space.id)"
            let data = try await APIService.shared.request(endpoint: url)
            let decoded = try JSONDecoder().decode([SharedAccessEntry].self, from: data)
            DispatchQueue.main.async {
                sharedAccessList = decoded
            }
        } catch {
            print("Failed to fetch shared access:", error)
        }
    }
    func updatePermissionAndUpdateList(user: User, to level: String, at index: Int) {
        Task {
            await updatePermission(for: user, to: level)
            DispatchQueue.main.async {
                sharedAccessList[index].permissionLevel = level
            }
        }
    }

    func updatePermission(for user: User, to level: String) async {
        let body: [String: Any] = [
            "target_type": "space",
            "target_id": space.id,
            "target_username": user.username,
            "permission_level": level
        ]
        do {
            _ = try await APIService.shared.request(
                endpoint: "organizer/share_object/",
                method: "PATCH",
                body: body
            )
        } catch {
            print("Failed to update permission:", error)
        }
    }

    func removeAccess(for user: User) async {
        let body: [String: Any] = [
            "target_type": "space",
            "target_id": space.id,
            "target_username": user.username
        ]
        do {
            _ = try await APIService.shared.request(
                endpoint: "organizer/remove_shared_access/",
                method: "DELETE",
                body: body
            )
        } catch {
            print("Failed to remove access:", error)
        }
    }


}

struct ShareGroupModal: View {
    let group: Group
    @EnvironmentObject var socialVM: SocialViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedUser: User?
    @State private var selectedPermission = "read_only"
    @State private var isSharing = false
    @State private var errorMessage: String?

    private let permissionOptions = [
        ("read_only", "Read Only"),
        ("add_only", "Add Only"),
        ("edit", "Edit"),
        ("admin", "Admin")
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Friend")) {
                    Picker("Select a Friend", selection: $selectedUser) {
                        ForEach(socialVM.friends) { user in
                            Text(user.username).tag(Optional(user))
                        }
                    }
                }
                Section(header: Text("Permission")) {
                    Picker("Permission", selection: $selectedPermission) {
                        ForEach(permissionOptions, id: \.0) { value, label in
                            Text(label).tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                if let error = errorMessage {
                    Section { Text(error).foregroundColor(.red) }
                }
                Section {
                    Button(action: { Task { await shareGroup() } }) {
                        if isSharing { ProgressView() }
                        else { Text("Share \"\(group.name)\"") }
                    }
                    .disabled(selectedUser == nil || isSharing)
                }
            }
            .navigationTitle("Share Group")
            .toolbar { ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }}
        }
    }

    private func shareGroup() async {
        guard let user = selectedUser else { return }
        isSharing = true; errorMessage = nil
        do {
            let body: [String: Any] = [
                "target_type": "group",
                "target_id": group.id,
                "target_username": user.username,
                "permission_level": selectedPermission
            ]
            _ = try await APIService.shared.request(
                endpoint: "organizer/share_object/", method: "PATCH", body: body)
            dismiss()
        } catch {
            errorMessage = "Failed to share group. Try again."
        }
        isSharing = false
    }
}
