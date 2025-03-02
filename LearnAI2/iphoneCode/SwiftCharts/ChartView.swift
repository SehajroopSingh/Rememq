import SwiftUI
import SwiftCharts

struct ChartView: UIViewRepresentable {
    var values: [Double]

    func makeUIView(context: Context) -> LineChartView {
        // Create the chart model
        let chartModel = ChartSettings()
        let frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        
        let labelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 14))
        let lineModel = ChartLineModel(
            chartPoints: values.enumerated().map { ChartPoint(x: ChartAxisValueDouble(Double($0)), y: ChartAxisValueDouble($1)) },
            lineColor: UIColor.blue,
            lineWidth: 2
        )
        
        let xAxisModel = ChartAxisModel(fromMin: ChartAxisValueDouble(0), toMax: ChartAxisValueDouble(values.count - 1), byIntValue: 1, labelSettings: labelSettings)
        let yAxisModel = ChartAxisModel(fromMin: ChartAxisValueDouble(0), toMax: ChartAxisValueDouble(values.max() ?? 0), byIntValue: 1, labelSettings: labelSettings)
        
        let chart = LineChart(
            frame,
            xModel: xAxisModel,
            yModel: yAxisModel,
            chartSettings: chartModel,
            lines: [lineModel],
            animPolicy: AnimPolicy(duration: 2),
            innerFrame: nil
        )
        
        return LineChartView(chart: chart)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the UI if necessary
    }
}

struct ContentView: View {
    @State private var values = [3.0, 5.0, 10.0, 7.0, 9.0]

    var body: some View {
        VStack {
            ChartView(values: values)
            
            Button("Change Values") {
                // Generate new random values
                self.values = (0..<5).map { Double.random(in: 0...10) }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
