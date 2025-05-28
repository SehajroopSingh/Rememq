//
//  GamificationView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/5/25.
//
import Charts


import Combine
import Foundation
import SwiftUI
import Charts

import SwiftUI
import Charts

struct GamificationView: View {
    @StateObject private var viewModel = GamificationViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Your XP Progress")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                // Add navigation button here 👇
                NavigationLink(destination: HighlighterView()) {
                    Text("Test Highlighter")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                if viewModel.xpHistory.isEmpty {
                    ProgressView("Loading XP...")
                        .padding()
                } else {
                    VStack(alignment: .leading) {
                        Text("Last 7 Days")
                            .font(.headline)
                            .padding(.leading)

                        Chart(viewModel.xpHistory) { entry in
                            BarMark(
                                x: .value("Date", shortDate(from: entry.date)),
                                y: .value("XP", entry.xp)
                            )
                            .cornerRadius(6)
                            .foregroundStyle(Color.green)
                            .annotation(position: .top) {
                                if entry.xp > 0 {
                                    Text("\(entry.xp)")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .frame(height: 200)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(radius: 4)
                        )
                        .padding(.horizontal)
                    }
                }
            }
        }
        .background(Color(red: 240/255, green: 250/255, blue: 240/255)) // light green like Duolingo
        .onAppear {
            viewModel.fetchXPHistory()
        }
    }

    func shortDate(from full: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: full) {
            let short = DateFormatter()
            short.dateFormat = "E" // "Mon", "Tue", etc.
            return short.string(from: date)
        }
        return full
    }
}



class GamificationViewModel: ObservableObject {
    @Published var xpHistory: [XPEntry] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchXPHistory() {
        APIService.shared.performRequest(endpoint: "gamification/xp_history/") { result in
            switch result {
            case .success(let data):
                if let decoded = try? JSONDecoder().decode([String: [XPEntry]].self, from: data),
                   let history = decoded["xp_history"] {
                    DispatchQueue.main.async {
                        self.xpHistory = history
                    }
                } else {
                    print("Failed to decode XP history.")
                }
            case .failure(let error):
                print("Error fetching XP history: \(error)")
            }
        }
    }
}






struct XPEntry: Identifiable, Codable {
    var id: String { date }
    let date: String
    let xp: Int
}

struct XPHistoryResponse: Codable {
    let xp_history: [XPEntry]
}
