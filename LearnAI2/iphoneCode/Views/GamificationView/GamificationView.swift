//
//  GamificationView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 2/25/25.
//

import SwiftUI

// Example: a simple mock model for gamification stats


struct GamificationView: View {
    @State private var stats: GamificationStats?

    var body: some View {
        VStack {
            if let stats = stats {
                Text("Points: \(stats.points)")
                Text("Level: \(stats.level)")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            ServiceLayer.gamificationService.fetchStats { fetchedStats in
                self.stats = fetchedStats
            }
        }
    }
}
#Preview {
    GamificationView()
}