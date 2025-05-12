import SwiftUI

struct AnimatedSplashView: View {
    @Binding var isActive: Bool
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.5

    var body: some View {
        VStack {
            Image(systemName: "bolt.fill")  // Replace with your logo/image
                .resizable()
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        scale = 1.0
                        opacity = 1.0
                    }

                    // Delay before transitioning to RootView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            isActive = false
                        }
                    }
                }
            Text("LearnAI")
                .font(.largeTitle)
                .bold()
                .opacity(opacity)
        }
    }
}
