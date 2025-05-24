

import SwiftUI

struct QuickCapturesView: View {
    let set: SetItem
    @StateObject private var viewModel = QuickCapturesViewModel()
    @State private var isPracticing = false
    @StateObject private var practiceViewModel = PracticeViewModel()
    @State private var expandedCaptureIDs: Set<Int> = []
    @State private var selectedCapture: QuickCaptureModel?
    @State private var showShareModal = false
    @EnvironmentObject var socialVM: SocialViewModel  // to access friends


    var body: some View {
        VStack {
//            Button(action: {
//                practiceViewModel.loadQuizzesFromSet(setId: set.id)
//                isPracticing = true
//            }) {
//                Text("📝 Practice this Set")
//                    .font(.headline)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal)
            Button(action: {
                practiceViewModel.loadQuizzesFromSet(setId: set.id)
                isPracticing = true
            }) {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Practice this Set")
                }
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 4)
                )
            }
            .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.quickCaptures) { capture in
                        VStack(alignment: .leading, spacing: 10) {
                            NavigationLink(destination: QuickCaptureDetailView(quickCapture: capture)) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(capture.shortDescription ?? "No summary available")
                                        .font(.headline)

                                    if let context = capture.context {
                                        Text(context)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            HStack {
                                Spacer()
                                Button {
                                    selectedCapture = capture
                                    showShareModal = true
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.blue)
                                }
                            }


                            // Expandable content preview with chevron
                            Button(action: {
                                withAnimation {
                                    toggleExpanded(captureID: capture.id)
                                }
                            }) {
                                HStack(alignment: .top) {
                                    Text(capture.content)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .lineLimit(expandedCaptureIDs.contains(capture.id) ? nil : 1)
                                        .multilineTextAlignment(.leading)

                                    Spacer(minLength: 8)

                                    Image(systemName: expandedCaptureIDs.contains(capture.id) ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.blue)
                                        .padding(.top, 2)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
        }
        .background(
            NavigationLink(
                destination: QuizPracticeView()
                    .environmentObject(practiceViewModel),
                isActive: $isPracticing
            ) {
                EmptyView()
            }
            .hidden()
        )
        .navigationTitle(set.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(set.title)
                        .font(.headline)
                    if let description = set.userFacingDescription {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
            }
        }        .onAppear {
            viewModel.loadQuickCaptures(for: set.id)
        }
        .sheet(isPresented: $showShareModal) {
            if let capture = selectedCapture {
                ShareQuickCaptureModal(
                    quickCaptureId: capture.id,
                    quickCaptureTitle: capture.shortDescription ?? "QuickCapture"
                )
                .environmentObject(socialVM)
            }
        }

    }

    private func toggleExpanded(captureID: Int) {
        if expandedCaptureIDs.contains(captureID) {
            expandedCaptureIDs.remove(captureID)
        } else {
            expandedCaptureIDs.insert(captureID)
        }
    }
    
}



struct ShareQuickCaptureModal: View {
    let quickCaptureId: Int
    let quickCaptureTitle: String

    @EnvironmentObject var socialVM: SocialViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedUser: User?
    @State private var selectedPermission = "read_only"
    @State private var isSharing = false
    @State private var errorMessage: String?

    let permissionOptions = [
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
                        ForEach(permissionOptions, id: \.0) { (value, label) in
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
                            Text("Share \"\(quickCaptureTitle)\"")
                        }
                    }
                    .disabled(selectedUser == nil || isSharing)
                }
            }
            .navigationTitle("Share Capture")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func share() async {
        guard let user = selectedUser else { return }
        isSharing = true
        errorMessage = nil

        do {
            let body: [String: Any] = [
                "target_type": "quickcapture",
                "target_id": quickCaptureId,
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
}
