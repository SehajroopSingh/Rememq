import SwiftUI

struct RollingGradientBackground: View {
    @State private var angle: Double = 0

    var body: some View {
        AngularGradient(
            gradient: Gradient(colors: [
                Color.green.opacity(0.4),
                Color("SoftLightGreen")
            ]),
            center: .center
        )
        .rotationEffect(.degrees(angle))
        .animation(Animation.linear(duration: 60).repeatForever(autoreverses: false), value: angle)
        .onAppear {
            angle = 360
        }
        .edgesIgnoringSafeArea(.all)
    }
}
