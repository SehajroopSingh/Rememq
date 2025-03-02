import SwiftUI
import Charts

struct ChartView: View {
    var values: [Double]

    var body: some View {
        Chart {
            ForEach(Array(values.enumerated()), id: \.0) { item in
                let index = item.0
                let value = item.1
                
                LineMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                )
                .foregroundStyle(.blue)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
        }
        .frame(height: 200)
        .padding()
    }
}

struct ContentView2: View {
    @State private var values = [3.0, 5.0, 10.0, 7.0, 9.0]

    var body: some View {
        VStack {
            ChartView(values: values)
            
            Button("Change Values") {
                self.values = (0..<5).map { _ in Double.random(in: 0...10) }
            }
            .padding()
        }
    }
}

struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
