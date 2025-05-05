//
//  DailyPracticeOutOfHeartsView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 4/20/25.

import SwiftUI

struct DailyPracticeOutOfHeartsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)

            Text("You're out of hearts for today 💔")
                .font(.title2)
                .multilineTextAlignment(.center)

            Text("Come back tomorrow to try again!")
                .foregroundColor(.secondary)
        }
        .padding()
        .onAppear {
            sendHeartsZeroToServer()
        }
    }

    private func sendHeartsZeroToServer() {
        let payload: [String: Any] = [
            "hearts_remaining": 0
        ]

        APIService.shared.performRequest(
            endpoint: "gamification/update-hearts/",
            method: "POST",
            body: payload
        ) { result in
            switch result {
            case .success:
                print("✅ Out of hearts update sent.")
            case .failure(let error):
                print("❌ Failed to send hearts=0: \(error.localizedDescription)")
            }
        }
    }
}
