import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

struct IPt {
    var x: CGFloat
    var y: CGFloat
}

@main
struct IconGen {
    static let S: CGFloat = 1024
    static var ctx: CGContext!

    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
        CGColor(red: r, green: g, blue: b, alpha: a)
    }

    static func hx(_ v: UInt32, _ a: CGFloat = 1) -> CGColor {
        rgba(CGFloat((v >> 16) & 255) / 255, CGFloat((v >> 8) & 255) / 255, CGFloat(v & 255) / 255, a)
    }

    static func bezier(_ t: CGFloat, _ p0: IPt, _ c: IPt, _ p1: IPt) -> IPt {
        let u = 1 - t
        return IPt(
            x: u * u * p0.x + 2 * u * t * c.x + t * t * p1.x,
            y: u * u * p0.y + 2 * u * t * c.y + t * t * p1.y
        )
    }

    static func flipY(_ y: CGFloat) -> CGFloat { S - y }

    static func drawBackground() {
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let grad = CGGradient(
            colorsSpace: cs,
            colors: [hx(0x2A6E58), hx(0x17453A), hx(0x0B241E)] as CFArray,
            locations: [0, 0.55, 1]
        )!
        ctx.drawRadialGradient(
            grad,
            startCenter: CGPoint(x: S * 0.5, y: flipY(S * 0.34)), startRadius: 0,
            endCenter: CGPoint(x: S * 0.5, y: flipY(S * 0.55)), endRadius: S * 0.82,
            options: [.drawsAfterEndLocation]
        )

        let c = CGPoint(x: S * 0.5, y: flipY(S * 0.46))
        let rings: [(CGFloat, CGFloat)] = [(S * 0.315, 0.16), (S * 0.40, 0.10)]
        for (rr, alpha) in rings {
            let star = CGMutablePath()
            let points = 12
            for i in 0..<(points * 2) {
                let ang = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
                let r = i % 2 == 0 ? rr : rr * 0.82
                let p = CGPoint(x: c.x + cos(ang) * r, y: c.y + sin(ang) * r)
                if i == 0 { star.move(to: p) } else { star.addLine(to: p) }
            }
            star.closeSubpath()
            ctx.setStrokeColor(hx(0xC9A24B, alpha))
            ctx.setLineWidth(2.6)
            ctx.addPath(star)
            ctx.strokePath()
        }
        ctx.setStrokeColor(hx(0xC9A24B, 0.12))
        ctx.setLineWidth(2)
        ctx.strokeEllipse(in: CGRect(x: c.x - S * 0.44, y: c.y - S * 0.44, width: S * 0.88, height: S * 0.88))
        for i in 0..<48 {
            let ang = CGFloat(i) * .pi / 24
            let p = CGPoint(x: c.x + cos(ang) * S * 0.44, y: c.y + sin(ang) * S * 0.44)
            ctx.setFillColor(hx(0xC9A24B, i % 4 == 0 ? 0.22 : 0.10))
            let d: CGFloat = i % 4 == 0 ? 7 : 4
            ctx.fillEllipse(in: CGRect(x: p.x - d / 2, y: p.y - d / 2, width: d, height: d))
        }

        let vg = CGGradient(
            colorsSpace: cs,
            colors: [rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.34)] as CFArray,
            locations: [0.62, 1]
        )!
        ctx.drawRadialGradient(
            vg,
            startCenter: CGPoint(x: S * 0.5, y: S * 0.5), startRadius: 0,
            endCenter: CGPoint(x: S * 0.5, y: S * 0.5), endRadius: S * 0.75,
            options: [.drawsAfterEndLocation]
        )
    }

    static func strandCurveSamples() -> [IPt] {
        let p0 = IPt(x: 258, y: -60)
        let c = IPt(x: 512, y: 1130)
        let p1 = IPt(x: 766, y: -60)
        var out: [IPt] = []
        for i in 0...240 {
            out.append(bezier(CGFloat(i) / 240, p0, c, p1))
        }
        return out
    }

    static func strandPoints() -> [IPt] {
        let p0 = IPt(x: 258, y: -60)
        let c = IPt(x: 512, y: 1130)
        let p1 = IPt(x: 766, y: -60)
        var samples: [IPt] = []
        var lengths: [CGFloat] = [0]
        var prev = bezier(0, p0, c, p1)
        samples.append(prev)
        let n = 700
        for i in 1...n {
            let t = CGFloat(i) / CGFloat(n)
            let pt = bezier(t, p0, c, p1)
            lengths.append(lengths.last! + hypot(pt.x - prev.x, pt.y - prev.y))
            samples.append(pt)
            prev = pt
        }
        let total = lengths.last!
        let spacing: CGFloat = 101
        var targets: [CGFloat] = []
        var d = spacing * 0.3
        while d < total - spacing * 0.3 {
            if abs(d - total / 2) > 96 {
                targets.append(d)
            }
            d += spacing
        }
        var out: [IPt] = []
        var j = 0
        for target in targets {
            while j < lengths.count - 1 && lengths[j] < target { j += 1 }
            out.append(samples[j])
        }
        return out
    }

    static func drawString(_ pts: [IPt]) {
        ctx.setStrokeColor(hx(0x241B12, 0.9))
        ctx.setLineWidth(7)
        ctx.setLineCap(.round)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: pts[0].x, y: flipY(pts[0].y)))
        for p in pts.dropFirst() {
            ctx.addLine(to: CGPoint(x: p.x, y: flipY(p.y)))
        }
        ctx.strokePath()
    }

    static func drawShadow(at p: IPt, r: CGFloat) {
        let layers: [(CGFloat, CGFloat)] = [(1.55, 0.10), (1.3, 0.12), (1.1, 0.14)]
        for (k, alpha) in layers {
            ctx.setFillColor(rgba(0, 0, 0, alpha))
            ctx.fillEllipse(in: CGRect(
                x: p.x - r * k, y: flipY(p.y) - r * k - 20,
                width: r * 2 * k, height: r * 2 * k
            ))
        }
    }

    static func drawBead(at p: IPt, r: CGFloat) {
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let cgp = CGPoint(x: p.x, y: flipY(p.y))
        let grad = CGGradient(
            colorsSpace: cs,
            colors: [hx(0xA9DFC2), hx(0x35785B), hx(0x18493A), hx(0x0B281F)] as CFArray,
            locations: [0, 0.38, 0.78, 1]
        )!
        ctx.saveGState()
        ctx.addEllipse(in: CGRect(x: cgp.x - r, y: cgp.y - r, width: r * 2, height: r * 2))
        ctx.clip()
        ctx.drawRadialGradient(
            grad,
            startCenter: CGPoint(x: cgp.x - r * 0.38, y: cgp.y + r * 0.42), startRadius: r * 0.05,
            endCenter: CGPoint(x: cgp.x, y: cgp.y), endRadius: r * 1.45,
            options: [.drawsAfterEndLocation]
        )
        let occl = CGGradient(
            colorsSpace: cs,
            colors: [rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.30)] as CFArray,
            locations: [0.72, 1]
        )!
        ctx.drawRadialGradient(
            occl,
            startCenter: CGPoint(x: cgp.x, y: cgp.y + r * 0.2), startRadius: r * 0.3,
            endCenter: CGPoint(x: cgp.x, y: cgp.y), endRadius: r * 1.02,
            options: []
        )
        let bounce = CGGradient(
            colorsSpace: cs,
            colors: [hx(0xC9A24B, 0.28), hx(0xC9A24B, 0)] as CFArray,
            locations: [0, 1]
        )!
        ctx.drawRadialGradient(
            bounce,
            startCenter: CGPoint(x: cgp.x + r * 0.35, y: cgp.y - r * 0.62), startRadius: 0,
            endCenter: CGPoint(x: cgp.x + r * 0.35, y: cgp.y - r * 0.62), endRadius: r * 0.55,
            options: []
        )
        ctx.restoreGState()

        ctx.setFillColor(rgba(1, 1, 1, 0.85))
        ctx.fillEllipse(in: CGRect(x: cgp.x - r * 0.52, y: cgp.y + r * 0.30, width: r * 0.46, height: r * 0.30))
    }


    static func drawGoldBead(at p: IPt, r: CGFloat) {
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let cgp = CGPoint(x: p.x, y: flipY(p.y))
        let grad = CGGradient(
            colorsSpace: cs,
            colors: [hx(0xF7E7B4), hx(0xD1A94E), hx(0x8A6420), hx(0x4E360D)] as CFArray,
            locations: [0, 0.4, 0.8, 1]
        )!
        ctx.saveGState()
        ctx.addEllipse(in: CGRect(x: cgp.x - r, y: cgp.y - r, width: r * 2, height: r * 2))
        ctx.clip()
        ctx.drawRadialGradient(
            grad,
            startCenter: CGPoint(x: cgp.x - r * 0.38, y: cgp.y + r * 0.42), startRadius: r * 0.05,
            endCenter: CGPoint(x: cgp.x, y: cgp.y), endRadius: r * 1.45,
            options: [.drawsAfterEndLocation]
        )
        ctx.restoreGState()
        ctx.setFillColor(rgba(1, 1, 1, 0.9))
        ctx.fillEllipse(in: CGRect(x: cgp.x - r * 0.5, y: cgp.y + r * 0.28, width: r * 0.42, height: r * 0.28))
    }

    static func drawDivider(at p: IPt, angle: CGFloat) {
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let cgp = CGPoint(x: p.x, y: flipY(p.y))
        ctx.saveGState()
        ctx.translateBy(x: cgp.x, y: cgp.y)
        ctx.rotate(by: angle)
        let w: CGFloat = 118
        let h: CGFloat = 74
        let rect = CGRect(x: -w / 2, y: -h / 2, width: w, height: h)
        let path = CGPath(roundedRect: rect, cornerWidth: h / 2, cornerHeight: h / 2, transform: nil)
        ctx.addPath(path)
        ctx.clip()
        let grad = CGGradient(
            colorsSpace: cs,
            colors: [hx(0xF3DFA4), hx(0xC9A24B), hx(0x6E5218)] as CFArray,
            locations: [0, 0.5, 1]
        )!
        ctx.drawLinearGradient(
            grad,
            start: CGPoint(x: 0, y: h / 2),
            end: CGPoint(x: 0, y: -h / 2),
            options: []
        )
        ctx.setStrokeColor(hx(0x4A3811, 0.6))
        ctx.setLineWidth(2)
        for fx in [-w * 0.22, 0, w * 0.22] {
            ctx.beginPath()
            ctx.move(to: CGPoint(x: fx, y: h / 2))
            ctx.addLine(to: CGPoint(x: fx, y: -h / 2))
            ctx.strokePath()
        }
        ctx.setFillColor(rgba(1, 1, 1, 0.55))
        ctx.fillEllipse(in: CGRect(x: -w * 0.32, y: h * 0.08, width: w * 0.26, height: h * 0.22))
        ctx.restoreGState()
    }

    static func drawImameAndTassel(bottom: IPt) {
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let topY = bottom.y - 6
        let capW: CGFloat = 80
        let capH: CGFloat = 138

        ctx.setStrokeColor(hx(0x241B12, 0.9))
        ctx.setLineWidth(7)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: bottom.x, y: flipY(topY - 4)))
        ctx.addLine(to: CGPoint(x: bottom.x, y: flipY(topY + 30)))
        ctx.strokePath()

        let capRect = CGRect(x: bottom.x - capW / 2, y: flipY(topY + capH + 18), width: capW, height: capH)
        let capPath = CGPath(roundedRect: capRect, cornerWidth: capW / 2, cornerHeight: capW / 2, transform: nil)
        for (k, a) in [(CGFloat(1.25), CGFloat(0.12)), (1.1, 0.15)] {
            ctx.setFillColor(rgba(0, 0, 0, a))
            ctx.fillEllipse(in: capRect.insetBy(dx: -capW * (k - 1), dy: -capW * (k - 1)).offsetBy(dx: 0, dy: -16))
        }
        ctx.saveGState()
        ctx.addPath(capPath)
        ctx.clip()
        let ig = CGGradient(
            colorsSpace: cs,
            colors: [hx(0xF7E7B4), hx(0xD1A94E), hx(0x7A5A1D), hx(0x453008)] as CFArray,
            locations: [0, 0.42, 0.82, 1]
        )!
        ctx.drawLinearGradient(
            ig,
            start: CGPoint(x: capRect.minX, y: capRect.midY),
            end: CGPoint(x: capRect.maxX, y: capRect.midY),
            options: []
        )
        ctx.setStrokeColor(hx(0x453008, 0.35))
        ctx.setLineWidth(2)
        for fy in [capRect.maxY - 34, capRect.maxY - 46] {
            ctx.beginPath()
            ctx.move(to: CGPoint(x: capRect.minX, y: fy))
            ctx.addLine(to: CGPoint(x: capRect.maxX, y: fy))
            ctx.strokePath()
        }
        ctx.restoreGState()
        ctx.setFillColor(rgba(1, 1, 1, 0.65))
        ctx.fillEllipse(in: CGRect(x: capRect.minX + 16, y: capRect.maxY - 66, width: 16, height: 40))

        let collarTopY = topY + capH + 18
        let collarRect = CGRect(x: bottom.x - 56, y: flipY(collarTopY + 34), width: 112, height: 34)
        ctx.saveGState()
        ctx.addPath(CGPath(roundedRect: collarRect, cornerWidth: 14, cornerHeight: 14, transform: nil))
        ctx.clip()
        let cg2 = CGGradient(
            colorsSpace: cs,
            colors: [hx(0xF7E7B4), hx(0x8A6420)] as CFArray,
            locations: [0, 1]
        )!
        ctx.drawLinearGradient(
            cg2,
            start: CGPoint(x: 0, y: collarRect.maxY),
            end: CGPoint(x: 0, y: collarRect.minY),
            options: []
        )
        ctx.restoreGState()

        let fromY = collarTopY + 34
        for layer in 0..<2 {
            let count = layer == 0 ? 12 : 17
            let len: CGFloat = layer == 0 ? 196 : 218
            let width: CGFloat = layer == 0 ? 12 : 9
            let spreadMax: CGFloat = layer == 0 ? 118 : 170
            for i in 0..<count {
                let f = count == 1 ? CGFloat(0.5) : CGFloat(i) / CGFloat(count - 1)
                let spread = (f - 0.5) * spreadMax
                let sway = sin(f * .pi * 4 + CGFloat(layer) * 1.7) * 7
                let endX = bottom.x + spread + sway
                let endY = fromY + len + sin(f * .pi) * 22
                let gold = layer == 1 && i % 6 == 3
                let col: CGColor
                if gold {
                    col = hx(0xC9A24B, 0.95)
                } else if layer == 0 {
                    col = hx(0x0E332A, 0.98)
                } else {
                    col = hx(0x1B5241, 0.95)
                }
                ctx.setStrokeColor(col)
                ctx.setLineWidth(gold ? 5.5 : width)
                ctx.setLineCap(.round)
                ctx.beginPath()
                ctx.move(to: CGPoint(x: bottom.x + spread * 0.2, y: flipY(fromY)))
                ctx.addCurve(
                    to: CGPoint(x: endX, y: flipY(endY)),
                    control1: CGPoint(x: bottom.x + spread * 0.22, y: flipY(fromY + len * 0.42)),
                    control2: CGPoint(x: bottom.x + spread * 0.66, y: flipY(fromY + len * 0.78))
                )
                ctx.strokePath()
            }
        }

    }

    static func main() {
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        ctx = CGContext(
            data: nil, width: Int(S), height: Int(S), bitsPerComponent: 8, bytesPerRow: 0,
            space: cs, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )!

        drawBackground()

        let pts = strandPoints()
        let allCurve = strandCurveSamples()
        var lowest = pts[0]
        for p in pts where p.y > lowest.y { lowest = p }
        let bottom = IPt(x: 512, y: lowest.y + 62)

        for p in pts { drawShadow(at: p, r: 50) }

        ctx.setStrokeColor(hx(0x241B12, 0.9))
        ctx.setLineWidth(7)
        ctx.setLineCap(.round)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: allCurve[0].x, y: flipY(allCurve[0].y)))
        for p in allCurve.dropFirst() {
            ctx.addLine(to: CGPoint(x: p.x, y: flipY(p.y)))
        }
        ctx.strokePath()

        let goldIdx: Set<Int> = [2, pts.count - 3]
        for (i, p) in pts.enumerated() {
            if goldIdx.contains(i) {
                drawGoldBead(at: p, r: 46)
            } else {
                drawBead(at: p, r: 50)
            }
        }

        drawImameAndTassel(bottom: bottom)

        let img = ctx.makeImage()!
        let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "AppIcon-1024.png"
        let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: out) as CFURL, UTType.png.identifier as CFString, 1, nil)!
        CGImageDestinationAddImage(dest, img, nil)
        CGImageDestinationFinalize(dest)
        print("icon saved")
    }
}
