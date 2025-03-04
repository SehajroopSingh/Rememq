import Foundation

struct SharedContainerManager1 {
    // Replace this identifier with your actual App Group identifier.
    static let appGroupIdentifier = "group.learnai2"
    
    // File name where the shared text will be stored.
    static let fileName = "SharedText.txt"
    
    /// Returns the URL of the shared container's file.
    static var sharedFileURL: URL? {
        let fileManager = FileManager.default
        if let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) {
            print("Shared container URL: \(containerURL)")
            return containerURL.appendingPathComponent(fileName)
        }
        print("No container URL found for identifier \(appGroupIdentifier)")
        return nil
    }
    
    /// Saves text to the shared file.
    static func save(text: String) throws {
        guard let url = sharedFileURL else {
            throw NSError(domain: "SharedContainer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Container URL not found"])
        }
        try text.write(to: url, atomically: true, encoding: .utf8)
    }
    
    /// Reads text from the shared file.
    static func loadText() throws -> String {
        guard let url = sharedFileURL else {
            throw NSError(domain: "SharedContainer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Container URL not found"])
        }
        return try String(contentsOf: url, encoding: .utf8)
    }
}
