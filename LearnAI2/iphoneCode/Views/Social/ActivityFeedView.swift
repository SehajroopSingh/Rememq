import SwiftUI

struct ActivityFeedView: View {
    @EnvironmentObject var socialVM: SocialViewModel


    var body: some View {
        ZStack {

            ScrollView {
                VStack(spacing: 16) {
                    if socialVM.activityFeed.isEmpty {
                        Text("Nothing yet! Here's some demo activity:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }

                    ForEach(socialVM.activityFeed.isEmpty ? Activity.fakeFeed : socialVM.activityFeed) { activity in
                        activityCard(activity)                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .onAppear {
            Task {
                await socialVM.fetchActivityFeed()
            }
        }
    }

    @ViewBuilder
    private func activityCard(_ activity: Activity) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(activity.content)
                .font(.body)
                .foregroundColor(.primary)

            Text(activity.timestamp, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

//    private func fetchActivities() {
//        APIService.shared.performRequest(endpoint: "social/feed/") { result in
//            switch result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                do {
//                    let decoded = try decoder.decode([Activity].self, from: data)
//                    DispatchQueue.main.async {
//                        self.activities = decoded
//                    }
//                } catch {
//                    print("❌ Decoding error:", error)
//                }
//
//            case .failure(let error):
//                print("❌ Request error:", error)
//            }
//        }
//    }
}

// Preview
struct ActivityFeedView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFeedView()
    }
}
