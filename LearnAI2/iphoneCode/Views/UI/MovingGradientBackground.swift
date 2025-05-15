import SwiftUI

struct MovingGradientBackground: View {
    @State private var animate = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.purple.opacity(0.4),
                Color.blue.opacity(0.4),
                Color.indigo.opacity(0.4),
                Color.green.opacity(0.3),
                Color("SoftLightGreen"), // Custom color if needed
                Color("SoftPink") // Optional muted pink
            ]),
            startPoint: animate ? .topLeading : .bottomTrailing,
            endPoint: animate ? .bottomTrailing : .topLeading
        )
        .animation(Animation.linear(duration: 12).repeatForever(autoreverses: true), value: animate)
        .onAppear {
            animate.toggle()
        }
        .edgesIgnoringSafeArea(.all)
    }
}
