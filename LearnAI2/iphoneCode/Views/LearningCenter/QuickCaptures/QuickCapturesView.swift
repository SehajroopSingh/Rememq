////////
////////  QuickCapturesView.swift
////////  ReMEMq
////////
////////  Created by Sehaj Singh on 3/17/25.
////////
//////
//////
//////import SwiftUI
//////
//////struct QuickCapturesView: View {
//////    let set: SetItem
//////    @StateObject private var viewModel = QuickCapturesViewModel()
//////    
//////    var body: some View {
//////        List(viewModel.quickCaptures) { capture in
//////            NavigationLink(destination: QuickCaptureDetailView(quickCapture: capture)) {
//////                VStack(alignment: .leading) {
//////                    Text(capture.content)
//////                        .font(.headline)
//////                    if let context = capture.context {
//////                        Text(context)
//////                            .font(.subheadline)
//////                            .foregroundColor(.secondary)
//////                    }
//////                }
//////            }
//////        }
//////        .navigationTitle("Quick Captures")
//////        .onAppear {
//////            viewModel.loadQuickCaptures(for: set.id)
//////        }
//////    }
//////}
////////
////////struct QuickCaptureDetailView: View {
////////    let quickCapture: QuickCaptureModel
////////    
////////    var body: some View {
////////        VStack(alignment: .leading, spacing: 10) {
////////            Text("Content:")
////////                .font(.headline)
////////            Text(quickCapture.content)
////////            
////////            if let context = quickCapture.context {
////////                Text("Context:")
////////                    .font(.headline)
////////                Text(context)
////////            }
////////            
////////            Text("Highlighted Sections:")
////////                .font(.headline)
////////            ForEach(quickCapture.highlightedSections, id: \.self) { section in
////////                Text("• \(section)")
////////            }
////////            
////////            Text("Mastery Time: \(quickCapture.masteryTime)")
////////            Text("Depth of Learning: \(quickCapture.depthOfLearning)")
////////            Text("Created At: \(quickCapture.createdAt)")
////////            
////////            Spacer()
////////        }
////////        .padding()
////////        .navigationTitle("Quick Capture Details")
////////    }
////////}
/////////
//////import SwiftUI
//////struct QuickCapturesView: View {
//////    let set: SetItem
//////    @StateObject private var viewModel = QuickCapturesViewModel()
//////    
//////    var body: some View {
//////        List {
//////            ForEach(viewModel.quickCaptures) { capture in
//////                NavigationLink(destination: QuickCaptureDetailView(quickCapture: capture)) {
//////                    VStack(alignment: .leading) {
//////                        Text(capture.content)
//////                            .font(.headline)
//////                        if let context = capture.context {
//////                            Text(context)
//////                                .font(.subheadline)
//////                                .foregroundColor(.secondary)
//////                        }
//////                    }
//////                }
//////            }
//////            .onDelete(perform: deleteQuickCapture)
//////        }
//////        .navigationTitle("Quick Captures")
//////        .onAppear {
//////            viewModel.loadQuickCaptures(for: set.id)
//////        }
//////    }
//////
//////    func deleteQuickCapture(at offsets: IndexSet) {
//////        guard let index = offsets.first else { return }
//////        let capture = viewModel.quickCaptures[index]
//////        let endpoint = "organizer/quickcaptures/\(capture.id)/"
//////
//////        APIService.shared.performRequest(endpoint: endpoint, method: "DELETE") { result in
//////            DispatchQueue.main.async {
//////                switch result {
//////                case .success:
//////                    viewModel.quickCaptures.remove(atOffsets: offsets)
//////                    print("✅ Successfully deleted QuickCapture with ID \(capture.id)")
//////                case .failure(let error):
//////                    print("❌ Failed to delete: \(error.localizedDescription)")
//////                    // Optionally show an alert
//////                }
//////            }
//////        }
//////    }
//////}
////
////import SwiftUI
////import SwiftUI
////
////struct QuickCapturesView: View {
////    let set: SetItem
////    @StateObject private var viewModel = QuickCapturesViewModel()
////    @State private var isPracticing = false
////    @StateObject private var practiceViewModel = PracticeViewModel()
////
////    var body: some View {
////        VStack {
////            Button(action: {
////                practiceViewModel.loadQuizzesFromSet(setId: set.id)
////                isPracticing = true
////            }) {
////                Text("📝 Practice this Set")
////                    .font(.headline)
////                    .padding()
////                    .frame(maxWidth: .infinity)
////                    .background(Color.blue)
////                    .foregroundColor(.white)
////                    .cornerRadius(8)
////            }
////            .padding()
////
////            List {
////                ForEach(viewModel.quickCaptures) { capture in
////                    NavigationLink(destination: QuickCaptureDetailView(quickCapture: capture)) {
////                        VStack(alignment: .leading) {
////                            Text(capture.shortDescription ?? capture.content) // 👈 Shows summary if available
////                                .font(.headline)
////                            if let context = capture.context {
////                                Text(context)
////                                    .font(.subheadline)
////                                    .foregroundColor(.secondary)
////                            }
////                        }
////                    }
////                }
////
////                .onDelete(perform: deleteQuickCapture)
////            }
////            .listStyle(.plain)
////        }
////        .background(
////            NavigationLink(
////                destination: QuizPracticeView()
////                    .environmentObject(practiceViewModel),
////                isActive: $isPracticing
////            ) {
////                EmptyView()
////            }
////            .hidden()
////        )
////        .navigationTitle("Quick Captures")
////        .onAppear {
////            viewModel.loadQuickCaptures(for: set.id)
////        }
////    }
////
////    func deleteQuickCapture(at offsets: IndexSet) {
////        guard let index = offsets.first else { return }
////        let capture = viewModel.quickCaptures[index]
////        let endpoint = "organizer/quickcaptures/\(capture.id)/"
////
////        APIService.shared.performRequest(endpoint: endpoint, method: "DELETE") { result in
////            DispatchQueue.main.async {
////                switch result {
////                case .success:
////                    viewModel.quickCaptures.remove(atOffsets: offsets)
////                    print("✅ Successfully deleted QuickCapture with ID \(capture.id)")
////                case .failure(let error):
////                    print("❌ Failed to delete: \(error.localizedDescription)")
////                }
////            }
////        }
////    }
////}
////
//
//import SwiftUI
//struct QuickCapturesView: View {
//    let set: SetItem
//    @StateObject private var viewModel = QuickCapturesViewModel()
//    @State private var isPracticing = false
//    @StateObject private var practiceViewModel = PracticeViewModel()
//    @State private var expandedCaptureIDs: Set<Int> = []
//
//    var body: some View {
//        VStack {
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
//                    .cornerRadius(8)
//            }
//            .padding(.horizontal)
//
//            List {
//                ForEach(viewModel.quickCaptures) { capture in
//                    VStack(alignment: .leading, spacing: 8) {
//                        NavigationLink(destination: QuickCaptureDetailView(quickCapture: capture)) {
//                            VStack(alignment: .leading, spacing: 4) {
//                                // Summary headline
//                                Text(capture.shortDescription ?? "No summary available")
//                                    .font(.headline)
//
//                                // Context (optional)
//                                if let context = capture.context {
//                                    Text(context)
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                }
//                            }
//                        }
//                        // Expandable content preview
//                        VStack(alignment: .leading) {
//                            Button(action: {
//                                withAnimation {
//                                    toggleExpanded(captureID: capture.id)
//                                }
//                            }) {
//                                Text(capture.content)
//                                    .font(.footnote)
//                                    .foregroundColor(.gray)
//                                    .lineLimit(expandedCaptureIDs.contains(capture.id) ? nil : 1)
//                                    .multilineTextAlignment(.leading)
//                                    .padding(.top, 4)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                        }
//                    }
//                    .padding(.vertical, 6)
//                }
//                .onDelete(perform: deleteQuickCapture)
//            }
//            .listStyle(.plain)
//        }
//        .background(
//            NavigationLink(
//                destination: QuizPracticeView()
//                    .environmentObject(practiceViewModel),
//                isActive: $isPracticing
//            ) {
//                EmptyView()
//            }
//            .hidden()
//        )
//        .navigationTitle("Quick Captures")
//        .onAppear {
//            viewModel.loadQuickCaptures(for: set.id)
//        }
//    }
//
//    private func toggleExpanded(captureID: Int) {
//        if expandedCaptureIDs.contains(captureID) {
//            expandedCaptureIDs.remove(captureID)
//        } else {
//            expandedCaptureIDs.insert(captureID)
//        }
//    }
//
//    func deleteQuickCapture(at offsets: IndexSet) {
//        guard let index = offsets.first else { return }
//        let capture = viewModel.quickCaptures[index]
//        let endpoint = "organizer/quickcaptures/\(capture.id)/"
//
//        APIService.shared.performRequest(endpoint: endpoint, method: "DELETE") { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    viewModel.quickCaptures.remove(atOffsets: offsets)
//                    print("✅ Successfully deleted QuickCapture with ID \(capture.id)")
//                case .failure(let error):
//                    print("❌ Failed to delete: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}
import SwiftUI

struct QuickCapturesView: View {
    let set: SetItem
    @StateObject private var viewModel = QuickCapturesViewModel()
    @State private var isPracticing = false
    @StateObject private var practiceViewModel = PracticeViewModel()
    @State private var expandedCaptureIDs: Set<Int> = []

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
        }
        .padding()
        .onAppear {
            viewModel.loadQuickCaptures(for: set.id)
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
