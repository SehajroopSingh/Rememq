//
//  SocialView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/13/25.
//


import SwiftUI

struct SocialView: View {
    var body: some View {
        VStack {
            Text("Social View")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            // Placeholder for future content
            Text("This is where social features will go.")
                .foregroundColor(.gray)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Social")
    }
}

// Preview
struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
