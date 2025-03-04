////
////  DebugDataView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 2/1/25.
////
//
//import SwiftUI
//import SwiftData
//
//struct DebugDataView: View {
//    // Use a query to fetch all Destination objects.
//    @Query var destinations: [Destination]
//
//    var body: some View {
//        NavigationView {
//            List(destinations) { destination in
//                VStack(alignment: .leading) {
//                    Text(destination.name)
//                        .font(.headline)
//                    Text(destination.date.formatted(date: .long, time: .shortened))
//                        .font(.subheadline)
//                }
//            }
//            
//            .navigationTitle("All Destinations")
//            
//        }
//    }
//}
//#Preview {
//    DebugDataView()
//}
//
