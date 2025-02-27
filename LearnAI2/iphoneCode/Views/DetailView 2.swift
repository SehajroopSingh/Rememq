//
//  DetailView 2.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 2/5/25.
//
import SwiftUI

// Simple DetailView for UI Testing
struct DetailView: View {
    @State private var isFaded = false
    @State private var isScaled = false
    @State private var isFaded1 = false
    @State private var isTapped = false
    @State private var isRotated = false


    var body: some View {
        VStack(spacing: 20) {
            Text("Test UI Animations")
                .font(.title)
                .bold()
            
            // Animated Text
            Text("Hello, SwiftUI!")
                .font(.largeTitle)
                .opacity(isFaded ? 0.3 : 1) // Fading Animation
                .scaleEffect(isScaled ? 1.5 : 1) // Scaling Animation
                .animation(.easeInOut(duration: 0.5), value: isFaded)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isScaled)
            
            // Toggle Animations
            Button("Fade Text") {
                isFaded.toggle()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("Scale Text") {
                isScaled.toggle()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Text("Fade Effect")
                .opacity(isFaded1 ? 0.2 : 1)
                .animation(.easeInOut(duration: 0.5), value: isFaded1)

            Button("Toggle Fade") {
                isFaded1.toggle()
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isRotated.toggle()
                }
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.largeTitle)
                    .rotationEffect(.degrees(isRotated ? 180 : 0)) // Rotates when pressed
            }
            
            
            
            Button(action: {
                withAnimation(.spring()) {
                    isTapped.toggle()
                }
            }) {
                Text("Tap Me")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .scaleEffect(isTapped ? 0.6 : 1) // Shrinks on tap
            }
        }
        .padding()
        .navigationTitle("Test Page")
    }
}



#Preview {
    DetailView()
}
