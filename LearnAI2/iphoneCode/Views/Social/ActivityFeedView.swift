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
        VStack {
            if activities.isEmpty {
                Text("Nothing yet! Here's some demo activity:")
                    .foregroundColor(.gray)
                ForEach(Activity.fakeFeed) { activity in
                    activityCard(activity)
                }
            } else {
                ForEach(activities) { activity in
                    activityCard(activity)
                }
            }
        }
        .onAppear { fetchActivities() }
        .padding(.horizontal)
    }

    func activityCard(_ activity: Activity) -> some View {
        VStack(alignment: .leading) {
            Text(activity.content)
                .font(.body)
            Text(activity.timestamp, style: .relative)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }

    func fetchActivities() {
        APIService.shared.performRequest(endpoint: "social/feed/") { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
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
