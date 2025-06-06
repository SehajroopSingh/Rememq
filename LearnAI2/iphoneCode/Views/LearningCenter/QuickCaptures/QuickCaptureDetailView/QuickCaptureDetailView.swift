struct QuickCaptureDetailView: View {
    let quickCapture: QuickCaptureModel
    @StateObject private var viewModel = QuickCaptureDetailViewModel()

    var body: some View {
        ZStack {
            BlobbyBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // 🔹 Summary
                    Text(quickCapture.shortDescription ?? "No summary available")
                        .font(.title2).bold()

                    // 🔹 Classification
                    if let classification = quickCapture.classification {
                        Text(classification.capitalized)
                          .font(.caption)
                          .padding(6)
                          .background(Color.blue.opacity(0.1))
                          .cornerRadius(8)
                          .foregroundColor(.blue)
                    }

                    // ─── UltraThin Info Card ───
                    VStack(alignment: .leading, spacing: 12) {
                        // Section 1: Context
                        if let context = quickCapture.context {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Context").font(.headline)
                                Text(context).foregroundColor(.secondary).font(.body)
                            }
                        }

                        Divider()

                        // Section 2: Full Content
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Full Content").font(.headline)
                            NavigationLink(destination: FullContentView(content: quickCapture.content)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(quickCapture.content)
                                      .font(.body)
                                      .lineLimit(4)
                                      .foregroundColor(.primary)

                                    HStack(spacing: 4) {
                                        Text("Read more")
                                          .font(.caption)
                                          .foregroundColor(.blue)
                                        Image(systemName: "chevron.right")
                                          .font(.caption)
                                          .foregroundColor(.blue)
                                    }
                                }
                            }
                        }

                        Divider()

                        // Section 3: Highlights
                        if !quickCapture.highlightedSections.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Highlights").font(.headline)
                                ForEach(quickCapture.highlightedSections, id: \.self) { section in
                                    Text("• \(section)").font(.body)
                                }
                            }
                        }

                        Divider()

                        // Section 4: Metadata
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 12) {
                                Text("Mastery Time"); Divider().frame(height: 16)
                                Text("Depth"); Divider().frame(height: 16)
                                Text("Created")
                            }
                            .font(.caption).foregroundColor(.gray)

                            Divider()

                            HStack(spacing: 12) {
                                Text(quickCapture.masteryTime)
                                Divider().frame(height: 16)
                                Text(quickCapture.depthOfLearning.capitalized)
                                Divider().frame(height: 16)
                                Text(formatDateToDayMonthYear(quickCapture.createdAt))
                            }
                            .font(.footnote)
                        }

                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)

                    Divider()

                    // 🔹 Quizzes Section
                    Text("Quizzes").font(.headline)

                    if let err = viewModel.errorMessage {
                        Text("Error: \(err)").foregroundColor(.red)
                    } else if viewModel.directQuizzes.isEmpty && viewModel.mainPointsWithQuizzes.isEmpty {
                        Text("No quizzes found.").italic()
                    } else {
                        // ➊ Direct (“General”) Quizzes
                        if !viewModel.directQuizzes.isEmpty {
                            DirectQuizzesView(directQuizzes: viewModel.directQuizzes)
                        }

                        // ➋ Main points with nested details
                        ForEach(viewModel.mainPointsWithQuizzes) { mp in
                            MainPointDetailView(mp: mp)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .background(Color.clear)
            .navigationTitle("Quick Capture Details")
            .onAppear {
                viewModel.loadQuizzes(for: quickCapture.id)
            }
        }
    }
}
