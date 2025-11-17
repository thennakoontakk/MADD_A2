import SwiftUI

struct WaterBottleView: View {
    @Binding var progress: Double // 0.0 to 1.0
    let bottleHeight: CGFloat
    let bottleWidth: CGFloat
    let showBubbles: Bool
    
    init(progress: Binding<Double>, bottleHeight: CGFloat = 200, bottleWidth: CGFloat = 100, showBubbles: Bool = true) {
        self._progress = progress
        self.bottleHeight = bottleHeight
        self.bottleWidth = bottleWidth
        self.showBubbles = showBubbles
    }
    
    var body: some View {
        ZStack {
            // Bottle outline
            BottleShape()
                .stroke(Color.blue.opacity(0.8), lineWidth: 3)
                .frame(width: bottleWidth, height: bottleHeight)
            
            // Water fill
            BottleShape()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: bottleWidth - 4, height: bottleHeight - 4)
                .scaleEffect(x: 1.0, y: CGFloat(progress), anchor: .bottom)
                .animation(.easeInOut(duration: 0.5), value: progress)
                .clipShape(BottleShape())
            
            // Bubbles animation
            if showBubbles && progress > 0 {
                BubblesView()
                    .frame(width: bottleWidth - 10, height: bottleHeight * CGFloat(progress))
                    .offset(y: bottleHeight * CGFloat(1 - progress) / 2)
                    .opacity(0.6)
            }
            
            // Progress indicator
            VStack {
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 8)
            }
            .frame(width: bottleWidth, height: bottleHeight)
        }
    }
}

struct BottleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Bottle neck
        let neckWidth = width * 0.4
        let neckHeight = height * 0.15
        
        // Bottle body
        let bodyTopY = neckHeight
        let bodyBottomY = height
        let bodyWidth = width
        
        // Start from top center
        path.move(to: CGPoint(x: width / 2, y: 0))
        
        // Left side of neck
        path.addLine(to: CGPoint(x: (width - neckWidth) / 2, y: neckHeight))
        
        // Left side of body (curved)
        path.addQuadCurve(
            to: CGPoint(x: 0, y: bodyBottomY - bodyWidth / 4),
            control: CGPoint(x: 0, y: bodyTopY + (bodyBottomY - bodyTopY) * 0.3)
        )
        
        // Bottom curve
        path.addQuadCurve(
            to: CGPoint(x: width, y: bodyBottomY - bodyWidth / 4),
            control: CGPoint(x: width / 2, y: bodyBottomY)
        )
        
        // Right side of body (curved)
        path.addQuadCurve(
            to: CGPoint(x: width - (width - neckWidth) / 2, y: neckHeight),
            control: CGPoint(x: width, y: bodyTopY + (bodyBottomY - bodyTopY) * 0.3)
        )
        
        // Right side of neck
        path.addLine(to: CGPoint(x: width / 2, y: 0))
        
        path.closeSubpath()
        
        return path
    }
}

struct BubblesView: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<5) { index in
                    Circle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: CGFloat.random(in: 3...8), height: CGFloat.random(in: 3...8))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: animate ? 0 : geometry.size.height
                        )
                        .animation(
                            Animation.linear(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: false)
                                .delay(Double.random(in: 0...2)),
                            value: animate
                        )
                }
            }
            .onAppear {
                animate = true
            }
        }
    }
}

struct WaterBottleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WaterBottleView(progress: .constant(0.3))
                .previewDisplayName("30% Full")
            
            WaterBottleView(progress: .constant(0.7))
                .previewDisplayName("70% Full")
            
            WaterBottleView(progress: .constant(1.0))
                .previewDisplayName("100% Full")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}