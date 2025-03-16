
import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers
import SharedAPI

class ShareViewController: SLComposeServiceViewController {
    
    // Shared Data
    var sharedText: String?
    var sharedURL: URL?
    var sharedImage: UIImage?
    
    var availableSets: [String] = []
    var availableFolders: [String] = []
    
    var selectedSet: String?
    var selectedFolder: String?
    
    // User-selected options
    var setName: String? = nil  // ✅ Name of the selected set
    var folderName: String? = nil  // ✅ Name of the selected folder
    var depthOfLearning: String? = "normal"  // ✅ Default to "normal"
    var highlightedSections: [String] = []  // ✅ Default to empty array
    
    
    // Enum to track content type
    enum SharedContentType {
        case text, image, video, unknown
    }
    var sharedContentType: SharedContentType = .unknown
    
    // UI Elements
    let noteTextView = UITextView()
    let difficultySelector = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
    let urgencySelector = UISegmentedControl(items: ["3 Days", "1 Week", "2 Weeks", "3 Weeks", "1 Month", "3 Months", "1 Year"])
    
    // A parent container to hold everything
    let containerView = UIView()
    
    // A vertical stack for effortless layout
    let stackView = UIStackView()
    
    
    
    // ✅ Dropdowns for Set & Folder selection
    let setPicker = UIPickerView()
    let folderPicker = UIPickerView()
    
    
    
    
    
    override func loadView() {
        // Create a root view that fills the entire extension’s view
        let rootView = UIView(frame: UIScreen.main.bounds)
        rootView.backgroundColor = .white
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedItems()
    }
    
    // Try to force a larger size (iOS may still limit it)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width,
                                           height: UIScreen.main.bounds.height)
    }
    override func isContentValid() -> Bool {
        return true  // Always enable the Post button
    }

    // ✅ Fetch available Sets & Folders from API
    private func fetchAvailableSetsAndFolders() {
        let setsEndpoint = "quick-capture/available-sets/"
        let foldersEndpoint = "quick-capture/available-folders/"
        
        APIService.shared.performRequest(endpoint: setsEndpoint, method: "GET", body: nil) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let setList = try? JSONDecoder().decode([String].self, from: data) {
                        self.availableSets = setList
                        self.setPicker.reloadAllComponents()
                    }
                case .failure(let error):
                    print("❌ Error fetching sets: \(error.localizedDescription)")
                }
            }
        }
        
        APIService.shared.performRequest(endpoint: foldersEndpoint, method: "GET", body: nil) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let folderList = try? JSONDecoder().decode([String].self, from: data) {
                        self.availableFolders = folderList
                        self.folderPicker.reloadAllComponents()
                    }
                case .failure(let error):
                    print("❌ Error fetching folders: \(error.localizedDescription)")
                }
            }
        }
    }
    // Handles shared items and determines content type
    private func handleSharedItems() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        let provider = attachments[0]
        
        if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            sharedContentType = .image
            provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (item, error) in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    if let imageURL = item as? URL {
                        self.sharedURL = imageURL
                    } else if let image = item as? UIImage {
                        self.sharedImage = image
                    }
                    self.setupUI()
                }
            }
        } else if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
            sharedContentType = .text
            provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (item, error) in
                if let error = error {
                    print("Error loading text: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    if let text = item as? String {
                        self.sharedText = text
                    }
                    self.setupUI()
                }
            }
        } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            sharedContentType = .video
            provider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { (item, error) in
                if let error = error {
                    print("Error loading video: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    if let videoURL = item as? URL {
                        self.sharedURL = videoURL
                    }
                    self.setupUI()
                }
            }
        } else {
            sharedContentType = .unknown
            self.setupUI()
        }
    }
    private func setupUI() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // Instead of using a plain UITextView, use HighlightableTextView for text preview
        if sharedContentType == .text, let sharedText = sharedText {
            let previewTextView = HighlightableTextView()
            previewTextView.text = sharedText
            previewTextView.font = UIFont.systemFont(ofSize: 16)
            previewTextView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            previewTextView.layer.cornerRadius = 8
            previewTextView.isEditable = false   // Set to false to keep it read-only
            previewTextView.isSelectable = true    // Allow text selection so the custom menu appears
            previewTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            // Add the preview text view above your noteTextView.
            stackView.addArrangedSubview(previewTextView)
            
            // Optionally, store a reference to previewTextView for later access.
            // self.previewTextView = previewTextView
        }


        noteTextView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        noteTextView.layer.cornerRadius = 8
        noteTextView.font = UIFont.systemFont(ofSize: 16)
        noteTextView.text = "Add a note..."
        noteTextView.textColor = .gray
        noteTextView.delegate = self
        noteTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.addArrangedSubview(noteTextView)
        
        if sharedContentType == .text || sharedContentType == .image {
            difficultySelector.selectedSegmentIndex = 0
            difficultySelector.heightAnchor.constraint(equalToConstant: 30).isActive = true
            stackView.addArrangedSubview(difficultySelector)
        }
        
        if sharedContentType == .text {
            urgencySelector.selectedSegmentIndex = 0
            urgencySelector.heightAnchor.constraint(equalToConstant: 30).isActive = true
            stackView.addArrangedSubview(urgencySelector)
        }
        
        if sharedContentType == .image, let sharedImage = sharedImage {
            let imageView = UIImageView(image: sharedImage)
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            stackView.addArrangedSubview(imageView)
        }
        
        if sharedContentType == .video {
            let label = UILabel()
            label.text = "A video has been shared."
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        
        
        
        // ✅ Add Custom "Post" Button
        let postButton = UIButton(type: .system)
        postButton.setTitle("Post", for: .normal)
        postButton.backgroundColor = .systemBlue
        postButton.setTitleColor(.white, for: .normal)
        postButton.layer.cornerRadius = 10
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.addTarget(self, action: #selector(didTapCustomPostButton), for: .touchUpInside)
        
        stackView.addArrangedSubview(postButton)
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    @objc private func didTapCustomPostButton() {
        didSelectPost()  // Manually trigger post action
    }

    
    override func didSelectPost() {
        let userNote = noteTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let selectedDifficulty = difficultySelector.titleForSegment(at: difficultySelector.selectedSegmentIndex) ?? "Easy"
        let selectedUrgency = urgencySelector.titleForSegment(at: urgencySelector.selectedSegmentIndex) ?? "1 Week"

        switch sharedContentType {
        case .text:
            if let text = sharedText {
                uploadTextToDjango(text, userNote: userNote, difficulty: selectedDifficulty, urgency: selectedUrgency)
            }
        case .image:
            if let image = sharedImage {
                uploadUIImageToDjango(image, userNote: userNote, difficulty: selectedDifficulty)
            }
        case .video:
            if let url = sharedURL {
                uploadFileToDjango(url: url, userNote: userNote, difficulty: selectedDifficulty)
            }
        case .unknown:
            print("Unknown content type. Nothing to upload.")
        }

        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    
    private func uploadFileToDjango(url: URL, userNote: String?, difficulty: String) {
        guard let serverURL = URL(string: "https://1479-58-8-65-88.ngrok-free.app/api") else { return }

        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let filename = url.lastPathComponent
        let mimeType = "application/octet-stream"  // Generic file type

        if let fileData = try? Data(contentsOf: url) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        if let note = userNote, !note.isEmpty {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"note\"\r\n\r\n".data(using: .utf8)!)
            body.append(note.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error { print("Upload error: \(error.localizedDescription)") }
        }
        task.resume()
    }


    private func uploadTextToDjango(_ text: String, userNote: String?, difficulty: String, urgency: String) {
        let endpoint = "quick-capture/quick_capture/"  // ✅ Use relative endpoint

        let requestBody: [String: Any] = [
            "content": text,
            "context": userNote ?? "",  // Context is optional, defaults to ""
            "difficulty": difficulty,
            "mastery_time": urgency,
            "depth_of_learning": depthOfLearning ?? "normal",  // ✅ Added depth_of_learning (defaults to "normal")
            "set_name": setName ?? "",
            "folder_name": folderName ?? "",
            "highlighted_sections": highlightedSections  // ✅ No need for ?? [] since it's already a list
        ]

        APIService.shared.performRequest(endpoint: endpoint, method: "POST", body: requestBody) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }  // ✅ Ensure self is captured properly

                switch result {
                case .success(let data):
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("✅ Share Text Upload Success: \(responseString)")
                    } else {
                        print("✅ Share Text Upload Success: (No readable response)")
                    }
                case .failure(let error):
                    print("❌ Share Text Upload Error: \(error.localizedDescription)")
                }

                // ✅ Complete Share Extension
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }



    private func uploadUIImageToDjango(_ image: UIImage, userNote: String?, difficulty: String) {
        guard let jpegData = image.jpegData(compressionQuality: 0.8),
              let serverURL = URL(string: "https://1479-58-8-65-88.ngrok-free.app/api/quick-capture/quick_capture/") else {
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

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error { print("Upload error: \(error.localizedDescription)") }
        }
        task.resume()
    }

}


import UIKit

class HighlightableTextView: UITextView, UIEditMenuInteractionDelegate {
    
    // Array to hold highlighted snippets for later sending to the API.
    var highlightedSnippets: [String] = []
    
    // Allow the text view to become first responder so that the edit menu can appear.
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureEditMenuInteraction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureEditMenuInteraction()
    }
    
    private func configureEditMenuInteraction() {
        // Create and add the UIEditMenuInteraction.
        let editMenuInteraction = UIEditMenuInteraction(delegate: self)
        self.addInteraction(editMenuInteraction)
    }
    
    // MARK: - UIEditMenuInteractionDelegate
    
    // Provide a custom menu when text is selected.
    func editMenuInteraction(_ interaction: UIEditMenuInteraction,
                             menuFor configuration: UIEditMenuConfiguration,
                             suggestedActions: [UIMenuElement]) -> UIMenu? {
        // Only show our custom action when there is a selection.
        guard self.selectedRange.length > 0 else {
            return UIMenu(title: "", children: [])
        }
        
        // Create our custom "Highlight" action.
        let highlightAction = UIAction(title: "Highlight") { [weak self] _ in
            self?.performHighlighting()
        }
        
        // Return a menu that only contains the highlight action.
        return UIMenu(title: "", children: [highlightAction])
    }
    
    // Perform the highlighting: change the background of the selected text and store it.
    private func performHighlighting() {
        let range = self.selectedRange
        guard range.length > 0, let fullText = self.text else { return }
        
        // Extract the selected text and save it.
        let selectedText = (fullText as NSString).substring(with: range)
        highlightedSnippets.append(selectedText)
        
        // Update the text view's attributed text to apply a yellow background.
        let mutableAttrString: NSMutableAttributedString
        if let currentAttrText = self.attributedText, currentAttrText.length > 0 {
            mutableAttrString = NSMutableAttributedString(attributedString: currentAttrText)
        } else {
            mutableAttrString = NSMutableAttributedString(string: fullText)
        }
        mutableAttrString.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
        self.attributedText = mutableAttrString
        
        // Collapse the selection.
        self.selectedRange = NSRange(location: range.location + range.length, length: 0)
    }
}



// MARK: - UITextViewDelegate
extension ShareViewController {
    override func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add a note..." {
            textView.text = ""
            textView.textColor = .black
        }
    }
}



