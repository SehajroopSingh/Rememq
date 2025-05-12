
import SwiftUI
import Combine

public class APIService: ObservableObject {
    private let sharedDefaults = UserDefaults(suiteName: "group.learnai2")
    public static let shared = APIService()  // Singleton instance

    @Published var isLoggedOut = false  // 🔹 Track logout state

    public var accessToken: String {
        get { sharedDefaults?.string(forKey: "accessToken") ?? "" }
        set { sharedDefaults?.setValue(newValue, forKey: "accessToken") }
    }

    public var refreshToken: String {
        get { sharedDefaults?.string(forKey: "refreshToken") ?? "" }
        set { sharedDefaults?.setValue(newValue, forKey: "refreshToken") }
    }

    //private let baseURL = "https://6ef6-172-89-160-207.ngrok-free.app/api/"
    private let baseURL = "http://rememq-backend-env.eba-rwgrpkku.us-west-2.elasticbeanstalk.com/api/"

    
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
                print("🔄 401 Unauthorized. Attempting to refresh token...")
                self.refreshToken { success in
                    if success {
                        print("🔄 Retrying request after successful refresh.")
                        self.performRequest(endpoint: endpoint, method: method, body: body, completion: completion)
                    } else {
                        print("🔴 Refresh token failed. Logging out.")
                        self.forceLogout()  // 🔹 Force logout and notify UI
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
                self.forceLogout()  // 🔹 Force logout if refresh fails
                completion(false)
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                  let newAccessToken = json["access"] else {
                self.forceLogout()  // 🔹 Force logout if refresh response is invalid
                completion(false)
                return
            }

            DispatchQueue.main.async {
                self.accessToken = newAccessToken
                print("✅ Token refreshed successfully!")
                completion(true)
            }
        }.resume()
    }

    // 🔴 **Force Logout and Notify UI**
    private func forceLogout() {
        DispatchQueue.main.async {
            print("🔴 Force Logging Out...")
            self.accessToken = ""
            self.refreshToken = ""
            self.isLoggedOut = true  // 🔹 Notify UI to navigate to LoginView
        }
    }
}
