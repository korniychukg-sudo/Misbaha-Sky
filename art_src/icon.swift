import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

@main
struct IconGen {
    static func main() {
        let size = 1024
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let ctx = CGContext(
            data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
            space: cs, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )!
        let S = CGFloat(size)
        let c = CGPoint(x: S / 2, y: S / 2)

        let bgTop = CGColor(red: 0.949, green: 0.925, blue: 0.867, alpha: 1)
        let bgBot = CGColor(red: 0.878, green: 0.843, blue: 0.753, alpha: 1)
        let bg = CGGradient(colorsSpace: cs, colors: [bgTop, bgBot] as CFArray, locations: [0, 1])!
        ctx.drawLinearGradient(bg, start: CGPoint(x: 0, y: S), end: CGPoint(x: 0, y: 0), options: [])

        let glow = CGGradient(
            colorsSpace: cs,
            colors: [
                CGColor(red: 0.882, green: 0.796, blue: 0.576, alpha: 0.55),
                CGColor(red: 0.882, green: 0.796, blue: 0.576, alpha: 0)
            ] as CFArray,
            locations: [0, 1]
        )!
        ctx.drawRadialGradient(glow, startCenter: c, startRadius: 0, endCenter: c, endRadius: S * 0.5, options: [])

        let orbR = S * 0.27
        let orb = CGGradient(
            colorsSpace: cs,
            colors: [
                CGColor(red: 0.62, green: 0.83, blue: 0.73, alpha: 1),
                CGColor(red: 0.184, green: 0.478, blue: 0.373, alpha: 1),
                CGColor(red: 0.075, green: 0.243, blue: 0.2, alpha: 1)
            ] as CFArray,
            locations: [0, 0.55, 1]
        )!
        ctx.saveGState()
        ctx.addEllipse(in: CGRect(x: c.x - orbR, y: c.y - orbR, width: orbR * 2, height: orbR * 2))
        ctx.clip()
        ctx.drawRadialGradient(
            orb,
            startCenter: CGPoint(x: c.x - orbR * 0.4, y: c.y + orbR * 0.45), startRadius: orbR * 0.1,
            endCenter: c, endRadius: orbR * 1.5,
            options: []
        )
        ctx.restoreGState()

        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.35))
        ctx.fillEllipse(in: CGRect(x: c.x - orbR * 0.52, y: c.y + orbR * 0.3, width: orbR * 0.62, height: orbR * 0.4))

        ctx.setStrokeColor(CGColor(red: 0.725, green: 0.561, blue: 0.208, alpha: 0.9))
        ctx.setLineWidth(S * 0.012)
        let ringR = S * 0.36
        ctx.strokeEllipse(in: CGRect(x: c.x - ringR, y: c.y - ringR, width: ringR * 2, height: ringR * 2))

        let beadCount = 22
        for i in 0..<beadCount {
            let a = CGFloat(i) * 2 * .pi / CGFloat(beadCount) - .pi / 2
            let p = CGPoint(x: c.x + cos(a) * ringR, y: c.y + sin(a) * ringR)
            let r = i == 0 ? S * 0.034 : S * 0.021
            let gold = i == 0
            let grad = CGGradient(
                colorsSpace: cs,
                colors: gold
                    ? [
                        CGColor(red: 0.949, green: 0.855, blue: 0.62, alpha: 1),
                        CGColor(red: 0.725, green: 0.561, blue: 0.208, alpha: 1),
                        CGColor(red: 0.478, green: 0.353, blue: 0.114, alpha: 1)
                    ] as CFArray
                    : [
                        CGColor(red: 0.62, green: 0.83, blue: 0.73, alpha: 1),
                        CGColor(red: 0.184, green: 0.478, blue: 0.373, alpha: 1),
                        CGColor(red: 0.075, green: 0.243, blue: 0.2, alpha: 1)
                    ] as CFArray,
                locations: [0, 0.55, 1]
            )!
            ctx.saveGState()
            ctx.addEllipse(in: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2))
            ctx.clip()
            ctx.drawRadialGradient(
                grad,
                startCenter: CGPoint(x: p.x - r * 0.35, y: p.y + r * 0.4), startRadius: r * 0.1,
                endCenter: p, endRadius: r * 1.5,
                options: []
            )
            ctx.restoreGState()
        }

        for (dx, dy, s) in [(0.3, 0.32, 0.018), (-0.34, -0.3, 0.013), (0.36, -0.22, 0.01)] {
            let p = CGPoint(x: c.x + S * CGFloat(dx), y: c.y + S * CGFloat(dy))
            let r = S * CGFloat(s)
            ctx.setFillColor(CGColor(red: 0.949, green: 0.855, blue: 0.62, alpha: 0.9))
            let star = CGMutablePath()
            for i in 0..<8 {
                let a = CGFloat(i) * .pi / 4
                let rr = i % 2 == 0 ? r * 2.2 : r * 0.8
                let pt = CGPoint(x: p.x + cos(a) * rr, y: p.y + sin(a) * rr)
                if i == 0 { star.move(to: pt) } else { star.addLine(to: pt) }
            }
            star.closeSubpath()
            ctx.addPath(star)
            ctx.fillPath()
        }

        let img = ctx.makeImage()!
        let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "AppIcon-1024.png"
        let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: out) as CFURL, UTType.png.identifier as CFString, 1, nil)!
        CGImageDestinationAddImage(dest, img, nil)
        CGImageDestinationFinalize(dest)
        print("icon saved")
    }
}
