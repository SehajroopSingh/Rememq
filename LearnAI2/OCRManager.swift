//
//  OCRManager.swift
//  LearnAI2
//
//  Created by Sehaj Singh on 12/30/24.
//


import Vision
import Foundation

class OCRManager {
    func recognizeText(fromImageAt imagePath: String, completion: @escaping (String?, Error?) -> Void) {
        let imageUrl = URL(fileURLWithPath: imagePath)
        guard let cgImage = CGImageSourceCreateImageAtIndex(CGImageSourceCreateWithURL(imageUrl as CFURL, nil)!, 0, nil) else {
            completion(nil, NSError(domain: "OCRManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not create CGImage."]))
            return
        }
        
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let allRecognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                completion(allRecognizedText.isEmpty ? nil : allRecognizedText, nil)
            } else {
                completion(nil, NSError(domain: "OCRManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No observations found."]))
            }
        }
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            completion(nil, error)
        }
    }
}
