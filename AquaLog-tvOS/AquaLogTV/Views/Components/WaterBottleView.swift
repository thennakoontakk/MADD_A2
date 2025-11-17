import SwiftUI

struct WaterBottleView: View {
    @Binding var progress: Double
    let bottleHeight: CGFloat
    let bottleWidth: CGFloat
    let showBubbles: Bool

    init(progress: Binding<Double>, bottleHeight: CGFloat = 300, bottleWidth: CGFloat = 150, showBubbles: Bool = true) {
        self._progress = progress
        self.bottleHeight = bottleHeight
        self.bottleWidth = bottleWidth
        self.showBubbles = showBubbles
    }

    var body: some View {
        ZStack {
            BottleShape()
                .stroke(Color.blue.opacity(0.8), lineWidth: 4)
                .frame(width: bottleWidth, height: bottleHeight)

            BottleShape()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: bottleWidth - 6, height: bottleHeight - 6)
                .scaleEffect(x: 1.0, y: CGFloat(progress), anchor: .bottom)
                .animation(.easeInOut(duration: 0.5), value: progress)
                .clipShape(BottleShape())

            if showBubbles && progress > 0 {
                BubblesView()
                    .frame(width: bottleWidth - 12, height: bottleHeight * CGFloat(progress))
                    .offset(y: bottleHeight * CGFloat(1 - progress) / 2)
                    .opacity(0.6)
            }

            VStack {
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 24, weight: .semibold))
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

        let neckWidth = width * 0.4
        let neckHeight = height * 0.15

        let bodyTopY = neckHeight
        let bodyBottomY = height
        let bodyWidth = width

        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: (width - neckWidth) / 2, y: neckHeight))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: bodyBottomY - bodyWidth / 4),
            control: CGPoint(x: 0, y: bodyTopY + (bodyBottomY - bodyTopY) * 0.3)
        )
        path.addQuadCurve(
            to: CGPoint(x: width, y: bodyBottomY - bodyWidth / 4),
            control: CGPoint(x: width / 2, y: bodyBottomY)
        )
        path.addQuadCurve(
            to: CGPoint(x: width - (width - neckWidth) / 2, y: neckHeight),
            control: CGPoint(x: width, y: bodyTopY + (bodyBottomY - bodyTopY) * 0.3)
        )
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
                ForEach(0..<8) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: CGFloat.random(in: 4...10), height: CGFloat.random(in: 4...10))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: animate ? 0 : geometry.size.height
                        )
                        .animation(
                            Animation.linear(duration: Double.random(in: 2.5...4.5))
                                .repeatForever(autoreverses: false)
                                .delay(Double.random(in: 0...2)),
                            value: animate
                        )
                }
            }
            .onAppear { animate = true }
        }
    }
}