import SwiftUI
import Combine

/// Manages fetching/loading dashboard data.
class DashboardViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var dashboardData: DashboardData?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    // MARK: - Init with optional mock data
    init(mockData: DashboardData? = nil) {
        if let mockData = mockData {
            // 1) If mockData is provided (e.g. from a preview), just use it
            self.dashboardData = mockData
            print("🧪 Using Mock Dashboard Data: \(mockData)")
        } else {
            // 2) Otherwise, go through the normal load sequence
            loadDashboard()
        }
    }
    
    // MARK: - Public: Load or Refresh
    /// Loads the dashboard data:
    /// - Tries local storage first
    /// - Calls API if no local data
    /// - Sets default values if both fail
    func loadDashboard() {
        print("📡 Loading Dashboard Data from local/API...")

        isLoading = true
        
        // 1) Try loading from local storage
        if let localData = LocalDashboardStore.loadDashboardData() {
            print("✅ Loaded from Local Storage: \(localData)")
            self.dashboardData = localData
            isLoading = false
            return
        }
        
        // 2) If no local data found, fetch from API
        fetchFromAPI { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    print("✅ Fetched from API: \(data)")
                    self?.dashboardData = data
                    LocalDashboardStore.saveDashboardData(data)
                    
                case .failure(let error):
                    print("❌ API Fetch Failed: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                    self?.setDefaultValues()
                }
            }
        }
    }
    
    // MARK: - Private: Fetch from API
    private func fetchFromAPI(completion: @escaping (Result<DashboardData, Error>) -> Void) {
        APIService.shared.performRequest(endpoint: "user-interface/dashboard/", method: "GET") { result in
            switch result {
            case .success(let data):
                // 1) Print raw JSON for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🔎 RAW JSON RESPONSE: \(jsonString)")
                }
                // 2) Attempt decoding
                do {
                    let decoded = try JSONDecoder().decode(DashboardData.self, from: data)
                    completion(.success(decoded))
                } catch {
                    print("❌ JSON Parsing Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private: Fallback
    /// Sets default values when neither local nor API data is available.
    private func setDefaultValues() {
        print("⚠️ Setting Default Values (No Local or API Data)")
        self.dashboardData = DashboardData(hearts: 1, xp: 1, streak: 1, gems: 1)
    }
}
