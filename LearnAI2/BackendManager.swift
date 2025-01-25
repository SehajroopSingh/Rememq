//
//  BackendManager.swift
//  LearnAI2
//
//  Created by Sehaj Singh on 12/30/24.
//


import Foundation

class BackendManager {
    let backendURL = "http://127.0.0.1:8000/api/processor/process/"

    func sendToBackend(text: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/processor/process/") else {
            print("Invalid backend URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: String] = ["input_type": "text", "content": text]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("Failed to serialize JSON: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending request: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Server responded with status code: \(httpResponse.statusCode)")
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }
        task.resume()
    }
}
