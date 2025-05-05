//
//  ActivityFeedView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/5/25.
//
import SwiftUI

import SwiftUI

struct ActivityFeedView: View {
    @State private var activities: [Activity] = []

    var body: some View {
        ScrollView {
            ForEach(activities) { activity in
                VStack(alignment: .leading) {
                    Text(activity.content)
                        .font(.body)
                    Text(activity.timestamp, style: .relative)  // e.g., "5m ago"
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                .padding(.horizontal)
            }
        }
        .onAppear {
            fetchActivities()
        }
    }

    func fetchActivities() {
        APIService.shared.performRequest(endpoint: "social/feed/") { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601  // make sure timestamp works

                do {
                    let decoded = try decoder.decode([Activity].self, from: data)
                    DispatchQueue.main.async {
                        self.activities = decoded
                    }
                } catch {
                    print("❌ Decoding error:", error)
                }

            case .failure(let error):
                print("❌ Request error:", error)
            }
        }
    }
}

