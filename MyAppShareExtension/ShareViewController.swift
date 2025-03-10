import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers


class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Share Extension – viewDidLoad called")

        // Typically, you might present a UI for metadata, but for simplicity
        // we’ll just automatically handle the first item we find.
        handleSharedItems()
    }
    
    // This is typically called when user taps Post in the share extension UI
    // or you can handle everything automatically in viewDidLoad.
    @IBAction func didTapPostButton(_ sender: AnyObject) {
        // If you had a custom UI for categories/notes/etc, gather them here
        // e.g.: let userNotes = notesTextField.text
        // then call handleSharedItems() or upload methods

        // For now, just finish the extension
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    private func handleSharedItems() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {
            // No attachments
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        // Just handle the first attachment, for example
        // (You can loop over attachments if you want multiple items)
        let provider = attachments[0]
        
        // Check what content type is provided
        // For text: kUTTypeText or UTType.plainText
        // For images: kUTTypeImage or UTType.image.identifier
        // For urls: kUTTypeURL
        // For video: kUTTypeMovie, etc.
        
        if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            // Load an image
            provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (item, error) in
                if let error = error {
                    print("Error loading image: \(error)")
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    return
                }
                if let imageURL = item as? URL {
                    // item might be a file URL to the image
                    self.uploadFileToDjango(url: imageURL, fileType: .image)
                } else if let image = item as? UIImage {
                    // item might be a UIImage in memory
                    self.uploadUIImageToDjango(image)
                } else {
                    print("Unsupported image item type.")
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
        }
        else if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
            // Load text
            provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (item, error) in
                if let error = error {
                    print("Error loading text: \(error)")
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    return
                }
                if let text = item as? String {
                    self.uploadTextToDjango(text)
                } else {
                    print("Unsupported text item type.")
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
        } else {
            // Handle other UTIs, e.g. videos, PDFs, etc.
            // For example, for a video:
            if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { (item, error) in
                    if let error = error {
                        print("Error loading video: \(error)")
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                        return
                    }
                    if let videoURL = item as? URL {
                        self.uploadFileToDjango(url: videoURL, fileType: .video)
                    } else {
                        print("Unsupported video item type.")
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    }
                }
            } else {
                // If it's not text, image, or video, you could add more checks or fallback logic
                print("Unsupported content type.")
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Upload Helpers
    
    enum UploadedFileType {
        case image
        case video
    }
    
    // Example for uploading a file at a URL (image or video)
    private func uploadFileToDjango(url: URL, fileType: UploadedFileType) {
        // Build a request
        // E.g. your Django endpoint: "https://example.com/api/upload/"
        guard let serverURL = URL(string: "https://1479-58-8-65-88.ngrok-free.app/api/processor/share-sheet/") else {
            print("Bad server URL")
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        
        // If your Django endpoint requires auth, set Authorization header
        // request.setValue("Bearer <token>", forHTTPHeaderField: "Authorization")
        
        // Suppose we do a simple multipart form upload:
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Build the multipart body
        var body = Data()
        
        // Add a "file" field
        let filename = url.lastPathComponent
        let mimeType = (fileType == .image) ? "image/jpeg" : "video/mp4" // or detect from URL
        if let fileData = try? Data(contentsOf: url) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // You could add extra fields (like user notes, category, etc.) here
        // e.g. "notes" field:
        /*
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"notes\"\r\n\r\n".data(using: .utf8)!)
        body.append("These are user notes".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        */
        
        // End the boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Set the body
        request.httpBody = body
        
        // Send
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                // Complete the extension when upload is done
                DispatchQueue.main.async {
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                return
            }
            // Check the HTTP response, parse server response if needed
            if let httpResponse = response as? HTTPURLResponse {
                print("Status: \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }
    
    // Example for uploading a UIImage in memory
    private func uploadUIImageToDjango(_ image: UIImage) {
        // Convert UIImage to JPEG data
        guard let jpegData = image.jpegData(compressionQuality: 0.8),
              let serverURL = URL(string: "https://1479-58-8-65-88.ngrok-free.app/api/processor/share-sheet/") else {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"shared-image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(jpegData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add extra fields if you want
        // e.g. add "description"
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status: \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }
    
    // Example for uploading text
    private func uploadTextToDjango(_ text: String) {
        guard let serverURL = URL(string: "https://1479-58-8-65-88.ngrok-free.app/api/processor/share-sheet/") else {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Build JSON body
        let jsonData = [
            "shared_text": text
            // Add other fields if needed
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonData, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status: \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }
}
