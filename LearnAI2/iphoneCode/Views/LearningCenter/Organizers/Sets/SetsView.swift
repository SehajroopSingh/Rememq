//
//import SwiftUI
//
//struct SetsView: View {
//    let group: Group
//    @State private var showCreateSetSheet = false
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 20) {
//                ForEach(group.sets) { set in
//                    NavigationLink(destination: QuickCapturesView(set: set)) {
//                        SetCardView(set: set)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//            }
//            .padding()
//        }
//        .navigationTitle(group.name)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    showCreateSetSheet = true
//                }) {
//                    Image(systemName: "plus")
//                }
//                .accessibilityLabel("Create New Set")
//            }
//        }
//        .sheet(isPresented: $showCreateSetSheet) {
//            CreateSetView(group: group)
//        }
//    }
//}
//struct SetCardView: View {
//    let set: SetItem
//    @State private var isEditing = false
//    @State private var title: String
//    @State private var userFacingDescription: String
//    @State private var llmDescription: String
//    @State private var masteryTime: String
//    @State private var isPinned: Bool  // ✅ Track pin state
//
//    private let masteryOptions = [
//        "3 days", "1 week", "2 weeks", "3 weeks",
//        "1 month", "3 months", "1 year", "indefinitely"
//    ]
//
//    init(set: SetItem) {
//        self.set = set
//        _title = State(initialValue: set.title)
//        _userFacingDescription = State(initialValue: set.userFacingDescription ?? "")
//        _llmDescription = State(initialValue: set.llmDescription ?? "")
//        _masteryTime = State(initialValue: set.masteryTime)
//        _isPinned = State(initialValue: set.isPinned)  // ✅ Initialize from model
//    }
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            VStack(alignment: .leading, spacing: 8) {
//                if isEditing {
//                    TextField("Set Title", text: $title)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                    TextField("User Description", text: $userFacingDescription)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                    TextField("LLM Description", text: $llmDescription)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                    Picker("Mastery Time", selection: $masteryTime) {
//                        ForEach(masteryOptions, id: \.self) { option in
//                            Text(option.capitalized).tag(option)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//
//                    HStack {
//                        Button("Save") {
//                            updateSet()
//                        }
//                        .buttonStyle(.borderedProminent)
//
//                        Button("Cancel") {
//                            cancelEdit()
//                        }
//                        .buttonStyle(.bordered)
//                        .tint(.red)
//                    }
//                    .padding(.top, 6)
//                } else {
//                    HStack(alignment: .top) {
//                        VStack(alignment: .leading, spacing: 6) {
//                            Text(title)
//                                .font(.headline)
//
//                            Text(userFacingDescription.isEmpty ? "No user-facing description" : userFacingDescription)
//                                .font(.subheadline)
//                                .foregroundColor(userFacingDescription.isEmpty ? .gray : .secondary)
//
//                            Text(llmDescription.isEmpty ? "No LLM description" : llmDescription)
//                                .font(.caption)
//                                .foregroundColor(llmDescription.isEmpty ? .gray.opacity(0.6) : .gray)
//
//                            Text("Mastery Time: \(masteryTime)")
//                                .font(.caption2)
//                                .foregroundColor(.blue)
//                        }
//                        Spacer()
//                        Menu {
//                            Button("Edit Set") {
//                                isEditing = true
//                            }
//                            Divider()
//                            Button("Delete Set", role: .destructive) {
//                                print("Delete Set tapped")
//                            }
//                        } label: {
//                            Image(systemName: "ellipsis")
//                                .rotationEffect(.degrees(90))
//                                .frame(width: 30, height: 30)
//                                .contentShape(Rectangle())
//                                .padding(.leading, 8)
//                        }
//                        .menuStyle(.button)
//                    }
//                }
//            }
//            .padding()
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color(.systemGray5))
//            .cornerRadius(12)
//            .shadow(radius: 2)
//            .padding(.horizontal)
//
//            // ✅ Pin icon floating top-right
//            Button(action: togglePin) {
//                Image(systemName: isPinned ? "star.fill" : "star")
//                    .foregroundColor(isPinned ? .yellow : .gray)
//                    .padding(10)
//            }
//        }
//    }
//
//    private func togglePin() {
//        let newState = !isPinned
//        isPinned = newState
//
//        APIService.shared.performRequest(
//            endpoint: "organizer/toggle-pin/",
//            method: "POST",
//            body: [
//                "type": "set",
//                "id": set.id
//            ]
//        ) { result in
//            switch result {
//            case .success(let data):
//                if let response = try? JSONDecoder().decode([String: String].self, from: data),
//                   let status = response["status"] {
//                    DispatchQueue.main.async {
//                        self.isPinned = (status == "pinned")
//                    }
//                }
//            case .failure(let error):
//                print("❌ Set pin toggle error: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.isPinned = !newState
//                }
//            }
//        }
//    }
//
//    func updateSet() {
//        let payload: [String: Any] = [
//            "id": set.id,
//            "title": title,
//            "user_facing_description": userFacingDescription,
//            "llm_description": llmDescription,
//            "mastery_time": masteryTime,
//            "group": set.group
//        ]
//
//        APIService.shared.performRequest(endpoint: "organizer/sets/\(set.id)/", method: "PUT", body: payload) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    print("✅ Set updated successfully")
//                    isEditing = false
//                case .failure(let error):
//                    print("❌ Failed to update set: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func cancelEdit() {
//        title = set.title
//        userFacingDescription = set.userFacingDescription ?? ""
//        llmDescription = set.llmDescription ?? ""
//        masteryTime = set.masteryTime
//        isEditing = false
//    }
//}
import SwiftUI

// MARK: - Glassy Button Style
struct GlassPinButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
            .shadow(color: .black.opacity(configuration.isPressed ? 0 : 0.25), radius: 12, x: 0, y: 6)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Glass Card Modifier
struct GlassCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial.opacity(0.8))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.2)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
    }
}

// MARK: - SetsView
struct SetsView: View {
    let group: Group
    @State private var showCreateSetSheet = false
    @EnvironmentObject var socialVM: SocialViewModel



    var body: some View {
        NavigationStack {
            ZStack {
                BlobbyBackground().ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(group.sets) { set in
                            NavigationLink(destination: QuickCapturesView(set: set)) {
                                SetCardView(set: set)
                                    .environmentObject(socialVM)                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(group.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showCreateSetSheet = true } label: {
                        Image(systemName: "plus").font(.title2)
                    }
                    .buttonStyle(GlassPinButtonStyle())
                }
            }
            .sheet(isPresented: $showCreateSetSheet) {
                CreateSetView(group: group).presentationDetents([.medium, .large])
            }
        }
    }
}

// MARK: - SetCardView
struct SetCardView: View {
    let set: SetItem
    @State private var isEditing = false
    @State private var title: String
    @State private var userFacingDescription: String
    @State private var llmDescription: String
    @State private var masteryTime: String
    @State private var isPinned: Bool
    @State private var showShareSheet = false
    @EnvironmentObject var socialVM: SocialViewModel   // ✅ Add this line



    private let masteryOptions = [
        "3 days", "1 week", "2 weeks", "3 weeks",
        "1 month", "3 months", "1 year", "indefinitely"
    ]

    init(set: SetItem) {
        self.set = set
        _title = State(initialValue: set.title)
        _userFacingDescription = State(initialValue: set.userFacingDescription ?? "")
        _llmDescription = State(initialValue: set.llmDescription ?? "")
        _masteryTime = State(initialValue: set.masteryTime)
        _isPinned = State(initialValue: set.isPinned)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    if !userFacingDescription.isEmpty {
                        Text(userFacingDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                HStack(spacing: 12) {
                    Button(action: { showShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(GlassPinButtonStyle())
                    .sheet(isPresented: $showShareSheet) {
                        ShareSetModal(set: set)
                            .environmentObject(socialVM)  // if you're using socialVM in the modal
                    }

                    // Favorite button
                    Button(action: togglePin) {
                        Image(systemName: isPinned ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundColor(isPinned ? .yellow : .white)
                    }
                    .buttonStyle(GlassPinButtonStyle())

                    // Dropdown menu
                    Menu {
                        Button("Edit Set") { isEditing = true }
                        Divider()
                        Button("Delete Set", role: .destructive) {
                            // handle delete
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.title3)
                            .padding(8)
                    }
                    .buttonStyle(GlassPinButtonStyle())
                }
            }

            if isEditing {
                editFields
            } else {
                Text(llmDescription)
                    .font(.callout)
                    .foregroundColor(.gray)
                Text("Mastery in: \(masteryTime)")
                    .font(.caption)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        }
        .padding(20)
        .modifier(GlassCardStyle())
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var editFields: some View {
        VStack(spacing: 16) {
            TextField("Set Title", text: $title)
                .textFieldStyle(.roundedBorder)
            TextField("User Description", text: $userFacingDescription)
                .textFieldStyle(.roundedBorder)
            TextField("LLM Description", text: $llmDescription)
                .textFieldStyle(.roundedBorder)
            Picker("Mastery Time", selection: $masteryTime) {
                ForEach(masteryOptions, id: \.self) { option in
                    Text(option.capitalized).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())

            HStack(spacing: 12) {
                Button("Save") { updateSet() }
                    .buttonStyle(.borderedProminent)
                Button("Cancel", role: .cancel) { cancelEdit() }
                    .buttonStyle(.bordered)
            }
        }
    }

    // MARK: - Actions
    private func togglePin() {
        let newState = !isPinned
        isPinned = newState
        APIService.shared.performRequest(
            endpoint: "organizer/toggle-pin/", method: "POST",
            body: ["type": "set", "id": set.id]
        ) { result in
            if case .success(let data) = result,
               let resp = try? JSONDecoder().decode([String:String].self, from: data),
               let status = resp["status"] {
                DispatchQueue.main.async { isPinned = (status == "pinned") }
            } else {
                DispatchQueue.main.async { isPinned.toggle() }
            }
        }
    }

    private func updateSet() {
        let payload: [String:Any] = [
            "id": set.id,
            "title": title,
            "user_facing_description": userFacingDescription,
            "llm_description": llmDescription,
            "mastery_time": masteryTime,
            "group": set.group
        ]
        APIService.shared.performRequest(
            endpoint: "organizer/sets/\(set.id)/", method: "PUT", body: payload
        ) { result in
            DispatchQueue.main.async { if case .success = result { isEditing = false } }
        }
    }

    private func cancelEdit() {
        title = set.title
        userFacingDescription = set.userFacingDescription ?? ""
        llmDescription = set.llmDescription ?? ""
        masteryTime = set.masteryTime
        isEditing = false
    }
}
struct ShareSetModal: View {
    let set: SetItem
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
                    Section {
                        Text(error).foregroundColor(.red)
                    }
                }

                Section {
                    Button {
                        Task { await shareSet() }
                    } label: {
                        if isSharing {
                            ProgressView()
                        } else {
                            Text("Share \"\(set.title)\"")
                        }
                    }
                    .disabled(selectedUser == nil || isSharing)
                }
            }
            .navigationTitle("Share Set")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func shareSet() async {
        guard let user = selectedUser else { return }
        isSharing = true
        errorMessage = nil

        do {
            let body: [String: Any] = [
                "target_type": "set",
                "target_id": set.id,
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
            errorMessage = "Failed to share set. Try again."
        }

        isSharing = false
    }
}
