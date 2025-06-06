import SwiftUI

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

    @State private var spaceToDelete: Space?
    @State private var showDeleteConfirmation = false

    init() { configureNavBarAppearance() }

    var body: some View {
        NavigationStack {
            ZStack {
                BlobbyBackground()
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.spaces) { space in
                            SpaceCardView(
                                space: space,
                                deleteSpace: { confirmDelete(space) },
                                editSpace:   { /* TODO: open your edit‐space sheet here */ }
                            )
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
            .alert(
                "Delete Space?",
                isPresented: $showDeleteConfirmation,
                presenting: spaceToDelete
            ) { space in
                Button("Delete", role: .destructive) { performDelete() }
                Button("Cancel", role: .cancel) { }
            } message: { space in
                Text(
                    "Are you sure you want to delete \"\(space.name)\"? " +
                    "This will also delete all groups, sets, and quick captures inside it."
                )
            }
            .onAppear(perform: viewModel.loadStructure)
        }
        .environmentObject(socialVM)
    }

    // MARK: – Helpers

    private func confirmDelete(_ space: Space) {
        spaceToDelete = space
        showDeleteConfirmation = true
    }

    private func performDelete() {
        guard let space = spaceToDelete else { return }
        APIService.shared.performRequest(
            endpoint: "organizer/spaces/\(space.id)/",  // ← point at the detail view
            method: "DELETE"
        ) { _ in
            DispatchQueue.main.async {
                viewModel.spaces.removeAll { $0.id == space.id }
                spaceToDelete = nil
            }
        }
    }

}

import SwiftUI

struct SpaceCardView: View {
    let space: Space
    var deleteSpace: () -> Void
    var editSpace:   () -> Void

    @State private var groups: [Group]             // ①
    @State private var isExpanded            = false
    @State private var showCreateGroup       = false
    @State private var isPinned: Bool
    @State private var showShareSheet        = false

    // – State for “Delete Group?” alert –
    @State private var groupToDelete: Group?
    @State private var showDeleteGroupAlert  = false

    @EnvironmentObject var socialVM: SocialViewModel

    init(
        space: Space,
        deleteSpace: @escaping () -> Void,
        editSpace:   @escaping () -> Void
    ) {
        self.space       = space
        self.deleteSpace = deleteSpace
        self.editSpace   = editSpace
        self._isPinned   = State(initialValue: space.isPinned)
        self._groups     = State(initialValue: space.groups)  // ②
    }

    var body: some View {
        VStack(spacing: 0) {
            // — Space Header —
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(space.name).font(.headline)
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
                    Menu {
                        Button("Edit")   { editSpace() }
                        Button("Delete", role: .destructive) { deleteSpace() }
                    } label: {
                        Image(systemName: "ellipsis")
                          .rotationEffect(.degrees(90))
                          .font(.title3)
                          .foregroundColor(.primary)
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .onTapGesture { withAnimation { isExpanded.toggle() } }

            // — Groups List (now from `groups`) —
            if isExpanded {
                Divider().padding(.horizontal)

                VStack(spacing: 12) {
                    ForEach(groups, id: \.id) { group in       // ③
                        GroupRowView(
                          group: group,
                          deleteGroup: { confirmDeleteGroup(group) },
                          editGroup:   { /* TODO: edit UI */ }
                        )
                        .environmentObject(socialVM)
                    }

                    Button(action: { showCreateGroup = true }) {
                        Label("New Group", systemImage: "plus")
                          .frame(maxWidth: .infinity)
                          .padding()
                          .background(.ultraThinMaterial)
                          .cornerRadius(12)
                    }
                }
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
                .sheet(isPresented: $showCreateGroup) {
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
        // — Delete Group Confirmation —
        .alert(
          "Delete Group?",
          isPresented: $showDeleteGroupAlert,
          presenting: groupToDelete
        ) { _ in
          Button("Delete", role: .destructive, action: performDeleteGroup)
          Button("Cancel", role: .cancel) { }
        } message: { group in
          Text("Delete “\(group.name)” and all its sets?")
        }
    }

    // MARK: – Group Deletion Helpers

    private func confirmDeleteGroup(_ group: Group) {
        groupToDelete = group
        showDeleteGroupAlert = true
    }

    private func performDeleteGroup() {
        guard let group = groupToDelete else { return }

        APIService.shared.performRequest(
          endpoint: "organizer/groups/\(group.id)/",
          method: "DELETE"
        ) { _ in
          DispatchQueue.main.async {
            // ④ mutate the local copy
            if let idx = groups.firstIndex(where: { $0.id == group.id }) {
              groups.remove(at: idx)
            }
            groupToDelete = nil
          }
        }
    }

    // MARK: – Space Pin Toggle

    private func togglePin() {
        let newState = !isPinned
        isPinned = newState
        APIService.shared.performRequest(
          endpoint: "organizer/toggle-pin/",
          method: "POST",
          body: ["type": "space", "id": space.id]
        ) { result in
          if case .success(let data) = result,
             let resp = try? JSONDecoder().decode([String:String].self, from: data),
             resp["status"] == "pinned" {
            DispatchQueue.main.async { isPinned = true }
          } else {
            DispatchQueue.main.async { isPinned = false }
          }
        }
    }
}


import SwiftUI

struct GroupRowView: View {
    let group: Group
    var deleteGroup: () -> Void
    var editGroup:   () -> Void

    @State private var isPinned = false
    @State private var showShareSheet = false

    @EnvironmentObject var socialVM: SocialViewModel

    init(
        group: Group,
        deleteGroup: @escaping () -> Void,
        editGroup:   @escaping () -> Void
    ) {
        self.group       = group
        self.deleteGroup = deleteGroup
        self.editGroup   = editGroup
        self._isPinned   = State(initialValue: group.isPinned)
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

                Menu {
                    Button("Edit") { editGroup() }
                    Button("Delete", role: .destructive) { deleteGroup() }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
        .sheet(isPresented: $showShareSheet) {
            ShareGroupModal(group: group)
                .environmentObject(socialVM)
        }
    }

    // MARK: – Group Pin Toggle

    private func togglePin() {
        let newState = !isPinned
        isPinned = newState
        APIService.shared.performRequest(
            endpoint: "organizer/toggle-pin/",
            method: "POST",
            body: ["type": "group", "id": group.id]
        ) { result in
            if case .success(let data) = result,
               let resp = try? JSONDecoder().decode([String:String].self, from: data),
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
