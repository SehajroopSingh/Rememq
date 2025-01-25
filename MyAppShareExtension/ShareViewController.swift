import UniformTypeIdentifiers
import UIKit

// This class will manage the share extension's view and handle the content.
class ShareViewController: UIViewController {
    // Called after the view controller's view has been loaded into memory.
    // Processes shared content when the share sheet is triggered.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Represents the shared data passed to the share extension. Each item is an NSExtensionItem, which contains attachments like files, text, or images.
        if let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] {
            
            // Loops through all shared items and their attachments.
            for item in extensionItems {
                if let attachments = item.attachments {
                    for attachment in attachments {
                        
                        // Checks if the attachment is plain text using UTType.plainText.
                        if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                            
                            // Asynchronously retrieves the plain text data.
                            attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (data, error) in
                                // Logs any error during the loading process.
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                    return
                                }
                                
                                // Wraps the retrieved text in a SharedTextModel.
                                if let text = data as? String {
                                    let sharedTextModel = SharedTextModel(text: text)
                                    
                                    self.saveSharedTextModel(sharedTextModel)
                                    
                                    DispatchQueue.main.async {
                                        // Passes the SharedTextModel to the sharing options interface.
                                        self.presentSharingOptions(with: sharedTextModel, image: nil)
                                    }
                                }
                            }
                            
                        // Checks if the attachment is an image using UTType.image.
                        } else if attachment.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                            attachment.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (data, error) in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                    return
                                }
                                
                                if let image = data as? UIImage {
                                    self.saveSharedImage(image)
                                    DispatchQueue.main.async {
                                        self.presentSharingOptions(with: nil, image: image)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Saves the shared text model into shared UserDefaults for access by the main app.
    private func saveSharedTextModel(_ sharedTextModel: SharedTextModel) {
        if let userDefaults = UserDefaults(suiteName: "group.learnai2") {
            do {
                print("----------------------------- sharedTextModel -------------------------------------")
                let encoder = JSONEncoder()
                let data = try encoder.encode(sharedTextModel)
                userDefaults.set(data, forKey: "sharedTextModel")
                userDefaults.synchronize()
                
                print("Shared text model saved in user defaults: \(sharedTextModel.text)")
                print("UserDefaults: \(userDefaults.dictionaryRepresentation())")
                print("Shared text model: \(userDefaults.data(forKey: "sharedTextModel")?.debugDescription ?? "")")
            } catch {
                print("Error encoding shared text model: \(error)")
            }
        } else {
            print("Error: Unable to access UserDefaults for App Group.")
        }
    }

    private func saveSharedImage(_ image: UIImage) {
        if let userDefaults = UserDefaults(suiteName: "group.learnai2"),
           let imageData = image.jpegData(compressionQuality: 1.0) {
            userDefaults.set(imageData, forKey: "sharedImage")
            userDefaults.synchronize()
            print("Shared image saved.")
        } else {
            print("Error: Unable to access UserDefaults for App Group.")
        }
    }

    // Presents the sharing options screen with the shared content.
    private func presentSharingOptions(with sharedTextModel: SharedTextModel?, image: UIImage?) {
        let optionsVC = SharingOptionsViewController()
        optionsVC.sharedText = sharedTextModel?.text
        optionsVC.sharedImage = image
        
        self.present(optionsVC, animated: true, completion: nil)
    }
}
