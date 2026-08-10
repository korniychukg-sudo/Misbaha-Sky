import SwiftUI

struct BSChip: View {
    let text: String
    var icon: AnyView? = nil
    var tint: Color = BSTheme.emerald
    var body: some View {
        HStack(spacing: 5) {
            if let icon = icon { icon }
            Text(text)
                .font(BSTheme.text(12, .semibold))
        }
        .foregroundColor(tint)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(tint.opacity(0.12)))
    }
}

struct BSSectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(BSTheme.serif(22))
                .foregroundColor(BSTheme.ink)
            if let s = subtitle {
                Text(s)
                    .font(BSTheme.text(13))
                    .foregroundColor(BSTheme.inkSoft)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ProgressRing: View {
    let progress: Double
    var lineWidth: CGFloat = 6
    var tint: Color = BSTheme.emerald
    var track: Color = BSTheme.line.opacity(0.5)
    var body: some View {
        ZStack {
            Circle().stroke(track, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(max(0, min(1, progress))))
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.25), value: progress)
        }
    }
}

struct WrapStack: View {
    let items: [String]
    var tint: Color = BSTheme.emerald
    var body: some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    BSChip(text: item, tint: tint)
                        .padding(.trailing, 6)
                        .padding(.bottom, 6)
                        .alignmentGuide(.leading) { d in
                            if abs(width - d.width) > geo.size.width {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item == items.last {
                                width = 0
                            } else {
                                width -= d.width
                            }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if item == items.last { height = 0 }
                            return result
                        }
                }
            }
        }
        .frame(height: wrapHeight())
    }
    private func wrapHeight() -> CGFloat {
        let rows = max(1, ceil(Double(items.count) / 3.0))
        return CGFloat(rows) * 34
    }
}

struct BadgeToast: View {
    let badge: BSBadge
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(BSTheme.gold.opacity(0.18)).frame(width: 42, height: 42)
                StarShape(points: 8)
                    .fill(BSTheme.gold)
                    .frame(width: 22, height: 22)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Badge earned")
                    .font(BSTheme.text(11, .semibold))
                    .foregroundColor(BSTheme.inkFaint)
                Text(badge.title)
                    .font(BSTheme.serif(16))
                    .foregroundColor(BSTheme.ink)
                Text(badge.detail)
                    .font(BSTheme.text(12))
                    .foregroundColor(BSTheme.inkSoft)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(BSTheme.card)
                .shadow(color: BSTheme.ink.opacity(0.18), radius: 14, x: 0, y: 6)
        )
        .padding(.horizontal, 20)
    }
}

struct StarShape: Shape {
    var points: Int = 8
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let rOuter = min(rect.width, rect.height) / 2
        let rInner = rOuter * 0.45
        for i in 0..<(points * 2) {
            let angle = (Double(i) * .pi / Double(points)) - .pi / 2
            let r = i % 2 == 0 ? rOuter : rInner
            let p = CGPoint(x: c.x + CGFloat(cos(angle)) * r, y: c.y + CGFloat(sin(angle)) * r)
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        path.closeSubpath()
        return path
    }
}

struct GeometricRosette: View {
    var tint: Color = BSTheme.emerald
    var petals: Int = 8
    var body: some View {
        Canvas { ctx, size in
            let c = CGPoint(x: size.width / 2, y: size.height / 2)
            let r = min(size.width, size.height) / 2 - 2
            var path = Path()
            for i in 0..<petals {
                let a1 = Double(i) * 2 * .pi / Double(petals)
                let a2 = Double(i + 1) * 2 * .pi / Double(petals)
                let p1 = CGPoint(x: c.x + CGFloat(cos(a1)) * r, y: c.y + CGFloat(sin(a1)) * r)
                let p2 = CGPoint(x: c.x + CGFloat(cos(a2)) * r, y: c.y + CGFloat(sin(a2)) * r)
                path.move(to: p1)
                path.addQuadCurve(to: p2, control: c)
            }
            ctx.stroke(path, with: .color(tint), lineWidth: 1.2)
            ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)), with: .color(tint.opacity(0.6)), lineWidth: 1)
        }
    }
}

struct ScalePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension View {
    func bsScreenBackground() -> some View {
        ZStack {
            BSTheme.paper.ignoresSafeArea()
            self
        }
    }
}
