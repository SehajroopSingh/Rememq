//
//  QuickCapturesView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/17/25.
//


import SwiftUI

struct QuickCapturesView: View {
    let set: SetItem
    @StateObject private var viewModel = QuickCapturesViewModel()
    
    var body: some View {
        List(viewModel.quickCaptures) { capture in
            NavigationLink(destination: QuickCaptureDetailView(quickCapture: capture)) {
                VStack(alignment: .leading) {
                    Text(capture.content)
                        .font(.headline)
                    if let context = capture.context {
                        Text(context)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Quick Captures")
        .onAppear {
            viewModel.loadQuickCaptures(for: set.id)
        }
    }
}

struct QuickCaptureDetailView: View {
    let quickCapture: QuickCaptureModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Content:")
                .font(.headline)
            Text(quickCapture.content)
            
            if let context = quickCapture.context {
                Text("Context:")
                    .font(.headline)
                Text(context)
            }
            
            Text("Highlighted Sections:")
                .font(.headline)
            ForEach(quickCapture.highlightedSections, id: \.self) { section in
                Text("• \(section)")
            }
            
            Text("Mastery Time: \(quickCapture.masteryTime)")
            Text("Depth of Learning: \(quickCapture.depthOfLearning)")
            Text("Created At: \(quickCapture.createdAt)")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Quick Capture Details")
    }
}
