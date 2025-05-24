////
////  SharedQuickCapture.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 5/19/25.
////
//
//
//struct SharedQuickCapture: Identifiable, Decodable {
//    let id: Int
//    let content: String
//    let context: String?
//    let shortDescription: String?
//    let sharedBy: String?
//    // add other fields as needed
//}
//
//struct SharedSet: Identifiable, Decodable {
//    let id: Int
//    let title: String
//    let sharedBy: String?
//    let quickCaptures: [SharedQuickCapture]
//}
//
//struct SharedGroup: Identifiable, Decodable {
//    let id: Int
//    let name: String
//    let sharedBy: String?
//    let sets: [SharedSet]
//}
//
//struct SharedSpace: Identifiable, Decodable {
//    let id: Int
//    let name: String
//    let sharedBy: String?
//    let groups: [SharedGroup]
//    var isShared: Bool = false  // <--- default value
//}
//
//struct SharedContentResponse: Decodable {
//    let sharedSpaces: [SharedSpace]
//    let sharedGroups: [SharedGroup]
//    let sharedSets: [SharedSet]
//    let sharedQuickCaptures: [SharedQuickCapture]
//}



//import SwiftUI
//
//// MARK: - Shared Models
//struct SharedQuickCaptureModel: Identifiable, Decodable {
//    let id: Int
//    let content: String
//    let sharedBy: String?
//    var shortDescription: String { String(content.prefix(80)) + "…" }
//}
//
//struct SharedSetModel: Identifiable, Decodable {
//    let id: Int
//    let title: String
//    let sharedBy: String?
//    let quickCaptures: [SharedQuickCaptureModel]
//}
//
//struct SharedGroupModel: Identifiable, Decodable {
//    let id: Int
//    let name: String
//    let sharedBy: String?
//    let sets: [SharedSetModel]
//}
//
//struct SharedSpaceModel: Identifiable, Decodable {
//    let id: Int
//    let name: String
//    let sharedBy: String?
//    let groups: [SharedGroupModel]
//}
//
//struct SharedContentResponseModel: Decodable {
//    let sharedSpaces: [SharedSpaceModel]
//    enum CodingKeys: String, CodingKey {
//        case sharedSpaces = "shared_spaces"
//    }
//}
