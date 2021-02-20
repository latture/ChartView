import SwiftUI

/// One slice of a `PieChartRow`
struct PieSlice: Identifiable {
    var id = UUID()
    var startDeg: Double
    var endDeg: Double
    var value: Double
}

/// A single row of data, a view in a `PieChart`
public struct PieChartCell: View {
    @State private var show: Bool = false
    var rect: CGRect
    var radius: CGFloat {
        return min(rect.width, rect.height)/2
    }
    var innerRadius: CGFloat {
        0.4 * radius
    }
    var startDeg: Double
	var endDeg: Double

	/// Path representing this slice
    var path: Path {
        var path = Path()
        path.addArc(
            center: rect.mid,
            radius: self.radius,
            startAngle: Angle(degrees: self.startDeg),
            endAngle: Angle(degrees: self.endDeg),
            clockwise: false)
        path.addLine(to: point(radius: self.innerRadius, angle: endDeg))
        path.addArc(
            center: rect.mid,
            radius: self.innerRadius,
            startAngle: Angle(degrees: self.endDeg),
            endAngle: Angle(degrees: self.startDeg),
            clockwise: true)
        path.closeSubpath()
        return path
    }
    
    var label: String {
        String(format: "%.0f%%", percentage)
    }
    
    private var percentage: Double {
        (endDeg - startDeg) / 360 * 100
    }
    
    private func point(radius: CGFloat, angle: Double) -> CGPoint {
    var deltaX = radius * CGFloat(cos(abs(angle).truncatingRemainder(dividingBy: 90.0) * .pi / 180.0))
    var deltaY = radius * CGFloat(sin(abs(angle).truncatingRemainder(dividingBy: 90.0) * .pi / 180.0))
    
    if 90 <= angle && angle < 180 {
        deltaY *= -1
        let dx = deltaX
        let dy = deltaY
        deltaX = dy
        deltaY = dx
    } else if 180 <= angle && angle < 270 {
        deltaX *= -1
        deltaY *= -1
    } else if 270 <= angle && angle < 360 {
        deltaX *= -1
        let dx = deltaX
        let dy = deltaY
        deltaX = dy
        deltaY = dx
    }
    
    return CGPoint(x: rect.midX + deltaX, y: rect.midY + deltaY)
    }
    
    private var labelOffset: CGPoint {
        let angle = startDeg + deltaDeg / 2.0
        return point(radius: 0.6 * radius, angle: angle)
    }
    
    private var deltaDeg: Double {
        endDeg - startDeg
    }
    
    private var isStroked: Bool {
        startDeg != endDeg
    }
    
    var index: Int
    
    // Section line border color
    var backgroundColor: Color = Color(UIColor.systemBackground)
    
    // Section color
    var accentColor: ColorGradient
    
	/// The content and behavior of the `PieChartCell`.
	///
	/// Fills and strokes with 2-pixel line (unless start/end degrees not yet set). Animates by scaling up to 100% when first appears.
    public var body: some View {
        ZStack {
            path
                .fill(self.accentColor.linearGradient(from: .bottom, to: .top))
                .overlay(path.stroke(self.backgroundColor, lineWidth: isStroked ? 2 : 0))
            if percentage > 8 {
                Text(label)
                    .foregroundColor(self.backgroundColor)
                    .position(labelOffset)
            }
        }
        .scaleEffect(self.show ? 1 : 0)
        .animation(Animation.spring().delay(Double(self.index) * 0.04))
        .onAppear {
            self.show = true
        }
    }
}

struct PieChartCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            GeometryReader { geometry in
                PieChartCell(
                    rect: geometry.frame(in: .local),
                    startDeg: 0.0,
                    endDeg: 40.0,
                    index: 0,
                    accentColor: ColorGradient.greenRed)
                }.frame(width: 100, height: 100)
            
            GeometryReader { geometry in
                PieChartCell(
                    rect: geometry.frame(in: .local),
                    startDeg: 90.0,
                    endDeg: 130.0,
                    index: 0,
                    accentColor: ColorGradient.greenRed)
                }.frame(width: 100, height: 100)
            
            GeometryReader { geometry in
                PieChartCell(
                    rect: geometry.frame(in: .local),
                    startDeg: 180,
                    endDeg: 220,
                    index: 0,
                    accentColor: ColorGradient.greenRed)
                }.frame(width: 100, height: 100)
            
            GeometryReader { geometry in
                PieChartCell(
                    rect: geometry.frame(in: .local),
                    startDeg: 270,
                    endDeg: 310,
                    index: 0,
                    accentColor: ColorGradient.greenRed)
                }.frame(width: 100, height: 100)

            GeometryReader { geometry in
            PieChartCell(
                rect: geometry.frame(in: .local),
                startDeg: 185.0,
                endDeg: 290.0,
                index: 1,
                accentColor: ColorGradient(.purple))
            }.frame(width: 100, height: 100)

            GeometryReader { geometry in
            PieChartCell(
                rect: geometry.frame(in: .local),
                startDeg: 0,
                endDeg: 0,
                index: 0,
                backgroundColor: Color.purple,
                accentColor: ColorGradient(.purple))
            }.frame(width: 100, height: 100)
            
        }.previewLayout(.fixed(width: 125, height: 125))
    }
}
