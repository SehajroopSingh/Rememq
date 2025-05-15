struct MovingGradientBackground: View {
    @State private var animate = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.purple, .blue, .indigo, .pink]),
            startPoint: animate ? .topLeading : .bottomTrailing,
            endPoint: animate ? .bottomTrailing : .topLeading
        )
        .animation(Animation.linear(duration: 10).repeatForever(autoreverses: true), value: animate)
        .onAppear {
            animate.toggle()
        }
        .edgesIgnoringSafeArea(.all)
    }
}
