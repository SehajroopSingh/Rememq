import Foundation

struct DashboardData: Codable {
    var hearts: Int
    var xp: Int
    var streak: Int
    var gems: Int
    
    // You can expand with more properties if the API returns them, e.g.:
    // var level: Int
    // var badges: [String]
    // etc.
}
