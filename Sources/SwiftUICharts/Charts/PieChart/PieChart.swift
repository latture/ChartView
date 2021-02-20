import SwiftUI

/// A type of chart that displays a slice of "pie" for each data point
public struct PieChart: View, ChartBase {
    public var chartData = ChartData()

    @EnvironmentObject var data: ChartData
    @EnvironmentObject var style: ChartStyle

	/// The content and behavior of the `PieChart`.
	///
	///
    public var body: some View {
        PieChartRow(chartData: data, style: style)
    }

    public init() {}
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            GeometryReader { geometry in
                CardView(showShadow: false) {
                    PieChart()
                }
                .data([1, 1, 5])
                .chartStyle(ChartStyle(backgroundColor: Color(UIColor.systemBackground), foregroundColor: [ColorGradient(Color(UIColor.systemBlue)), ColorGradient(Color(UIColor.systemOrange)), ColorGradient(Color(UIColor.systemGreen))]))
                .font(Font.caption)
            }.frame(width: 120, height: 120)
            
        }.previewLayout(.fixed(width: 125, height: 125))
    }
}
