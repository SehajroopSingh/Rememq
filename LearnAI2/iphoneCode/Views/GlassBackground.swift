import SwiftUI

struct GlassBackground: View {
    var cornerRadius: CGFloat = 20
    var opacity: Double = 0.3
    var blurRadius: CGFloat = 20

    var body: some View {
        // Underlying frosted glass look
        Color.white.opacity(opacity)
            .background(.ultraThinMaterial) // or use .regularMaterial for slightly stronger glass
            .blur(radius: blurRadius)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1) // subtle white border
            )
    }
}
