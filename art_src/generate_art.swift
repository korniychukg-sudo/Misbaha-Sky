import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

struct Rand {
    var state: UInt64
    init(_ seed: UInt64) { state = seed &* 6364136223846793005 &+ 1442695040888963407 }
    mutating func next() -> Double {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return Double(state % 100000) / 100000.0
    }
    mutating func range(_ a: Double, _ b: Double) -> Double { a + (b - a) * next() }
    mutating func int(_ a: Int, _ b: Int) -> Int { a + Int(next() * Double(b - a + 1)) % (b - a + 1) }
}

struct Col {
    let r: CGFloat, g: CGFloat, b: CGFloat
    func cg(_ a: CGFloat = 1) -> CGColor {
        CGColor(red: r, green: g, blue: b, alpha: a)
    }
    func mix(_ o: Col, _ t: CGFloat) -> Col {
        Col(r: r + (o.r - r) * t, g: g + (o.g - g) * t, b: b + (o.b - b) * t)
    }
}

enum Pal {
    static let paper = Col(r: 0.964, g: 0.937, b: 0.881)
    static let paperDark = Col(r: 0.929, g: 0.894, b: 0.815)
    static let ink = Col(r: 0.165, g: 0.141, b: 0.098)
    static let inkSoft = Col(r: 0.36, g: 0.325, b: 0.26)
    static let emerald = Col(r: 0.118, g: 0.361, b: 0.294)
    static let emeraldDeep = Col(r: 0.075, g: 0.243, b: 0.2)
    static let gold = Col(r: 0.725, g: 0.561, b: 0.208)
    static let goldSoft = Col(r: 0.882, g: 0.796, b: 0.576)
    static let terra = Col(r: 0.659, g: 0.357, b: 0.216)
    static let dusk = Col(r: 0.376, g: 0.322, b: 0.404)
    static let sky = Col(r: 0.878, g: 0.835, b: 0.729)
}

final class Plate {
    let w: Int
    let h: Int
    let ctx: CGContext
    var rng: Rand

    init(w: Int, h: Int, seed: UInt64, scale: CGFloat = 2.0) {
        self.w = w
        self.h = h
        rng = Rand(seed)
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        ctx = CGContext(
            data: nil, width: Int(CGFloat(w) * scale), height: Int(CGFloat(h) * scale),
            bitsPerComponent: 8, bytesPerRow: 0,
            space: cs, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )!
        ctx.scaleBy(x: scale, y: scale)
    }

    var W: CGFloat { CGFloat(w) }
    var H: CGFloat { CGFloat(h) }

    func paper(_ base: Col = Pal.paper, bottom: Col? = nil) {
        let b = bottom ?? base.mix(Pal.paperDark, 0.7)
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let grad = CGGradient(colorsSpace: cs, colors: [base.cg(), b.cg()] as CFArray, locations: [0, 1])!
        ctx.drawLinearGradient(grad, start: CGPoint(x: 0, y: H), end: CGPoint(x: 0, y: 0), options: [])
    }

    func skyGradient(_ top: Col, _ bottom: Col, toY: CGFloat) {
        ctx.saveGState()
        ctx.clip(to: CGRect(x: 0, y: toY, width: W, height: H - toY))
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let grad = CGGradient(colorsSpace: cs, colors: [top.cg(), bottom.cg()] as CFArray, locations: [0, 1])!
        ctx.drawLinearGradient(grad, start: CGPoint(x: 0, y: H), end: CGPoint(x: 0, y: toY), options: [])
        ctx.restoreGState()
    }

    func grain(_ amount: Int = 52000, alpha: CGFloat = 0.06) {
        for _ in 0..<amount {
            let x = rng.range(0, Double(w))
            let y = rng.range(0, Double(h))
            let s = rng.range(0.6, 2.2)
            let dark = rng.next() > 0.45
            ctx.setFillColor((dark ? Pal.ink : Col(r: 1, g: 1, b: 1)).cg(alpha * CGFloat(rng.range(0.4, 1))))
            ctx.fillEllipse(in: CGRect(x: x, y: y, width: s, height: s))
        }
    }

    func fibers(_ count: Int = 150) {
        for _ in 0..<count {
            let x = rng.range(0, Double(w))
            let y = rng.range(0, Double(h))
            let len = rng.range(8, 34)
            let ang = rng.range(0, .pi * 2)
            ctx.setStrokeColor(Pal.inkSoft.cg(CGFloat(rng.range(0.02, 0.06))))
            ctx.setLineWidth(0.8)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: x, y: y))
            ctx.addLine(to: CGPoint(x: x + cos(ang) * len, y: y + sin(ang) * len))
            ctx.strokePath()
        }
    }

    func vignette() {
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let grad = CGGradient(
            colorsSpace: cs,
            colors: [Pal.ink.cg(0), Pal.ink.cg(0.13)] as CFArray,
            locations: [0.62, 1]
        )!
        ctx.drawRadialGradient(
            grad,
            startCenter: CGPoint(x: W / 2, y: H / 2), startRadius: 0,
            endCenter: CGPoint(x: W / 2, y: H / 2), endRadius: max(W, H) * 0.72,
            options: []
        )
    }

    func frame(inset: CGFloat = 40, color: Col = Pal.ink) {
        ctx.setStrokeColor(color.cg(0.75))
        ctx.setLineWidth(3)
        ctx.stroke(CGRect(x: inset, y: inset, width: W - inset * 2, height: H - inset * 2))
        ctx.setLineWidth(1.2)
        ctx.stroke(CGRect(x: inset + 10, y: inset + 10, width: W - inset * 2 - 20, height: H - inset * 2 - 20))
    }

    func stroke(_ path: CGPath, _ col: Col, _ width: CGFloat, alpha: CGFloat = 1) {
        ctx.saveGState()
        ctx.addPath(path)
        ctx.setStrokeColor(col.cg(alpha))
        ctx.setLineWidth(width)
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)
        ctx.strokePath()
        ctx.restoreGState()
    }

    func fill(_ path: CGPath, _ col: Col, alpha: CGFloat = 1) {
        ctx.saveGState()
        ctx.addPath(path)
        ctx.setFillColor(col.cg(alpha))
        ctx.fillPath()
        ctx.restoreGState()
    }

    func hatch(_ clip: CGPath, angle: CGFloat, spacing: CGFloat, col: Col, width: CGFloat = 1.6, alpha: CGFloat = 0.5, jitter: Double = 1.6) {
        ctx.saveGState()
        ctx.addPath(clip)
        ctx.clip()
        let diag = sqrt(W * W + H * H)
        let dirX = cos(angle), dirY = sin(angle)
        let perpX = -dirY, perpY = dirX
        var offset: CGFloat = -diag
        ctx.setStrokeColor(col.cg(alpha))
        ctx.setLineWidth(width)
        while offset < diag {
            let cx = W / 2 + perpX * offset
            let cy = H / 2 + perpY * offset
            ctx.beginPath()
            let j1 = CGFloat(rng.range(-jitter, jitter))
            let j2 = CGFloat(rng.range(-jitter, jitter))
            ctx.move(to: CGPoint(x: cx - dirX * diag + j1, y: cy - dirY * diag + j1))
            ctx.addLine(to: CGPoint(x: cx + dirX * diag + j2, y: cy + dirY * diag + j2))
            ctx.strokePath()
            offset += spacing + CGFloat(rng.range(-jitter, jitter))
        }
        ctx.restoreGState()
    }

    func inkLine(from a: CGPoint, to b: CGPoint, _ col: Col, _ width: CGFloat, alpha: CGFloat = 1) {
        ctx.setStrokeColor(col.cg(alpha))
        ctx.setLineWidth(width)
        ctx.setLineCap(.round)
        ctx.beginPath()
        ctx.move(to: a)
        ctx.addLine(to: b)
        ctx.strokePath()
    }

    func disc(center: CGPoint, r: CGFloat, col: Col, alpha: CGFloat = 1) {
        ctx.setFillColor(col.cg(alpha))
        ctx.fillEllipse(in: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2))
    }

    func ring(center: CGPoint, r: CGFloat, col: Col, width: CGFloat, alpha: CGFloat = 1) {
        ctx.setStrokeColor(col.cg(alpha))
        ctx.setLineWidth(width)
        ctx.strokeEllipse(in: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2))
    }

    func save(_ name: String, quality: CGFloat = 0.9, dir: String) {
        let img = ctx.makeImage()!
        let url = URL(fileURLWithPath: "\(dir)/\(name).jpg") as CFURL
        let dest = CGImageDestinationCreateWithURL(url, UTType.jpeg.identifier as CFString, 1, nil)!
        CGImageDestinationAddImage(dest, img, [kCGImageDestinationLossyCompressionQuality: quality] as CFDictionary)
        CGImageDestinationFinalize(dest)
        print("saved \(name)")
    }
}

func starPolygon(center: CGPoint, points: Int, rOuter: CGFloat, rInner: CGFloat, rotation: CGFloat = 0) -> CGPath {
    let p = CGMutablePath()
    for i in 0..<(points * 2) {
        let a = CGFloat(i) * .pi / CGFloat(points) + rotation - .pi / 2
        let r = i % 2 == 0 ? rOuter : rInner
        let pt = CGPoint(x: center.x + cos(a) * r, y: center.y + sin(a) * r)
        if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
    }
    p.closeSubpath()
    return p
}

func archPath(cx: CGFloat, baseY: CGFloat, width: CGFloat, height: CGFloat) -> CGPath {
    let p = CGMutablePath()
    let half = width / 2
    let shoulderY = baseY + height * 0.62
    p.move(to: CGPoint(x: cx - half, y: baseY))
    p.addLine(to: CGPoint(x: cx - half, y: shoulderY))
    p.addQuadCurve(to: CGPoint(x: cx, y: baseY + height), control: CGPoint(x: cx - half * 0.92, y: baseY + height * 1.02))
    p.addQuadCurve(to: CGPoint(x: cx + half, y: shoulderY), control: CGPoint(x: cx + half * 0.92, y: baseY + height * 1.02))
    p.addLine(to: CGPoint(x: cx + half, y: baseY))
    return p
}

func lampPath(cx: CGFloat, topY: CGFloat, size: CGFloat) -> (body: CGPath, chain: CGPath) {
    let chain = CGMutablePath()
    chain.move(to: CGPoint(x: cx, y: topY))
    chain.addLine(to: CGPoint(x: cx, y: topY - size * 0.5))
    let body = CGMutablePath()
    let bw = size * 0.52
    let bh = size
    let y0 = topY - size * 0.5
    body.move(to: CGPoint(x: cx - bw * 0.18, y: y0))
    body.addLine(to: CGPoint(x: cx + bw * 0.18, y: y0))
    body.addLine(to: CGPoint(x: cx + bw * 0.32, y: y0 - bh * 0.14))
    body.addCurve(
        to: CGPoint(x: cx + bw * 0.2, y: y0 - bh * 0.72),
        control1: CGPoint(x: cx + bw * 0.62, y: y0 - bh * 0.34),
        control2: CGPoint(x: cx + bw * 0.52, y: y0 - bh * 0.6)
    )
    body.addLine(to: CGPoint(x: cx + bw * 0.12, y: y0 - bh * 0.88))
    body.addLine(to: CGPoint(x: cx - bw * 0.12, y: y0 - bh * 0.88))
    body.addLine(to: CGPoint(x: cx - bw * 0.2, y: y0 - bh * 0.72))
    body.addCurve(
        to: CGPoint(x: cx - bw * 0.32, y: y0 - bh * 0.14),
        control1: CGPoint(x: cx - bw * 0.52, y: y0 - bh * 0.6),
        control2: CGPoint(x: cx - bw * 0.62, y: y0 - bh * 0.34)
    )
    body.closeSubpath()
    return (body, chain)
}

func beadStrandPath(points: [CGPoint]) -> CGPath {
    let p = CGMutablePath()
    guard points.count > 1 else { return p }
    p.move(to: points[0])
    for i in 1..<points.count {
        let prev = points[i - 1]
        let cur = points[i]
        let mid = CGPoint(x: (prev.x + cur.x) / 2, y: (prev.y + cur.y) / 2)
        p.addQuadCurve(to: mid, control: prev)
    }
    p.addLine(to: points.last!)
    return p
}

final class Scenes {
    let dir: String
    init(dir: String) { self.dir = dir }

    func domePath(cx: CGFloat, baseY: CGFloat, r: CGFloat) -> CGPath {
        let d = CGMutablePath()
        d.move(to: CGPoint(x: cx - r, y: baseY))
        d.addCurve(
            to: CGPoint(x: cx - r * 0.14, y: baseY + r * 1.72),
            control1: CGPoint(x: cx - r * 1.16, y: baseY + r * 1.06),
            control2: CGPoint(x: cx - r * 0.52, y: baseY + r * 1.5)
        )
        d.addQuadCurve(to: CGPoint(x: cx + r * 0.14, y: baseY + r * 1.72), control: CGPoint(x: cx, y: baseY + r * 1.86))
        d.addCurve(
            to: CGPoint(x: cx + r, y: baseY),
            control1: CGPoint(x: cx + r * 0.52, y: baseY + r * 1.5),
            control2: CGPoint(x: cx + r * 1.16, y: baseY + r * 1.06)
        )
        d.closeSubpath()
        return d
    }

    func mosqueBlock(_ p: Plate, x: CGFloat, baseY: CGFloat, bw: CGFloat, col: Col) {
        let bh = bw * 0.34
        let body = CGPath(rect: CGRect(x: x, y: baseY, width: bw, height: bh), transform: nil)
        p.fill(body, col, alpha: 0.12)
        p.hatch(body, angle: .pi / 2.9, spacing: 8, col: col, width: 1.2, alpha: 0.5)
        p.stroke(body, Pal.ink, 3, alpha: 0.85)
        var wx = x + bw * 0.14
        while wx < x + bw * 0.9 {
            let win = archPath(cx: wx, baseY: baseY + bh * 0.2, width: bw * 0.09, height: bh * 0.42)
            p.fill(win, col, alpha: 0.55)
            p.stroke(win, Pal.ink, 1.4, alpha: 0.7)
            wx += bw * 0.19
        }
        let drumW = bw * 0.36
        let drum = CGPath(rect: CGRect(x: x + bw / 2 - drumW / 2, y: baseY + bh, width: drumW, height: bh * 0.22), transform: nil)
        p.fill(drum, col, alpha: 0.12)
        p.hatch(drum, angle: .pi / 2.9, spacing: 7, col: col, width: 1.1, alpha: 0.5)
        p.stroke(drum, Pal.ink, 2.4, alpha: 0.85)
        let dome = domePath(cx: x + bw / 2, baseY: baseY + bh * 1.22, r: drumW * 0.62)
        p.fill(dome, col, alpha: 0.16)
        p.hatch(dome, angle: .pi / 3.4, spacing: 6.5, col: col, width: 1.1, alpha: 0.55)
        p.stroke(dome, Pal.ink, 2.8, alpha: 0.9)
        let tipY = baseY + bh * 1.22 + drumW * 0.62 * 1.86
        p.inkLine(from: CGPoint(x: x + bw / 2, y: tipY), to: CGPoint(x: x + bw / 2, y: tipY + bw * 0.07), Pal.ink, 2.2, alpha: 0.9)
        p.ring(center: CGPoint(x: x + bw / 2, y: tipY + bw * 0.09), r: bw * 0.018, col: Pal.ink, width: 1.6, alpha: 0.9)
    }

    func minaret(_ p: Plate, x: CGFloat, baseY: CGFloat, mh: CGFloat, col: Col) {
        let mw = mh * 0.12
        let shaft = CGMutablePath()
        shaft.move(to: CGPoint(x: x - mw * 0.6, y: baseY))
        shaft.addLine(to: CGPoint(x: x - mw * 0.42, y: baseY + mh * 0.72))
        shaft.addLine(to: CGPoint(x: x + mw * 0.42, y: baseY + mh * 0.72))
        shaft.addLine(to: CGPoint(x: x + mw * 0.6, y: baseY))
        shaft.closeSubpath()
        p.fill(shaft, col, alpha: 0.14)
        p.hatch(shaft, angle: .pi / 2.6, spacing: 6, col: col, width: 1.1, alpha: 0.55)
        p.stroke(shaft, Pal.ink, 2.6, alpha: 0.9)
        let balc = CGRect(x: x - mw * 0.75, y: baseY + mh * 0.72, width: mw * 1.5, height: mh * 0.045)
        p.fill(CGPath(rect: balc, transform: nil), col, alpha: 0.5)
        p.stroke(CGPath(rect: balc, transform: nil), Pal.ink, 2, alpha: 0.9)
        let upper = CGRect(x: x - mw * 0.32, y: balc.maxY, width: mw * 0.64, height: mh * 0.12)
        p.fill(CGPath(rect: upper, transform: nil), col, alpha: 0.14)
        p.hatch(CGPath(rect: upper, transform: nil), angle: .pi / 2.6, spacing: 5, col: col, width: 1, alpha: 0.5)
        p.stroke(CGPath(rect: upper, transform: nil), Pal.ink, 2, alpha: 0.9)
        let cap = CGMutablePath()
        cap.move(to: CGPoint(x: x - mw * 0.5, y: upper.maxY))
        cap.addQuadCurve(to: CGPoint(x: x, y: upper.maxY + mh * 0.13), control: CGPoint(x: x - mw * 0.32, y: upper.maxY + mh * 0.11))
        cap.addQuadCurve(to: CGPoint(x: x + mw * 0.5, y: upper.maxY), control: CGPoint(x: x + mw * 0.32, y: upper.maxY + mh * 0.11))
        cap.closeSubpath()
        p.fill(cap, col, alpha: 0.55)
        p.stroke(cap, Pal.ink, 2.2, alpha: 0.9)
        p.inkLine(from: CGPoint(x: x, y: upper.maxY + mh * 0.13), to: CGPoint(x: x, y: upper.maxY + mh * 0.17), Pal.ink, 1.8, alpha: 0.9)
    }

    func wallBlock(_ p: Plate, x: CGFloat, baseY: CGFloat, bw: CGFloat, col: Col) {
        let bh = bw * 0.22
        let body = CGPath(rect: CGRect(x: x, y: baseY, width: bw, height: bh), transform: nil)
        p.fill(body, col, alpha: 0.1)
        p.hatch(body, angle: .pi / 3, spacing: 9, col: col, width: 1.1, alpha: 0.45)
        p.stroke(body, Pal.ink, 2.6, alpha: 0.85)
        var cx = x + bw * 0.06
        while cx < x + bw - bw * 0.06 {
            let tooth = CGRect(x: cx, y: baseY + bh, width: bw * 0.05, height: bh * 0.18)
            p.fill(CGPath(rect: tooth, transform: nil), col, alpha: 0.55)
            p.stroke(CGPath(rect: tooth, transform: nil), Pal.ink, 1.4, alpha: 0.8)
            cx += bw * 0.11
        }
    }

    func drawSkyline(_ p: Plate, baseY: CGFloat, col: Col, scale: CGFloat = 1) {
        mosqueBlock(p, x: p.W * 0.06, baseY: baseY, bw: p.W * 0.2 * scale, col: col)
        minaret(p, x: p.W * 0.33, baseY: baseY, mh: p.H * 0.34 * scale, col: col)
        wallBlock(p, x: p.W * 0.38, baseY: baseY, bw: p.W * 0.16 * scale, col: col)
        mosqueBlock(p, x: p.W * 0.42, baseY: baseY, bw: p.W * 0.26 * scale, col: col)
        minaret(p, x: p.W * 0.74, baseY: baseY, mh: p.H * 0.3 * scale, col: col)
        wallBlock(p, x: p.W * 0.78, baseY: baseY, bw: p.W * 0.14 * scale, col: col)
        mosqueBlock(p, x: p.W * 0.8, baseY: baseY, bw: p.W * 0.17 * scale, col: col)
    }

    func sunRays(_ p: Plate, center: CGPoint, r: CGFloat, col: Col) {
        for i in 0..<36 {
            let a = CGFloat(i) * .pi / 18
            let inner = r * 1.15
            let outer = r * CGFloat(1.5 + 0.3 * Double(i % 2))
            p.inkLine(
                from: CGPoint(x: center.x + cos(a) * inner, y: center.y + sin(a) * inner),
                to: CGPoint(x: center.x + cos(a) * outer, y: center.y + sin(a) * outer),
                col, 2.4, alpha: 0.55
            )
        }
    }

    func beads(_ p: Plate, along pts: [CGPoint], beadR: CGFloat, col: Col, divEvery: Int = 0) {
        let strand = beadStrandPath(points: pts)
        p.stroke(strand, Pal.ink, 3, alpha: 0.7)
        for (i, pt) in pts.enumerated() {
            if divEvery > 0 && i > 0 && i % divEvery == 0 {
                let rect = CGRect(x: pt.x - beadR * 1.5, y: pt.y - beadR * 0.6, width: beadR * 3, height: beadR * 1.2)
                let rr = CGPath(roundedRect: rect, cornerWidth: beadR * 0.6, cornerHeight: beadR * 0.6, transform: nil)
                p.fill(rr, Pal.gold)
                p.stroke(rr, Pal.ink, 2, alpha: 0.8)
            } else {
                p.disc(center: pt, r: beadR, col: col)
                p.ring(center: pt, r: beadR, col: Pal.ink, width: 2, alpha: 0.75)
                p.disc(center: CGPoint(x: pt.x - beadR * 0.3, y: pt.y + beadR * 0.34), r: beadR * 0.22, col: Col(r: 1, g: 1, b: 1), alpha: 0.55)
            }
        }
    }

    func girih(_ p: Plate, center: CGPoint, radius: CGFloat, col: Col, layers: Int = 3) {
        for layer in 0..<layers {
            let r = radius * CGFloat(1 - Double(layer) * 0.28)
            let rot: CGFloat = layer % 2 == 0 ? 0 : .pi / 12
            let star = starPolygon(center: center, points: 12, rOuter: r, rInner: r * 0.72, rotation: rot)
            p.stroke(star, col, 3 - CGFloat(layer) * 0.7, alpha: 0.85)
            for i in 0..<12 {
                let a = CGFloat(i) * .pi / 6 + rot - .pi / 2
                p.inkLine(
                    from: center,
                    to: CGPoint(x: center.x + cos(a) * r * 0.72, y: center.y + sin(a) * r * 0.72),
                    col, 1.2, alpha: 0.35
                )
            }
        }
        p.ring(center: center, r: radius * 1.08, col: col, width: 2.4, alpha: 0.8)
        p.ring(center: center, r: radius * 1.16, col: col, width: 1.2, alpha: 0.5)
        for i in 0..<24 {
            let a = CGFloat(i) * .pi / 12
            p.disc(center: CGPoint(x: center.x + cos(a) * radius * 1.12, y: center.y + sin(a) * radius * 1.12), r: 4, col: col, alpha: 0.7)
        }
    }

    func borderBand(_ p: Plate, y: CGFloat, height: CGFloat, col: Col) {
        p.stroke(CGPath(rect: CGRect(x: 64, y: y, width: p.W - 128, height: height), transform: nil), col, 2, alpha: 0.65)
        var x: CGFloat = 76
        while x + height * 0.8 < p.W - 76 {
            let star = starPolygon(center: CGPoint(x: x + height * 0.4, y: y + height / 2), points: 8, rOuter: height * 0.34, rInner: height * 0.15)
            p.stroke(star, col, 1.6, alpha: 0.7)
            x += height * 1.1
        }
    }

    func crescent(_ p: Plate, center: CGPoint, r: CGFloat, col: Col) {
        p.ctx.saveGState()
        let outer = CGPath(ellipseIn: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2), transform: nil)
        p.ctx.addPath(outer)
        p.ctx.clip()
        p.disc(center: center, r: r, col: col)
        p.disc(center: CGPoint(x: center.x + r * 0.42, y: center.y + r * 0.18), r: r * 0.88, col: Pal.paper)
        p.ctx.restoreGState()
        p.ring(center: center, r: r, col: Pal.ink, width: 2, alpha: 0.4)
    }

    func stars(_ p: Plate, above y: CGFloat, count: Int, col: Col) {
        for _ in 0..<count {
            let x = p.rng.range(40, Double(p.w) - 40)
            let yy = p.rng.range(Double(y), Double(p.h) - 50)
            let s = p.rng.range(2, 5)
            let star = starPolygon(center: CGPoint(x: x, y: yy), points: 4, rOuter: s * 1.8, rInner: s * 0.5)
            p.fill(star, col, alpha: CGFloat(p.rng.range(0.35, 0.8)))
        }
    }
}
