import UIKit
import Social

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedContent()
    }
    
    private func handleSharedContent() {
        if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = extensionItem.attachments?.first {
            
            if itemProvider.hasItemConformingToTypeIdentifier("public.text") {
                itemProvider.loadItem(forTypeIdentifier: "public.text", options: nil) { (item, error) in
                    if let text = item as? String {
                        self.sendToAPI(text)
                    }
                }
            }
        }
    }
    
    private func sendToAPI(_ text: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/processor/quick_capture") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["text": text]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending text:", error)
            } else {
                print("Text sent successfully")
            }
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
        
        task.resume()
    }
}
