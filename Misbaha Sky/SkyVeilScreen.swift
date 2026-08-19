import SwiftUI

struct SkyVeilScreen: View {
    @State private var glow = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(msHex: 0x1B4A3C), Color(msHex: 0x0C2620)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack(spacing: 22) {
                ZStack {
                    GeometricRosette(tint: MSTheme.gold.opacity(0.45), petals: 12)
                        .frame(width: 150, height: 150)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [MSTheme.goldSoft, MSTheme.gold, Color(msHex: 0x6E5218)],
                                center: .init(x: 0.35, y: 0.3),
                                startRadius: 2,
                                endRadius: 42
                            )
                        )
                        .frame(width: 54, height: 54)
                        .scaleEffect(glow ? 1.06 : 0.94)
                        .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: glow)
                }
                Text("Misbaha Sky")
                    .font(MSTheme.serif(24))
                    .foregroundColor(MSTheme.goldSoft)
            }
        }
        .onAppear { glow = true }
    }
}
