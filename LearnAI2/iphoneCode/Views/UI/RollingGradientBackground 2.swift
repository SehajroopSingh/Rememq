//
//  RollingGradientBackground 2.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/13/25.
//


import SwiftUI

struct RollingGradientBackground2: View {
    @State private var moveGradient = false

    var body: some View {
        GeometryReader { geometry in
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.5, blue: 0.2),         // Dark forest green
                    Color(red: 0.5, green: 1.0, blue: 0.5)          // Light pastel green
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: geometry.size.width * 2, height: geometry.size.height * 2)
            .offset(
                x: moveGradient ? -geometry.size.width : 0,
                y: moveGradient ? -geometry.size.height : 0
            )
            .animation(
                Animation.linear(duration: 20).repeatForever(autoreverses: false),
                value: moveGradient
            )
            .onAppear {
                moveGradient.toggle()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
