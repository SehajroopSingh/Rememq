////
////  DetailedView.swift
////  LearnAI2
////
////  Created by Sehaj Singh on 1/20/25.
////
//
//import SwiftUI
//import Foundation
//import SwiftData
//
//struct DetailView: View {
//    @Environment(\.modelContext) var modelContext
//    @Query var destinations: [Destination]
//
//    var body: some View {
//        
//        NavigationStack {
//            
//            List {
//                ForEach(destinations) { destination in
//                    VStack(alignment: .leading) {
//                        Text(destination.name )
//                            .font (. headline)
//                        
//                        Text(destination.date.formatted(date:.long, time: .shortened))
//                        
//                    }
//                }
//            }
//            .navigationTitle ("iTour")
//            .toolbar {
//                Button("Add Samples", action: addSamples)
//            }
//        }
//    }
//            
//    func addSamples() {
//        let rome = Destination (name: "Rome")
//        let florence = Destination (name: "Florence")
//        let naples = Destination (name: "Naples")
//        modelContext.insert (rome)
//        modelContext.insert(florence)
//        modelContext.insert (naples)
//    }
//}
//
//
//#Preview{
//    DetailView()
//}
