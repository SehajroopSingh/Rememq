import SwiftUI

struct CardView: View {
    let title: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Text(title)
                .font(.headline)
                .padding()
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
