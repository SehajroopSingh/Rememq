//
//  SharingOptionsViewController.swift
//  LearnAI2
//
//  Created by Sehaj Singh on 1/17/25.
//

import UIKit

class SharingOptionsViewController: UIViewController {
    var sharedText: String?
    var sharedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Add a label to display the shared content
        let label = UILabel()
        label.text = sharedText ?? "No text shared"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 100)
        view.addSubview(label)

        // Add a button to complete sharing
        let completeButton = UIButton(type: .system)
        completeButton.setTitle("Complete Sharing", for: .normal)
        completeButton.frame = CGRect(x: 20, y: 250, width: view.frame.width - 40, height: 50)
        completeButton.addTarget(self, action: #selector(completeSharing), for: .touchUpInside)
        view.addSubview(completeButton)
    }

    @objc private func completeSharing() {
        if let sharedText = sharedText {
            if let userDefaults = UserDefaults(suiteName: "group.learnai2") {
                do {
                    let sharedTextModel = SharedTextModel(text: sharedText)
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(sharedTextModel)
                    userDefaults.set(data, forKey: "sharedTextModel")
                    userDefaults.synchronize()
                    print("Shared text model re-saved on completion.")
                } catch {
                    print("Error encoding shared text model: \(error)")
                }
            } else {
                print("Error: Unable to access UserDefaults for App Group.")
            }
        }

        // Dismiss the Share Extension
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

}
