import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            if let data = viewModel.dashboardData {
                // For now, just show each value as text:
                Text("Hearts: \(data.hearts)")
                Text("XP: \(data.xp)")
                Text("Streak: \(data.streak)")
                Text("Gems: \(data.gems)")
            } else {
                Text("Loading Dashboard...")
            }
            
            if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            // If you want to reload each time this view appears:
            // viewModel.loadDashboard()
        }
    }
}
