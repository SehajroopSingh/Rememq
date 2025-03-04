import UIKit
import Social

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ Share Extension Loaded: viewDidLoad() called")
        handleSharedContent()
    }
    
    
    
    func saveSharedText(_ text: String) {
        guard let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.learnai2") else {
            print("❌ Shared container not found")
            return
        }

        let fileURL = sharedContainer.appendingPathComponent("SharedText.txt")

        do {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                print("ℹ️ File does not exist, creating SharedText.txt...")
                FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
            }

            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            print("✅ Shared text saved successfully at:", fileURL.path)
        } catch {
            print("❌ Error saving shared text:", error.localizedDescription)
        }
    }

    func loadSharedText() -> String? {
        guard let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.learnai2") else {
            print("❌ Shared container not found")
            return nil
        }

        let fileURL = sharedContainer.appendingPathComponent("SharedText.txt")

        do {
            let savedText = try String(contentsOf: fileURL, encoding: .utf8)
            print("✅ Loaded shared text: \(savedText)")
            return savedText
        } catch {
            print("❌ Error loading shared text:", error.localizedDescription)
            return nil
        }
    }
    private func handleSharedContent() {
        if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = extensionItem.attachments?.first {
            
            if itemProvider.hasItemConformingToTypeIdentifier("public.text") {
                itemProvider.loadItem(forTypeIdentifier: "public.text", options: nil) { (item, error) in
                    if let error = error {
                        print("❌ Error loading item:", error.localizedDescription)
                        return
                    }
                    
                    if let text = item as? String {
                        print("✅ Captured shared text: \(text)")
                        
                        // ✅ Save text to shared container (quick operation)
                        self.saveSharedText(text)

                        // ✅ Move API call to a background thread to avoid blocking
                        DispatchQueue.global(qos: .background).async {
                            self.sendToAPI(text)
                        }

                        // ✅ Immediately complete the request so the extension exits
                        DispatchQueue.main.async {
                            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                        }
                    } else {
                        print("❌ Failed to extract text from shared content")
                    }
                }
            } else {
                print("⚠️ Shared content does not conform to 'public.text'")
            }
        } else {
            print("❌ No NSExtensionItem found")
        }
    }

    private func sendToAPI(_ text: String) {
        print("📤 Sending text to API...")

        guard let url = URL(string: "http://127.0.0.1:8000/api/processor/quick_capture") else {
            print("❌ Invalid API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["text": text]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            print("✅ JSON Payload: \(body)")
        } catch {
            print("❌ Error serializing JSON:", error.localizedDescription)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error sending text:", error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                print("📡 API Response Code: \(httpResponse.statusCode)")

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("📡 API Response Body: \(responseString)")
                }
                
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    print("✅ Text sent successfully")
                } else {
                    print("⚠️ Unexpected HTTP status code:", httpResponse.statusCode)
                }
            }
            
            DispatchQueue.main.async {
                self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            }
        }
        
        task.resume()
    }
}


