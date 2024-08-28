import SwiftUI

struct FireEffectView: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                FlameShape()
                    .fill(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .bottom, endPoint: .top))
                    .frame(width: 60, height: 60)
                    .scaleEffect(1 - CGFloat(i) * 0.2)
                    .opacity(1 - Double(i) * 0.3)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(i) * 0.1),
                        value: animationAmount
                    )
            }
        }
        .onAppear {
            animationAmount = 1
        }
    }
}

struct FlameShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY),
                      control1: CGPoint(x: rect.minX, y: rect.height * 0.75),
                      control2: CGPoint(x: rect.maxX, y: rect.height * 0.25))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                      control1: CGPoint(x: rect.maxX, y: rect.height * 0.75),
                      control2: CGPoint(x: rect.minX, y: rect.height * 0.25))
        return path
    }
}
