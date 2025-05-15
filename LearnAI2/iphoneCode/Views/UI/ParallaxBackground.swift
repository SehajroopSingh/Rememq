import CoreMotion

struct ParallaxBackground: View {
    @State private var xTilt: CGFloat = 0
    @State private var yTilt: CGFloat = 0
    let motion = CMMotionManager()

    var body: some View {
        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .offset(x: xTilt * 20, y: yTilt * 20)
            .onAppear {
                motion.deviceMotionUpdateInterval = 1/60
                motion.startDeviceMotionUpdates(to: .main) { data, _ in
                    guard let data = data else { return }
                    xTilt = CGFloat(data.attitude.roll)
                    yTilt = CGFloat(data.attitude.pitch)
                }
            }
            .edgesIgnoringSafeArea(.all)
    }
}
