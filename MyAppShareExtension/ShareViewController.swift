import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    override func didSelectPost() {
        // Attempt to extract text from the input items.
        if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
           let attachments = extensionItem.attachments {
            for provider in attachments {
                if provider.hasItemConformingToTypeIdentifier("public.plain-text") {
                    provider.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { (item, error) in
                        if let text = item as? String {
                            do {
                                try SharedContainerManager.save(text: text)
                            } catch {
                                print("Error saving text to shared container: \(error)")
                            }
                        }
                        // Signal that we are done.
                        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                    }
                    break
                }
            }
        } else {
            // If no text was found, complete the extension request.
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
    
    override func configurationItems() -> [Any]! {
        // You can add configuration items if needed.
        return []
    }
}
