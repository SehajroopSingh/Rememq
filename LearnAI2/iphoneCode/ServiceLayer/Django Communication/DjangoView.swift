//
//  ContentView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 2/5/25.
//


import SwiftUI

struct DjangoView: View {
    @State private var responseMessage: String = "Waiting for response..."

    var body: some View {
        VStack {
            Text(responseMessage)
                .padding()
            
            Button("Send Data to Django") {
                sendDataToDjango()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }

    func sendDataToDjango() {
        guard let url = URL(string: "https://353a-91-80-26-98.ngrok-free.app/api/processor/process/") else {
            responseMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let postData: [String: Any] = [
            "input_type": "text",
            "content": "Hello from iOS"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
        } catch {
            responseMessage = "Failed to encode JSON"
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    responseMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    responseMessage = "Response: \(responseString)"
                }
            }
        }

        task.resume()
    }
}

#Preview {
    DjangoView()
}
