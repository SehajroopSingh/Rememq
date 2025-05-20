struct SharedContentView: View {
    @StateObject private var viewModel = SharedContentViewModel()

    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading shared content...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                List {
                    if !viewModel.sharedSpaces.isEmpty {
                        Section(header: Text("Shared Spaces")) {
                            ForEach(viewModel.sharedSpaces) { space in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(space.name).bold()
                                    Text("Shared by: \(space.sharedBy ?? "Unknown")").font(.caption)
                                    ForEach(space.groups) { group in
                                        Text("↳ \(group.name)").padding(.leading)
                                        ForEach(group.sets) { set in
                                            Text("  ↳ \(set.title)").padding(.leading, 16)
                                            ForEach(set.quickCaptures) { qc in
                                                Text("    • \(qc.shortDescription ?? "Untitled")")
                                                    .font(.caption)
                                                    .padding(.leading, 24)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if !viewModel.sharedGroups.isEmpty {
                        Section(header: Text("Shared Groups")) {
                            ForEach(viewModel.sharedGroups) { group in
                                VStack(alignment: .leading) {
                                    Text(group.name).bold()
                                    Text("Shared by: \(group.sharedBy ?? "Unknown")").font(.caption)
                                    ForEach(group.sets) { set in
                                        Text("↳ \(set.title)").padding(.leading)
                                        ForEach(set.quickCaptures) { qc in
                                            Text("  • \(qc.shortDescription ?? "Untitled")")
                                                .font(.caption)
                                                .padding(.leading, 16)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if !viewModel.sharedSets.isEmpty {
                        Section(header: Text("Shared Sets")) {
                            ForEach(viewModel.sharedSets) { set in
                                VStack(alignment: .leading) {
                                    Text(set.title).bold()
                                    Text("Shared by: \(set.sharedBy ?? "Unknown")").font(.caption)
                                    ForEach(set.quickCaptures) { qc in
                                        Text("• \(qc.shortDescription ?? "Untitled")")
                                            .font(.caption)
                                            .padding(.leading)
                                    }
                                }
                            }
                        }
                    }

                    if !viewModel.sharedQuickCaptures.isEmpty {
                        Section(header: Text("Shared QuickCaptures")) {
                            ForEach(viewModel.sharedQuickCaptures) { qc in
                                VStack(alignment: .leading) {
                                    Text(qc.shortDescription ?? "Untitled").bold()
                                    if let sharer = qc.sharedBy {
                                        Text("Shared by: \(sharer)").font(.caption)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Shared With Me")
            }
        }
        .onAppear {
            viewModel.fetchSharedContent()
        }
    }
}
