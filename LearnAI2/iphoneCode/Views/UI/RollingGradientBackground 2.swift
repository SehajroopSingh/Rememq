import SwiftUI

struct RollingGradientBackground: View {
    @State private var moveGradient = false

    var body: some View {
        GeometryReader { geometry in
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.green.opacity(0.5),
                    Color(red: 0.8, green: 1.0, blue: 0.8) // light green
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
