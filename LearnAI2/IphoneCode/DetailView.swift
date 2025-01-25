//
//  DetailedView.swift
//  LearnAI2
//
//  Created by Sehaj Singh on 1/20/25.
//

import SwiftUI
import Foundation
import SwiftUI

struct DetailView: View {
    @State private var sharedItems: [SharedItem] = [] // To store shared items

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("This is the Details Page")
                    .font(.largeTitle)
                    .padding()

                // Placeholder for when there are no shared items
                if sharedItems.isEmpty {
                    Text("No shared items available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Display shared items dynamically
                    ForEach(sharedItems) { item in
                        if let text = item.text {
                            Text("Shared Text: \(text)")
                                .font(.headline)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }

                // Refresh button
                Button("Refresh UserDefaults") {
                    refreshUserDefaults()
                }
                .font(.headline)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
        .background(Color.yellow.opacity(0.2))
        .navigationTitle("Details")
        .onAppear {
            print("DetailView appeared")
            loadSharedItems()
        }
    }

    private func loadSharedItems() {
        print("####################loadSharedItems called#####################")
        if let userDefaults = UserDefaults(suiteName: "group.learnai2") {
            print("####################userDefaults#####################")
            print("UserDefaults Contents in DetailView:")
            print(" \(userDefaults.dictionaryRepresentation())")
            print("####################userDefaults#####################")

            if let data = userDefaults.data(forKey: "sharedTextModel") {
                do {
                    let decoder = JSONDecoder()
                    let sharedTextModel = try decoder.decode(SharedTextModel.self, from: data)
                    if !sharedItems.contains(where: { $0.text == sharedTextModel.text }) {
                        sharedItems.append(SharedItem(text: sharedTextModel.text))
                    }
                    print("####################sharedItems#####################")
                    print("Loaded SharedTextModel: \(sharedTextModel)")
                    print("####################sharedItems#####################")
                    
                } catch {
                    print("Error decoding SharedTextModel: \(error)")
                }
            } else {
                print("No SharedTextModel found in UserDefaults.")
            }
        } else {
            print("Error: Unable to access UserDefaults for App Group.")
        }
    }

    private func refreshUserDefaults() {
        print("refreshUserDefaults called")
        if let userDefaults = UserDefaults(suiteName: "group.learnai2") {
            print("UserDefaults Contents: \(userDefaults.dictionaryRepresentation())")
            loadSharedItems()
        } else {
            print("Error: Unable to access UserDefaults for App Group.")
        }
    }
}

// Data model for shared items
struct SharedItem: Identifiable {
    let id = UUID()
    var text: String?
}
