//
//  CardView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/16/25.
//

import SwiftUI
struct CardView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}
