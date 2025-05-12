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
//
//struct SetCardView: View {
//    let set: SetItem
//    @State private var isEditing = false
//    @State private var title: String
//    @State private var userFacingDescription: String
//    @State private var llmDescription: String
//
//    init(set: SetItem) {
//        self.set = set
//        _title = State(initialValue: set.title)
//        _userFacingDescription = State(initialValue: set.userFacingDescription ?? "")
//        _llmDescription = State(initialValue: set.llmDescription ?? "")
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            if isEditing {
//                TextField("Set Title", text: $title)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                TextField("User Description", text: $userFacingDescription)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                TextField("LLM Description", text: $llmDescription)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                HStack {
//                    Button("Save") {
//                        updateSet()
//                    }
//                    .buttonStyle(.borderedProminent)
//
//                    Button("Cancel") {
//                        cancelEdit()
//                    }
//                    .buttonStyle(.bordered)
//                    .tint(.red)
//                }
//                .padding(.top, 6)
//            } else {
//                HStack(alignment: .top) {
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text(title)
//                            .font(.headline)
//
//                        Text(userFacingDescription.isEmpty ? "No user-facing description" : userFacingDescription)
//                            .font(.subheadline)
//                            .foregroundColor(userFacingDescription.isEmpty ? .gray : .secondary)
//
//                        Text(llmDescription.isEmpty ? "No LLM description" : llmDescription)
//                            .font(.caption)
//                            .foregroundColor(llmDescription.isEmpty ? .gray.opacity(0.6) : .gray)
//                    }
//                    Spacer()
//                    Menu {
//                        Button("Edit Set") {
//                            isEditing = true
//                        }
//                        Divider()
//                        Button("Delete Set", role: .destructive) {
//                            print("Delete Set tapped")
//                        }
//                    } label: {
//                        Image(systemName: "ellipsis")
//                            .rotationEffect(.degrees(90))
//                            .frame(width: 30, height: 30)
//                            .contentShape(Rectangle())
//                            .padding(.leading, 8)
//                    }
//                    .menuStyle(.button)
//                }
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color(.systemGray5))
//        .cornerRadius(12)
//        .shadow(radius: 2)
//        .padding(.horizontal)
//    }
//
//    func updateSet() {
//        let payload: [String: Any] = [
//            "id": set.id,
//            "title": title,
//            "user_facing_description": userFacingDescription,
//            "llm_description": llmDescription,
//            "mastery_time": set.masteryTime,
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
//        isEditing = false
//    }
//}
import SwiftUI

struct SetsView: View {
    let group: Group
    @State private var showCreateSetSheet = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(group.sets) { set in
                    NavigationLink(destination: QuickCapturesView(set: set)) {
                        SetCardView(set: set)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showCreateSetSheet = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Create New Set")
            }
        }
        .sheet(isPresented: $showCreateSetSheet) {
            CreateSetView(group: group)
        }
    }
}
//
//struct SetCardView: View {
//    let set: SetItem
//    @State private var isEditing = false
//    @State private var title: String
//    @State private var userFacingDescription: String
//    @State private var llmDescription: String
//    @State private var masteryTime: String
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
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            if isEditing {
//                TextField("Set Title", text: $title)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                TextField("User Description", text: $userFacingDescription)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                TextField("LLM Description", text: $llmDescription)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                Picker("Mastery Time", selection: $masteryTime) {
//                    ForEach(masteryOptions, id: \.self) { option in
//                        Text(option.capitalized).tag(option)
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
//
//                HStack {
//                    Button("Save") {
//                        updateSet()
//                    }
//                    .buttonStyle(.borderedProminent)
//
//                    Button("Cancel") {
//                        cancelEdit()
//                    }
//                    .buttonStyle(.bordered)
//                    .tint(.red)
//                }
//                .padding(.top, 6)
//            } else {
//                HStack(alignment: .top) {
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text(title)
//                            .font(.headline)
//
//                        Text(userFacingDescription.isEmpty ? "No user-facing description" : userFacingDescription)
//                            .font(.subheadline)
//                            .foregroundColor(userFacingDescription.isEmpty ? .gray : .secondary)
//
//                        Text(llmDescription.isEmpty ? "No LLM description" : llmDescription)
//                            .font(.caption)
//                            .foregroundColor(llmDescription.isEmpty ? .gray.opacity(0.6) : .gray)
//
//                        Text("Mastery Time: \(masteryTime)")
//                            .font(.caption2)
//                            .foregroundColor(.blue)
//                    }
//                    Spacer()
//                    Menu {
//                        Button("Edit Set") {
//                            isEditing = true
//                        }
//                        Divider()
//                        Button("Delete Set", role: .destructive) {
//                            print("Delete Set tapped")
//                        }
//                    } label: {
//                        Image(systemName: "ellipsis")
//                            .rotationEffect(.degrees(90))
//                            .frame(width: 30, height: 30)
//                            .contentShape(Rectangle())
//                            .padding(.leading, 8)
//                    }
//                    .menuStyle(.button)
//                }
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color(.systemGray5))
//        .cornerRadius(12)
//        .shadow(radius: 2)
//        .padding(.horizontal)
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
struct SetCardView: View {
    let set: SetItem
    @State private var isEditing = false
    @State private var title: String
    @State private var userFacingDescription: String
    @State private var llmDescription: String
    @State private var masteryTime: String
    @State private var isPinned: Bool  // ✅ Track pin state

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
        _isPinned = State(initialValue: set.isPinned)  // ✅ Initialize from model
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                if isEditing {
                    TextField("Set Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("User Description", text: $userFacingDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("LLM Description", text: $llmDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Mastery Time", selection: $masteryTime) {
                        ForEach(masteryOptions, id: \.self) { option in
                            Text(option.capitalized).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    HStack {
                        Button("Save") {
                            updateSet()
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Cancel") {
                            cancelEdit()
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                    .padding(.top, 6)
                } else {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(title)
                                .font(.headline)

                            Text(userFacingDescription.isEmpty ? "No user-facing description" : userFacingDescription)
                                .font(.subheadline)
                                .foregroundColor(userFacingDescription.isEmpty ? .gray : .secondary)

                            Text(llmDescription.isEmpty ? "No LLM description" : llmDescription)
                                .font(.caption)
                                .foregroundColor(llmDescription.isEmpty ? .gray.opacity(0.6) : .gray)

                            Text("Mastery Time: \(masteryTime)")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Menu {
                            Button("Edit Set") {
                                isEditing = true
                            }
                            Divider()
                            Button("Delete Set", role: .destructive) {
                                print("Delete Set tapped")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .frame(width: 30, height: 30)
                                .contentShape(Rectangle())
                                .padding(.leading, 8)
                        }
                        .menuStyle(.button)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding(.horizontal)

            // ✅ Pin icon floating top-right
            Button(action: togglePin) {
                Image(systemName: isPinned ? "star.fill" : "star")
                    .foregroundColor(isPinned ? .yellow : .gray)
                    .padding(10)
            }
        }
    }

    private func togglePin() {
        let newState = !isPinned
        isPinned = newState

        APIService.shared.performRequest(
            endpoint: "organizer/toggle-pin/",
            method: "POST",
            body: [
                "type": "set",
                "id": set.id
            ]
        ) { result in
            switch result {
            case .success(let data):
                if let response = try? JSONDecoder().decode([String: String].self, from: data),
                   let status = response["status"] {
                    DispatchQueue.main.async {
                        self.isPinned = (status == "pinned")
                    }
                }
            case .failure(let error):
                print("❌ Set pin toggle error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isPinned = !newState
                }
            }
        }
    }

    func updateSet() {
        let payload: [String: Any] = [
            "id": set.id,
            "title": title,
            "user_facing_description": userFacingDescription,
            "llm_description": llmDescription,
            "mastery_time": masteryTime,
            "group": set.group
        ]

        APIService.shared.performRequest(endpoint: "organizer/sets/\(set.id)/", method: "PUT", body: payload) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Set updated successfully")
                    isEditing = false
                case .failure(let error):
                    print("❌ Failed to update set: \(error.localizedDescription)")
                }
            }
        }
    }

    func cancelEdit() {
        title = set.title
        userFacingDescription = set.userFacingDescription ?? ""
        llmDescription = set.llmDescription ?? ""
        masteryTime = set.masteryTime
        isEditing = false
    }
}
