import SwiftUI
import Combine

/// An observable view model that manages fetching/loading dashboard data.
class DashboardViewModel: ObservableObject {
    @Published var dashboardData: DashboardData?
    @Published var errorMessage: String? = nil
    
    init() {
        loadDashboard()
    }
    
    /// Main function to load the dashboard data:
    /// 1) Check local
    /// 2) If nil, fetch from API
    /// 3) If neither available, fallback to defaults
    func loadDashboard() {
        // 1) Try local storage
        if let localData = LocalDashboardStore.loadDashboardData() {
            self.dashboardData = localData
            return
        }
        
        // 2) Fetch from the remote API if no local data found
        fetchFromAPI { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.dashboardData = data
                    // Save to local store for next time
                    LocalDashboardStore.saveDashboardData(data)
                    
                case .failure(let error):
                    print("Dashboard API error: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                    self?.setDefaultValues()
                }
            }
        }
    }
    
    /// Attempts to fetch data via the APIService
    private func fetchFromAPI(completion: @escaping (Result<DashboardData, Error>) -> Void) {
        APIService.shared.performRequest(endpoint: "dashboard/", method: "GET") { result in
            switch result {
            case .success(let data):
                // Attempt to decode the JSON into DashboardData
                if let decoded = try? JSONDecoder().decode(DashboardData.self, from: data) {
                    completion(.success(decoded))
                } else {
                    // JSON parsing failed
                    let parsingError = NSError(domain: "JSON Parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse dashboard data"])
                    completion(.failure(parsingError))
                }
            case .failure(let error):
                // Network or token refresh failed
                completion(.failure(error))
            }
        }
    }
    
    /// Called when both local + API fail, sets default 1 values.
    private func setDefaultValues() {
        self.dashboardData = DashboardData(hearts: 1, xp: 1, streak: 1, gems: 1)
    }
}
