import SwiftUI

struct BeadsIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let cx = w / 2
            let r = w * 0.13
            let ys: [CGFloat] = [0.14, 0.38, 0.62, 0.86]
            var string = Path()
            string.move(to: CGPoint(x: cx - w * 0.06, y: 0))
            string.addQuadCurve(to: CGPoint(x: cx + w * 0.05, y: sz.height), control: CGPoint(x: cx + w * 0.14, y: sz.height * 0.5))
            ctx.stroke(string, with: .color(color.opacity(0.6)), lineWidth: 1.4)
            for (i, t) in ys.enumerated() {
                let y = sz.height * t
                let x = cx + sin(CGFloat(i) * 1.5) * w * 0.07
                let rect = CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2)
                if i == 2 {
                    let d = CGRect(x: x - r * 1.35, y: y - r * 0.62, width: r * 2.7, height: r * 1.24)
                    ctx.fill(Path(roundedRect: d, cornerRadius: r * 0.62), with: .color(color))
                } else {
                    ctx.fill(Path(ellipseIn: rect), with: .color(color))
                    ctx.fill(
                        Path(ellipseIn: CGRect(x: x - r * 0.45, y: y - r * 0.55, width: r * 0.5, height: r * 0.35)),
                        with: .color(.white.opacity(0.5))
                    )
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct SetsIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            let arch = Path { p in
                p.move(to: CGPoint(x: w * 0.15, y: h * 0.92))
                p.addLine(to: CGPoint(x: w * 0.15, y: h * 0.42))
                p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.08), control: CGPoint(x: w * 0.16, y: h * 0.1))
                p.addQuadCurve(to: CGPoint(x: w * 0.85, y: h * 0.42), control: CGPoint(x: w * 0.84, y: h * 0.1))
                p.addLine(to: CGPoint(x: w * 0.85, y: h * 0.92))
            }
            ctx.stroke(arch, with: .color(color), style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
            var base = Path()
            base.move(to: CGPoint(x: w * 0.08, y: h * 0.92))
            base.addLine(to: CGPoint(x: w * 0.92, y: h * 0.92))
            ctx.stroke(base, with: .color(color), style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
            var lamp = Path()
            lamp.move(to: CGPoint(x: w * 0.5, y: h * 0.3))
            lamp.addLine(to: CGPoint(x: w * 0.5, y: h * 0.44))
            ctx.stroke(lamp, with: .color(color), lineWidth: 1.4)
            ctx.fill(Path(ellipseIn: CGRect(x: w * 0.44, y: h * 0.44, width: w * 0.12, height: w * 0.15)), with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

struct NamesIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let c = CGPoint(x: sz.width / 2, y: sz.height / 2)
            let rO = sz.width * 0.46
            let rI = sz.width * 0.3
            var star = Path()
            for i in 0..<16 {
                let a = Double(i) * .pi / 8 - .pi / 2
                let r = i % 2 == 0 ? rO : rI
                let p = CGPoint(x: c.x + CGFloat(cos(a)) * r, y: c.y + CGFloat(sin(a)) * r)
                if i == 0 { star.move(to: p) } else { star.addLine(to: p) }
            }
            star.closeSubpath()
            ctx.stroke(star, with: .color(color), style: StrokeStyle(lineWidth: 1.6, lineJoin: .round))
            ctx.fill(Path(ellipseIn: CGRect(x: c.x - 2.5, y: c.y - 2.5, width: 5, height: 5)), with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

struct LearnIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            var left = Path()
            left.move(to: CGPoint(x: w * 0.5, y: h * 0.22))
            left.addQuadCurve(to: CGPoint(x: w * 0.1, y: h * 0.18), control: CGPoint(x: w * 0.28, y: h * 0.06))
            left.addLine(to: CGPoint(x: w * 0.1, y: h * 0.78))
            left.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.86), control: CGPoint(x: w * 0.3, y: h * 0.72))
            left.closeSubpath()
            var right = Path()
            right.move(to: CGPoint(x: w * 0.5, y: h * 0.22))
            right.addQuadCurve(to: CGPoint(x: w * 0.9, y: h * 0.18), control: CGPoint(x: w * 0.72, y: h * 0.06))
            right.addLine(to: CGPoint(x: w * 0.9, y: h * 0.78))
            right.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.86), control: CGPoint(x: w * 0.7, y: h * 0.72))
            right.closeSubpath()
            ctx.stroke(left, with: .color(color), style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))
            ctx.stroke(right, with: .color(color), style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))
            var spine = Path()
            spine.move(to: CGPoint(x: w * 0.5, y: h * 0.22))
            spine.addLine(to: CGPoint(x: w * 0.5, y: h * 0.86))
            ctx.stroke(spine, with: .color(color.opacity(0.7)), lineWidth: 1.2)
        }
        .frame(width: size, height: size)
    }
}

struct JournalIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            let frame = CGRect(x: w * 0.12, y: h * 0.16, width: w * 0.76, height: h * 0.72)
            ctx.stroke(Path(roundedRect: frame, cornerRadius: 4), with: .color(color), lineWidth: 1.7)
            for i in 0..<3 {
                for j in 0..<3 {
                    let x = frame.minX + frame.width * (0.22 + 0.28 * CGFloat(j))
                    let y = frame.minY + frame.height * (0.28 + 0.26 * CGFloat(i))
                    let filled = (i * 3 + j) < 5
                    let dot = CGRect(x: x - 2.2, y: y - 2.2, width: 4.4, height: 4.4)
                    if filled {
                        ctx.fill(Path(ellipseIn: dot), with: .color(color))
                    } else {
                        ctx.stroke(Path(ellipseIn: dot), with: .color(color.opacity(0.6)), lineWidth: 1)
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct ChevronIcon: View {
    var size: CGFloat = 12
    var color: Color = BSTheme.inkFaint
    var body: some View {
        Canvas { ctx, sz in
            var p = Path()
            p.move(to: CGPoint(x: sz.width * 0.3, y: sz.height * 0.15))
            p.addLine(to: CGPoint(x: sz.width * 0.72, y: sz.height * 0.5))
            p.addLine(to: CGPoint(x: sz.width * 0.3, y: sz.height * 0.85))
            ctx.stroke(p, with: .color(color), style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct CheckIcon: View {
    var size: CGFloat = 14
    var color: Color = BSTheme.emerald
    var body: some View {
        Canvas { ctx, sz in
            var p = Path()
            p.move(to: CGPoint(x: sz.width * 0.15, y: sz.height * 0.55))
            p.addLine(to: CGPoint(x: sz.width * 0.4, y: sz.height * 0.8))
            p.addLine(to: CGPoint(x: sz.width * 0.85, y: sz.height * 0.22))
            ctx.stroke(p, with: .color(color), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct HeartIcon: View {
    var size: CGFloat = 16
    var color: Color = BSTheme.terra
    var filled: Bool = false
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            var p = Path()
            p.move(to: CGPoint(x: w * 0.5, y: h * 0.85))
            p.addCurve(to: CGPoint(x: w * 0.08, y: h * 0.32), control1: CGPoint(x: w * 0.22, y: h * 0.68), control2: CGPoint(x: w * 0.08, y: h * 0.52))
            p.addArc(center: CGPoint(x: w * 0.29, y: h * 0.32), radius: w * 0.21, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            p.addArc(center: CGPoint(x: w * 0.71, y: h * 0.32), radius: w * 0.21, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            p.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.85), control1: CGPoint(x: w * 0.92, y: h * 0.52), control2: CGPoint(x: w * 0.78, y: h * 0.68))
            p.closeSubpath()
            if filled {
                ctx.fill(p, with: .color(color))
            } else {
                ctx.stroke(p, with: .color(color), style: StrokeStyle(lineWidth: 1.6, lineJoin: .round))
            }
        }
        .frame(width: size, height: size)
    }
}
