import SwiftUI

struct SharedQuickCaptureModel: Identifiable, Decodable {
    let id: Int
    let content: String
    let context: String?
    let highlightedSections: [String]
    let masteryTime: String
    let depthOfLearning: String
    let set: Int?
    let folder: Int?
    let createdAt: String
    let sharedBy: String?
    let classification: String?  // ✅ add this
    

    var shortDescription: String { String(content.prefix(80)) + "…" }

    enum CodingKeys: String, CodingKey {
        case id, content, context
        case highlightedSections = "highlighted_sections"
        case masteryTime = "mastery_time"
        case depthOfLearning = "depth_of_learning"
        case set, folder
        case createdAt = "created_at"
        case sharedBy = "shared_by"
        case classification  // ✅ Add this line
    }
}


struct SharedSetModel: Identifiable, Decodable {
    let id: Int
    let title: String
    let sharedBy: String?
    let quickCaptures: [SharedQuickCaptureModel]

    enum CodingKeys: String, CodingKey {
        case id, title
        case sharedBy = "shared_by"
        case quickCaptures = "quick_captures"
    }
}

struct SharedGroupModel: Identifiable, Decodable {
    let id: Int
    let name: String
    let sharedBy: String?
    let sets: [SharedSetModel]

    enum CodingKeys: String, CodingKey {
        case id, name
        case sharedBy = "shared_by"
        case sets
    }
}

struct SharedSpaceModel: Identifiable, Decodable {
    let id: Int
    let name: String
    let sharedBy: String?
    let groups: [SharedGroupModel]

    enum CodingKeys: String, CodingKey {
        case id, name
        case sharedBy = "shared_by"
        case groups
    }
}


struct SharedContentResponseModel: Decodable {
    let sharedSpaces: [SharedSpaceModel]?
    let sharedGroups: [SharedGroupModel]?
    let sharedSets: [SharedSetModel]?
    let sharedQuickCaptures: [SharedQuickCaptureModel]?

    enum CodingKeys: String, CodingKey {
        case sharedSpaces = "shared_spaces"
        case sharedGroups = "shared_groups"
        case sharedSets = "shared_sets"
        case sharedQuickCaptures = "shared_quick_captures"
    }
}
import SwiftUI

class SharedContentViewModel: ObservableObject {
    @Published var sharedSpaces: [SharedSpaceModel] = []
    @Published var sharedGroups: [SharedGroupModel] = []
    @Published var sharedSets: [SharedSetModel] = []
    @Published var sharedQuickCaptures: [SharedQuickCaptureModel] = []
    @Published var isLoading = true
    @Published var errorMessage: String?

    func fetchSharedContent() {
        Task {
            do {
                let data = try await APIService.shared.request(endpoint: "organizer/nested_shared/")
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // 🔍 Print the raw JSON response for inspection
                if let raw = String(data: data, encoding: .utf8) {
                    print("[RAW JSON]", raw)
                }

                let decoded = try decoder.decode(SharedContentResponseModel.self, from: data)

                DispatchQueue.main.async {
                    self.sharedSpaces = decoded.sharedSpaces ?? []
                    self.sharedGroups = decoded.sharedGroups ?? []
                    self.sharedSets = decoded.sharedSets ?? []
                    self.sharedQuickCaptures = decoded.sharedQuickCaptures ?? []
                    self.isLoading = false
                    print("[DEBUG] Fetched \(self.sharedSpaces.count) spaces, \(self.sharedGroups.count) groups, \(self.sharedSets.count) sets, \(self.sharedQuickCaptures.count) captures")
                }
            } catch let decodingError as DecodingError {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(decodingError.localizedDescription)"
                    self.isLoading = false
                    print("[DECODING ERROR]", decodingError)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    print("[NETWORK ERROR]", error)
                }
            }
        }
    }
}

