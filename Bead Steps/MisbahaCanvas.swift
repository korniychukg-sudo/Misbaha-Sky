import SwiftUI

final class BeadEngine: ObservableObject {
    @Published var committed: Int = 0
    var fraction: Double = 0
    var displayed: Double = 0
    var velocity: Double = 0
    private var lastStep: TimeInterval = 0

    var target: Double { Double(committed) + fraction }

    func reset(to value: Int) {
        committed = value
        fraction = 0
        displayed = Double(value)
        velocity = 0
    }

    func step(now: TimeInterval) {
        if lastStep == 0 { lastStep = now }
        var dt = now - lastStep
        lastStep = now
        if dt <= 0 { return }
        if dt > 0.05 { dt = 0.05 }
        let k = 180.0
        let c = 22.0
        let x = displayed - target
        let a = -k * x - c * velocity
        velocity += a * dt
        displayed += velocity * dt
        if abs(displayed - target) < 0.0005 && abs(velocity) < 0.001 {
            displayed = target
            velocity = 0
        }
    }
}

struct MisbahaStrand: View {
    @ObservedObject var engine: BeadEngine
    let style: BeadStyle
    let sessionTarget: Int
    let onAdvance: () -> Void
    let onSettleBack: () -> Void

    @State private var pull: CGFloat = 0
    @State private var lastTranslation: CGFloat = 0
    @State private var dragging = false

    private let beadsPerDivider = 33

    var body: some View {
        GeometryReader { geo in
            let spacing = beadSpacing(geo.size)
            TimelineView(.animation) { timeline in
                Canvas { ctx, size in
                    engine.step(now: timeline.date.timeIntervalSinceReferenceDate)
                    drawStrand(ctx: ctx, size: size, time: timeline.date.timeIntervalSinceReferenceDate)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !dragging {
                            dragging = true
                            lastTranslation = 0
                        }
                        let delta = value.translation.height - lastTranslation
                        lastTranslation = value.translation.height
                        guard sessionTarget == 0 || engine.committed < sessionTarget else { return }
                        pull += delta
                        if pull < 0 { pull = 0 }
                        var fraction = Double(pull / spacing)
                        while fraction >= 1 {
                            fraction -= 1
                            pull -= spacing
                            advance()
                            if sessionTarget > 0 && engine.committed >= sessionTarget {
                                fraction = 0
                                pull = 0
                                break
                            }
                        }
                        engine.fraction = min(1, max(0, fraction))
                    }
                    .onEnded { _ in
                        dragging = false
                        lastTranslation = 0
                        if engine.fraction >= 0.55,
                           sessionTarget == 0 || engine.committed < sessionTarget {
                            advance()
                        } else if engine.fraction > 0 {
                            BSHaptics.settle()
                            onSettleBack()
                        }
                        engine.fraction = 0
                        pull = 0
                    }
            )
            .onTapGesture {
                guard sessionTarget == 0 || engine.committed < sessionTarget else { return }
                advance()
                engine.fraction = 0
                pull = 0
            }
        }
    }

    private func advance() {
        engine.committed += 1
        onAdvance()
    }

    private func beadSpacing(_ size: CGSize) -> CGFloat {
        let d = beadDiameter(size)
        return d * 1.08
    }

    private func beadDiameter(_ size: CGSize) -> CGFloat {
        min(max(44, size.width * 0.15), 62)
    }

    private func drawStrand(ctx: GraphicsContext, size: CGSize, time: TimeInterval) {
        let d = beadDiameter(size)
        let r = d / 2
        let spacing = d * 1.08
        let anchorY = size.height * 0.46
        let cx = size.width / 2
        let amp = size.width * 0.055
        let sway = sin(time * 0.6) * 2.2

        func xPos(_ y: CGFloat) -> CGFloat {
            cx + sin((y / size.height) * .pi * 1.35 + 0.4) * amp + CGFloat(sway) * (y / size.height)
        }

        let visible = Int(size.height / spacing) + 3
        let lowSlot = Int(floor(engine.displayed)) - visible
        let highSlot = Int(ceil(engine.displayed)) + visible

        var stringPts: [CGPoint] = []
        var yy: CGFloat = -r * 2
        while yy < size.height + r * 2 {
            stringPts.append(CGPoint(x: xPos(yy), y: yy))
            yy += 14
        }
        var stringPath = Path()
        stringPath.addLines(stringPts)
        ctx.stroke(stringPath, with: .color(style.stringColor.opacity(0.85)), lineWidth: 2.4)

        let notch = Path(ellipseIn: CGRect(x: cx - size.width * 0.42, y: anchorY - 1.2, width: size.width * 0.1, height: 2.4))
        ctx.fill(notch, with: .color(BSTheme.gold.opacity(0.5)))
        let notch2 = Path(ellipseIn: CGRect(x: cx + size.width * 0.32, y: anchorY - 1.2, width: size.width * 0.1, height: 2.4))
        ctx.fill(notch2, with: .color(BSTheme.gold.opacity(0.5)))

        for slot in lowSlot...highSlot {
            let y = anchorY + (CGFloat(engine.displayed - Double(slot))) * spacing
            if y < -d || y > size.height + d { continue }
            let x = xPos(y)
            let isDivider = slot > 0 && slot % beadsPerDivider == 0
            let counted = Double(slot) < engine.displayed - 0.5

            if isDivider {
                drawDivider(ctx: ctx, at: CGPoint(x: x, y: y), r: r, counted: counted)
            } else {
                drawBead(ctx: ctx, at: CGPoint(x: x, y: y), r: r, counted: counted, nearAnchor: abs(y - anchorY) < spacing * 0.6)
            }
        }

        let tuftTopY = size.height - r * 0.4
        if tuftTopY > 0 {
            let tx = xPos(size.height + r)
            var tassel = Path()
            for i in 0..<5 {
                let spread = CGFloat(i - 2) * 4.5
                let sway2 = CGFloat(sin(time * 1.1 + Double(i))) * 2.0
                tassel.move(to: CGPoint(x: tx, y: tuftTopY))
                tassel.addQuadCurve(
                    to: CGPoint(x: tx + spread + sway2, y: size.height + 6),
                    control: CGPoint(x: tx + spread * 0.4, y: tuftTopY + 10)
                )
            }
            ctx.stroke(tassel, with: .color(style.deep.opacity(0.45)), lineWidth: 2)
        }
    }

    private func drawBead(ctx: GraphicsContext, at p: CGPoint, r: CGFloat, counted: Bool, nearAnchor: Bool) {
        let rect = CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)
        let dim = counted ? 0.82 : 1.0

        let shadow = Path(ellipseIn: rect.offsetBy(dx: 0, dy: r * 0.12).insetBy(dx: -r * 0.04, dy: -r * 0.04))
        ctx.fill(shadow, with: .color(BSTheme.ink.opacity(0.10)))

        let grad = Gradient(stops: [
            .init(color: style.glint.opacity(dim), location: 0.0),
            .init(color: style.base.opacity(dim), location: 0.45),
            .init(color: style.deep.opacity(dim), location: 1.0)
        ])
        ctx.fill(
            Path(ellipseIn: rect),
            with: .radialGradient(
                grad,
                center: CGPoint(x: p.x - r * 0.35, y: p.y - r * 0.4),
                startRadius: r * 0.1,
                endRadius: r * 1.6
            )
        )

        let hole = Path(ellipseIn: CGRect(x: p.x - r * 0.12, y: p.y - r - 1.2, width: r * 0.24, height: 2.4))
        ctx.fill(hole, with: .color(style.deep.opacity(0.6)))
        let hole2 = Path(ellipseIn: CGRect(x: p.x - r * 0.12, y: p.y + r - 1.2, width: r * 0.24, height: 2.4))
        ctx.fill(hole2, with: .color(style.deep.opacity(0.6)))

        let hl = Path(ellipseIn: CGRect(x: p.x - r * 0.55, y: p.y - r * 0.65, width: r * 0.5, height: r * 0.34))
        ctx.fill(hl, with: .color(.white.opacity(counted ? 0.25 : 0.42)))

        if nearAnchor && !counted {
            let ring = Path(ellipseIn: rect.insetBy(dx: -3.5, dy: -3.5))
            ctx.stroke(ring, with: .color(BSTheme.gold.opacity(0.55)), lineWidth: 1.4)
        }
    }

    private func drawDivider(ctx: GraphicsContext, at p: CGPoint, r: CGFloat, counted: Bool) {
        let w = r * 2.5
        let h = r * 0.95
        let rect = CGRect(x: p.x - w / 2, y: p.y - h / 2, width: w, height: h)
        let dim = counted ? 0.82 : 1.0

        let shadow = Path(roundedRect: rect.offsetBy(dx: 0, dy: 3), cornerRadius: h / 2)
        ctx.fill(shadow, with: .color(BSTheme.ink.opacity(0.10)))

        let grad = Gradient(stops: [
            .init(color: BSTheme.goldSoft.opacity(dim), location: 0.0),
            .init(color: BSTheme.gold.opacity(dim), location: 0.55),
            .init(color: Color(bsHex: 0x7A5A1D).opacity(dim), location: 1.0)
        ])
        ctx.fill(
            Path(roundedRect: rect, cornerRadius: h / 2),
            with: .linearGradient(
                grad,
                startPoint: CGPoint(x: p.x, y: rect.minY),
                endPoint: CGPoint(x: p.x, y: rect.maxY)
            )
        )
        let hl = Path(roundedRect: CGRect(x: rect.minX + 5, y: rect.minY + 2.5, width: rect.width - 10, height: 3), cornerRadius: 1.5)
        ctx.fill(hl, with: .color(.white.opacity(0.4)))
    }
}
