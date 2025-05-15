struct BlobbyBackground: View {
    @State private var move = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.purple.opacity(0.3))
                .frame(width: 300, height: 300)
                .offset(x: move ? -150 : 150, y: move ? -200 : 200)
                .blur(radius: 100)

            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 200, height: 200)
                .offset(x: move ? 150 : -100, y: move ? 100 : -150)
                .blur(radius: 100)
        }
        .animation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true), value: move)
        .onAppear {
            move.toggle()
        }
        .edgesIgnoringSafeArea(.all)
    }
}
