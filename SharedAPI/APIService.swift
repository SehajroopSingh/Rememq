////
////  APIService.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 2/26/25.
////
//
//
//import SwiftUI
//
//public class APIService {
//    @AppStorage("accessToken") var accessToken: String = ""
//    @AppStorage("refreshToken") var refreshToken: String = ""
//    
//    static let shared = APIService()  // Singleton instance
//    
//    private let baseURL = "https://1479-58-8-65-88.ngrok-free.app/api/"
//    
//    // ✅ Function to Perform API Requests with Auto Refresh
//    public func performRequest(endpoint: String, method: String = "GET", body: [String: Any]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
//        
//        guard let url = URL(string: baseURL + endpoint) else {
//            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        if !accessToken.isEmpty {
//            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        }
//
//        if let body = body {
//            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
//                return
//            }
//
//            if httpResponse.statusCode == 401 {
//                // ✅ Unauthorized: Try Refreshing Token
//                self.refreshToken { success in
//                    if success {
//                        // Retry the original request with the new access token
//                        self.performRequest(endpoint: endpoint, method: method, body: body, completion: completion)
//                    } else {
//                        completion(.failure(NSError(domain: "Unauthorized", code: 401, userInfo: nil)))
//                    }
//                }
//            } else if let data = data {
//                completion(.success(data))
//            }
//        }.resume()
//    }
//    
//    public func refreshToken(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: baseURL + "token/refresh/") else {
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: String] = ["refresh": refreshToken]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Token refresh error: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(false)
//                return
//            }
//            
//            // Check if the refresh token is invalid or expired (HTTP 401)
//            if httpResponse.statusCode == 401 {
//                if let data = data, let rawResponse = String(data: data, encoding: .utf8) {
//                    print("Refresh token response status: \(httpResponse.statusCode)")
//                    print("Raw refresh token response: \(rawResponse)")
//                }
//                // Failed to refresh token, force logout.
//                DispatchQueue.main.async {
//                    print("Refresh token expired, logging out...")
//                    self.logoutUser()  // Clears tokens and resets authentication state.
//                }
//                completion(false)
//                return
//                
//            }
//            
//            guard let data = data,
//                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
//                  let newAccessToken = json["access"] else {
//                print("Failed to refresh stoken")
//                completion(false)
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.accessToken = newAccessToken
//                print("Token refreshed successfully!")
//                completion(true)
//            }
//        }.resume()
//    }
//
//
//    
//    // ✅ Function to Log Out
//    public func logoutUser() {
//        DispatchQueue.main.async {
//            self.accessToken = ""
//            self.refreshToken = ""
//        }
//    }
//}
import SwiftUI


public class APIService {
    private let sharedDefaults = UserDefaults(suiteName: "group.learnai2")

    public static let shared = APIService()  // Singleton instance

    public var accessToken: String {
        get { sharedDefaults?.string(forKey: "accessToken") ?? "" }
        set { sharedDefaults?.setValue(newValue, forKey: "accessToken") }
    }

    public var refreshToken: String {
        get { sharedDefaults?.string(forKey: "refreshToken") ?? "" }
        set { sharedDefaults?.setValue(newValue, forKey: "refreshToken") }
    }

    private let baseURL = "https://1479-58-8-65-88.ngrok-free.app/api/"

    public func performRequest(endpoint: String, method: String = "GET", body: [String: Any]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }

            if httpResponse.statusCode == 401 {
                self.refreshToken { success in
                    if success {
                        self.performRequest(endpoint: endpoint, method: method, body: body, completion: completion)
                    } else {
                        completion(.failure(NSError(domain: "Unauthorized", code: 401, userInfo: nil)))
                    }
                }
            } else if let data = data {
                completion(.success(data))
            }
        }.resume()
    }

    public func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL + "token/refresh/") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["refresh": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Token refresh error: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                  let newAccessToken = json["access"] else {
                completion(false)
                return
            }

            DispatchQueue.main.async {
                self.accessToken = newAccessToken
                print("Token refreshed successfully!")
                completion(true)
            }
        }.resume()
    }

    public func logoutUser() {
        DispatchQueue.main.async {
            self.accessToken = ""
            self.refreshToken = ""
        }
    }
}
