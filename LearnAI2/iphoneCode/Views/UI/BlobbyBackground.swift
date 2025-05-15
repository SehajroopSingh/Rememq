import SwiftUI

struct BlobbyBackground: View {
    @State private var moveBlob1 = false
    @State private var moveBlob2 = false
    @State private var moveBlob3 = false
    @State private var moveBlob4 = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 225/255, green: 230/255, blue: 245/255) // soft icy lavender-blue
                    .edgesIgnoringSafeArea(.all)


//                LinearGradient(
//                    gradient: Gradient(colors: [
//                        Color(red: 240/255, green: 245/255, blue: 240/255), // top
//                        Color(red: 220/255, green: 230/255, blue: 225/255)  // bottom
//                    ]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
                .edgesIgnoringSafeArea(.all)
                // 🟣 Blob 1 - Top third
                Circle()
                    .fill(Color.purple.opacity(0.5))
                    .frame(width: 300, height: 300)
                    .position(
                        x: moveBlob1 ? geo.size.width * 0.3 : geo.size.width * 0.7,
                        y: geo.size.height * 0.2
                    )
                    .blur(radius: 100)
                    .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: moveBlob1)

                // 🔵 Blob 2 - Middle third
                Circle()
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 200, height: 200)
                    .position(
                        x: moveBlob2 ? geo.size.width * 0.75 : geo.size.width * 0.25,
                        y: geo.size.height * 0.5
                    )
                    .blur(radius: 100)
                    .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: moveBlob2)

                // 🟢 Blob 3 - Bottom right
                Circle()
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 250, height: 250)
                    .position(
                        x: moveBlob3 ? geo.size.width * 0.2 : geo.size.width * 0.8,
                        y: geo.size.height * 0.8
                    )
                    .blur(radius: 100)
                    .animation(.easeInOut(duration: 12).repeatForever(autoreverses: true), value: moveBlob3)

//                // 🟠 Blob 4 - Bottom left (NEW)
//                Circle()
//                    .fill(Color.purple.opacity(0.25))
//                    .frame(width: 220, height: 220)
//                    .position(
//                        x: moveBlob4 ? geo.size.width * 0.15 : geo.size.width * 0.35,
//                        y: geo.size.height * 0.85
//                    )
//                    .blur(radius: 100)
//                    .animation(.easeInOut(duration: 11).repeatForever(autoreverses: true), value: moveBlob4)
            }
            .onAppear {
                moveBlob1.toggle()
                moveBlob2.toggle()
                moveBlob3.toggle()
                moveBlob4.toggle()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
