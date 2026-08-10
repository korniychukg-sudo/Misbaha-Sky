import Foundation
import CoreGraphics

let outDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "../Bead Steps/Art"
let S = Scenes(dir: outDir)

func tassel(_ p: Plate, at pt: CGPoint, len: CGFloat, col: Col) {
    for i in 0..<7 {
        let spread = CGFloat(i - 3) * len * 0.09
        let path = CGMutablePath()
        path.move(to: pt)
        path.addQuadCurve(
            to: CGPoint(x: pt.x + spread, y: pt.y - len),
            control: CGPoint(x: pt.x + spread * 0.3, y: pt.y - len * 0.5)
        )
        p.stroke(path, col, 3, alpha: 0.8)
    }
    p.disc(center: CGPoint(x: pt.x, y: pt.y + 6), r: 10, col: Pal.gold)
    p.ring(center: CGPoint(x: pt.x, y: pt.y + 6), r: 10, col: Pal.ink, width: 2, alpha: 0.7)
}

func birds(_ p: Plate, count: Int, minY: CGFloat, maxY: CGFloat, col: Col) {
    for _ in 0..<count {
        let x = CGFloat(p.rng.range(100, Double(p.w) - 100))
        let y = CGFloat(p.rng.range(Double(minY), Double(maxY)))
        let s = CGFloat(p.rng.range(9, 18))
        let path = CGMutablePath()
        path.move(to: CGPoint(x: x - s, y: y))
        path.addQuadCurve(to: CGPoint(x: x, y: y + s * 0.16), control: CGPoint(x: x - s * 0.5, y: y + s * 0.62))
        path.addQuadCurve(to: CGPoint(x: x + s, y: y), control: CGPoint(x: x + s * 0.5, y: y + s * 0.62))
        p.stroke(path, col, 2.2, alpha: 0.7)
    }
}

func hangLamp(_ p: Plate, cx: CGFloat, topY: CGFloat, size: CGFloat, glow: Bool) {
    let (body, chain) = lampPath(cx: cx, topY: topY, size: size)
    if glow {
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let grad = CGGradient(colorsSpace: cs, colors: [Pal.gold.cg(0.4), Pal.gold.cg(0)] as CFArray, locations: [0, 1])!
        p.ctx.drawRadialGradient(
            grad,
            startCenter: CGPoint(x: cx, y: topY - size), startRadius: 0,
            endCenter: CGPoint(x: cx, y: topY - size), endRadius: size * 1.5,
            options: []
        )
    }
    p.stroke(chain, Pal.ink, 2.4, alpha: 0.8)
    p.fill(body, Pal.goldSoft, alpha: 0.9)
    p.hatch(body, angle: .pi / 3.4, spacing: 7, col: Pal.terra, width: 1.1, alpha: 0.35)
    p.stroke(body, Pal.ink, 2.6, alpha: 0.85)
}

func palmTree(_ p: Plate, x: CGFloat, baseY: CGFloat, h: CGFloat, col: Col) {
    let trunk = CGMutablePath()
    trunk.move(to: CGPoint(x: x, y: baseY))
    trunk.addQuadCurve(to: CGPoint(x: x + h * 0.16, y: baseY + h), control: CGPoint(x: x - h * 0.06, y: baseY + h * 0.6))
    p.stroke(trunk, col, 5, alpha: 0.9)
    let top = CGPoint(x: x + h * 0.16, y: baseY + h)
    for i in 0..<7 {
        let a = CGFloat(i) * .pi / 7 + .pi * 0.05
        let leaf = CGMutablePath()
        leaf.move(to: top)
        let end = CGPoint(x: top.x + cos(a) * h * 0.42, y: top.y + sin(a) * h * 0.28 - h * 0.05)
        leaf.addQuadCurve(to: end, control: CGPoint(x: top.x + cos(a) * h * 0.24, y: top.y + sin(a) * h * 0.3 + h * 0.09))
        p.stroke(leaf, col, 3.4, alpha: 0.85)
    }
}

func plateSetPrayer() {
    let p = Plate(w: 1600, h: 1200, seed: 11)
    p.paper()
    p.fibers()
    S.borderBand(p, y: 70, height: 60, col: Pal.emerald)
    S.borderBand(p, y: 1070, height: 60, col: Pal.emerald)
    let arch = archPath(cx: 800, baseY: 250, width: 680, height: 660)
    p.fill(arch, Pal.paperDark, alpha: 0.5)
    p.ctx.saveGState()
    p.ctx.addPath(arch)
    p.ctx.clip()
    var gx: CGFloat = 380
    while gx < 1240 {
        p.inkLine(from: CGPoint(x: gx, y: 250), to: CGPoint(x: gx + 240, y: 950), Pal.emerald, 1.3, alpha: 0.3)
        p.inkLine(from: CGPoint(x: gx + 240, y: 250), to: CGPoint(x: gx, y: 950), Pal.emerald, 1.3, alpha: 0.3)
        gx += 80
    }
    p.ctx.restoreGState()
    p.stroke(arch, Pal.ink, 5, alpha: 0.9)
    let arch2 = archPath(cx: 800, baseY: 250, width: 600, height: 600)
    p.stroke(arch2, Pal.gold, 2.6, alpha: 0.8)
    for side in [CGFloat(455), 1145] {
        p.inkLine(from: CGPoint(x: side, y: 250), to: CGPoint(x: side, y: 760), Pal.ink, 4, alpha: 0.75)
        let capital = CGRect(x: side - 26, y: 760, width: 52, height: 22)
        p.fill(CGPath(rect: capital, transform: nil), Pal.gold, alpha: 0.8)
        p.stroke(CGPath(rect: capital, transform: nil), Pal.ink, 2, alpha: 0.8)
        let base = CGRect(x: side - 30, y: 250, width: 60, height: 20)
        p.fill(CGPath(rect: base, transform: nil), Pal.gold, alpha: 0.8)
        p.stroke(CGPath(rect: base, transform: nil), Pal.ink, 2, alpha: 0.8)
    }
    hangLamp(p, cx: 800, topY: 870, size: 260, glow: true)
    p.inkLine(from: CGPoint(x: 300, y: 250), to: CGPoint(x: 1300, y: 250), Pal.ink, 5, alpha: 0.85)
    var pts: [CGPoint] = []
    for i in 0...16 {
        let t = CGFloat(i) / 16
        let x = 270 + t * 1060
        let y = 178 + sin(t * .pi) * -46
        pts.append(CGPoint(x: x, y: y))
    }
    S.beads(p, along: pts, beadR: 25, col: Pal.emerald, divEvery: 7)
    p.grain()
    p.vignette()
    p.frame()
    p.save("set-prayer", dir: S.dir)
}

func plateSetMorning() {
    let p = Plate(w: 1600, h: 1200, seed: 12)
    p.paper(Pal.sky, bottom: Pal.paper)
    p.fibers()
    let sun = CGPoint(x: 800, y: 760)
    p.disc(center: sun, r: 150, col: Pal.goldSoft)
    p.hatch(CGPath(ellipseIn: CGRect(x: 650, y: 610, width: 300, height: 300), transform: nil), angle: 0.4, spacing: 9, col: Pal.gold, width: 1.4, alpha: 0.5)
    p.ring(center: sun, r: 150, col: Pal.ink, width: 3, alpha: 0.7)
    S.sunRays(p, center: sun, r: 150, col: Pal.gold)
    birds(p, count: 6, minY: 850, maxY: 1080, col: Pal.ink)
    S.drawSkyline(p, baseY: 330, col: Pal.emeraldDeep)
    let ground = CGPath(rect: CGRect(x: 46, y: 46, width: 1508, height: 284), transform: nil)
    p.fill(ground, Pal.paperDark, alpha: 0.7)
    p.hatch(ground, angle: 0.06, spacing: 14, col: Pal.emerald, width: 1.2, alpha: 0.3)
    S.borderBand(p, y: 90, height: 56, col: Pal.terra)
    p.grain()
    p.vignette()
    p.frame()
    p.save("set-morning", dir: S.dir)
}

func plateSetEvening() {
    let p = Plate(w: 1600, h: 1200, seed: 13)
    p.paper(Pal.dusk.mix(Pal.paper, 0.55), bottom: Pal.paperDark)
    p.fibers()
    S.stars(p, above: 650, count: 40, col: Pal.gold)
    S.crescent(p, center: CGPoint(x: 1130, y: 880), r: 110, col: Pal.goldSoft)
    S.drawSkyline(p, baseY: 360, col: Pal.ink)
    let ground = CGPath(rect: CGRect(x: 46, y: 46, width: 1508, height: 314), transform: nil)
    p.fill(ground, Pal.emeraldDeep.mix(Pal.ink, 0.4), alpha: 0.85)
    for i in 0..<5 {
        hangLamp(p, cx: 240 + CGFloat(i) * 280, topY: 300, size: 120, glow: true)
    }
    p.grain()
    p.vignette()
    p.frame()
    p.save("set-evening", dir: S.dir)
}

func plateSetSleep() {
    let p = Plate(w: 1600, h: 1200, seed: 14)
    p.paper(Pal.dusk.mix(Pal.ink, 0.25).mix(Pal.paper, 0.3), bottom: Pal.paperDark.mix(Pal.ink, 0.2))
    p.fibers()
    let arch = archPath(cx: 800, baseY: 280, width: 640, height: 620)
    p.fill(arch, Pal.ink, alpha: 0.85)
    p.ctx.saveGState()
    p.ctx.addPath(arch)
    p.ctx.clip()
    S.stars(p, above: 300, count: 34, col: Pal.goldSoft)
    S.crescent(p, center: CGPoint(x: 890, y: 700), r: 95, col: Pal.goldSoft)
    p.ctx.restoreGState()
    p.stroke(arch, Pal.gold, 4, alpha: 0.85)
    let arch2 = archPath(cx: 800, baseY: 280, width: 700, height: 665)
    p.stroke(arch2, Pal.ink, 3, alpha: 0.6)
    var x: CGFloat = 520
    while x < 1090 {
        p.inkLine(from: CGPoint(x: x, y: 280), to: CGPoint(x: x, y: 292), Pal.gold, 2, alpha: 0.7)
        x += 40
    }
    hangLamp(p, cx: 430, topY: 500, size: 150, glow: true)
    S.borderBand(p, y: 110, height: 56, col: Pal.gold)
    p.grain()
    p.vignette()
    p.frame()
    p.save("set-sleep", dir: S.dir)
}

func plateSetWaking() {
    let p = Plate(w: 1600, h: 1200, seed: 15)
    p.paper()
    p.fibers()
    let arch = archPath(cx: 1050, baseY: 330, width: 560, height: 560)
    p.fill(arch, Pal.sky, alpha: 0.9)
    p.ctx.saveGState()
    p.ctx.addPath(arch)
    p.ctx.clip()
    let sun = CGPoint(x: 1050, y: 520)
    p.disc(center: sun, r: 95, col: Pal.goldSoft)
    p.ring(center: sun, r: 95, col: Pal.ink, width: 2.4, alpha: 0.6)
    S.sunRays(p, center: sun, r: 95, col: Pal.gold)
    p.ctx.restoreGState()
    p.stroke(arch, Pal.ink, 5, alpha: 0.85)
    for i in 0..<10 {
        let a = CGFloat(i) * 0.16 + 2.1
        p.inkLine(
            from: CGPoint(x: 1050 + cos(a) * 330, y: 520 + sin(a) * 330),
            to: CGPoint(x: 1050 + cos(a) * 470, y: 520 + sin(a) * 470),
            Pal.gold, 2.6, alpha: 0.4
        )
    }
    let sillY: CGFloat = 330
    p.inkLine(from: CGPoint(x: 700, y: sillY), to: CGPoint(x: 1400, y: sillY), Pal.ink, 6, alpha: 0.8)
    var pts: [CGPoint] = []
    for i in 0...14 {
        let t = CGFloat(i) / 14
        let x = 280 + t * 500
        let y = sillY - 90 + sin(t * .pi * 1.1 + 0.3) * -70
        pts.append(CGPoint(x: x, y: y))
    }
    S.beads(p, along: pts, beadR: 22, col: Pal.terra, divEvery: 7)
    S.borderBand(p, y: 90, height: 54, col: Pal.emerald)
    p.grain()
    p.vignette()
    p.frame()
    p.save("set-waking", dir: S.dir)
}

func plateSetDoor() {
    let p = Plate(w: 1600, h: 1200, seed: 16)
    p.paper()
    p.fibers()
    let arch = archPath(cx: 800, baseY: 150, width: 620, height: 800)
    p.fill(arch, Pal.terra.mix(Pal.paper, 0.35), alpha: 0.95)
    p.hatch(arch, angle: .pi / 2, spacing: 26, col: Pal.terra, width: 2, alpha: 0.4)
    p.stroke(arch, Pal.ink, 6, alpha: 0.9)
    p.inkLine(from: CGPoint(x: 800, y: 150), to: CGPoint(x: 800, y: 870), Pal.ink, 4, alpha: 0.8)
    let star1 = starPolygon(center: CGPoint(x: 655, y: 620), points: 8, rOuter: 90, rInner: 40)
    let star2 = starPolygon(center: CGPoint(x: 945, y: 620), points: 8, rOuter: 90, rInner: 40)
    p.stroke(star1, Pal.gold, 3, alpha: 0.9)
    p.stroke(star2, Pal.gold, 3, alpha: 0.9)
    p.disc(center: CGPoint(x: 700, y: 420), r: 12, col: Pal.gold)
    p.disc(center: CGPoint(x: 900, y: 420), r: 12, col: Pal.gold)
    let arch2 = archPath(cx: 800, baseY: 150, width: 700, height: 860)
    p.stroke(arch2, Pal.emerald, 3.4, alpha: 0.75)
    hangLamp(p, cx: 800, topY: 1130, size: 130, glow: false)
    let step = CGPath(rect: CGRect(x: 420, y: 100, width: 760, height: 50), transform: nil)
    p.fill(step, Pal.paperDark, alpha: 0.9)
    p.stroke(step, Pal.ink, 3, alpha: 0.7)
    p.grain()
    p.vignette()
    p.frame()
    p.save("set-door", dir: S.dir)
}

func plateSetRoad() {
    let p = Plate(w: 1600, h: 1200, seed: 17)
    p.paper(Pal.sky, bottom: Pal.paper)
    p.fibers()
    let sun = CGPoint(x: 380, y: 830)
    p.disc(center: sun, r: 105, col: Pal.goldSoft)
    p.ring(center: sun, r: 105, col: Pal.ink, width: 2.6, alpha: 0.6)
    S.sunRays(p, center: sun, r: 105, col: Pal.gold)
    for (i, dy) in [CGFloat(430), 330, 210].enumerated() {
        let dune = CGMutablePath()
        dune.move(to: CGPoint(x: 0, y: 0))
        dune.addLine(to: CGPoint(x: 0, y: dy))
        dune.addCurve(
            to: CGPoint(x: 1600, y: dy - 80),
            control1: CGPoint(x: 500, y: dy + 130 - CGFloat(i) * 30),
            control2: CGPoint(x: 1100, y: dy - 160 + CGFloat(i) * 40)
        )
        dune.addLine(to: CGPoint(x: 1600, y: 0))
        dune.closeSubpath()
        p.fill(dune, Pal.paperDark.mix(Pal.terra, CGFloat(i) * 0.12), alpha: 0.75)
        p.hatch(dune, angle: 0.1 + CGFloat(i) * 0.12, spacing: 13, col: Pal.terra, width: 1.2, alpha: 0.28)
    }
    palmTree(p, x: 1240, baseY: 330, h: 300, col: Pal.emeraldDeep)
    palmTree(p, x: 1370, baseY: 300, h: 230, col: Pal.emeraldDeep)
    let road = CGMutablePath()
    road.move(to: CGPoint(x: 700, y: 0))
    road.addQuadCurve(to: CGPoint(x: 860, y: 420), control: CGPoint(x: 620, y: 300))
    let road2 = CGMutablePath()
    road2.move(to: CGPoint(x: 1000, y: 0))
    road2.addQuadCurve(to: CGPoint(x: 900, y: 420), control: CGPoint(x: 1020, y: 300))
    p.stroke(road, Pal.ink, 4, alpha: 0.55)
    p.stroke(road2, Pal.ink, 4, alpha: 0.55)
    p.grain()
    p.vignette()
    p.frame()
    p.save("set-road", dir: S.dir)
}

func plateSetHeart() {
    let p = Plate(w: 1600, h: 1200, seed: 18)
    p.paper()
    p.fibers()
    S.girih(p, center: CGPoint(x: 800, y: 620), radius: 330, col: Pal.emerald, layers: 3)
    for i in 0..<16 {
        let a = CGFloat(i) * .pi / 8
        p.inkLine(
            from: CGPoint(x: 800 + cos(a) * 420, y: 620 + sin(a) * 420),
            to: CGPoint(x: 800 + cos(a) * CGFloat(470 + (i % 2) * 40), y: 620 + sin(a) * CGFloat(470 + (i % 2) * 40)),
            Pal.gold, 2.6, alpha: 0.6
        )
    }
    S.borderBand(p, y: 80, height: 56, col: Pal.terra)
    S.borderBand(p, y: 1064, height: 56, col: Pal.terra)
    p.grain()
    p.vignette()
    p.frame()
    p.save("set-heart", dir: S.dir)
}

func plateGuide(_ name: String, seed: UInt64, draw: (Plate) -> Void) {
    let p = Plate(w: 1600, h: 1200, seed: seed)
    p.paper()
    p.fibers()
    draw(p)
    p.grain()
    p.vignette()
    p.frame()
    p.save(name, dir: S.dir)
}

func run() {
    plateSetPrayer()
    plateSetMorning()
    plateSetEvening()
    plateSetSleep()
    plateSetWaking()
    plateSetDoor()
    plateSetRoad()
    plateSetHeart()

    plateGuide("guide-dhikr", seed: 21) { p in
        S.girih(p, center: CGPoint(x: 800, y: 640), radius: 300, col: Pal.emerald)
        for i in 0..<33 {
            let a = CGFloat(i) * 2 * .pi / 33 - .pi / 2
            p.disc(center: CGPoint(x: 800 + cos(a) * 400, y: 640 + sin(a) * 400), r: 13, col: i % 11 == 0 ? Pal.gold : Pal.terra)
            p.ring(center: CGPoint(x: 800 + cos(a) * 400, y: 640 + sin(a) * 400), r: 13, col: Pal.ink, width: 1.6, alpha: 0.6)
        }
        S.borderBand(p, y: 80, height: 52, col: Pal.gold)
    }

    plateGuide("guide-misbaha", seed: 22) { p in
        var pts: [CGPoint] = []
        for i in 0..<34 {
            let t = CGFloat(i) / 33
            let a = t * .pi * 3.1 - .pi / 2
            let r = 130 + t * 210
            pts.append(CGPoint(x: 800 + cos(a) * r, y: 660 + sin(a) * r * 0.78))
        }
        S.beads(p, along: pts, beadR: 24, col: Pal.walnutish, divEvery: 11)
        tassel(p, at: CGPoint(x: pts.last!.x, y: pts.last!.y - 10), len: 150, col: Pal.terra)
        S.borderBand(p, y: 80, height: 52, col: Pal.emerald)
    }

    plateGuide("guide-rhythm", seed: 23) { p in
        let sun = CGPoint(x: 430, y: 700)
        p.disc(center: sun, r: 120, col: Pal.goldSoft)
        p.ring(center: sun, r: 120, col: Pal.ink, width: 2.6, alpha: 0.7)
        S.sunRays(p, center: sun, r: 120, col: Pal.gold)
        S.crescent(p, center: CGPoint(x: 1170, y: 700), r: 110, col: Pal.goldSoft)
        S.stars(p, above: 560, count: 14, col: Pal.gold)
        p.inkLine(from: CGPoint(x: 800, y: 200), to: CGPoint(x: 800, y: 1000), Pal.emerald, 5, alpha: 0.7)
        p.disc(center: CGPoint(x: 800, y: 1010), r: 14, col: Pal.emerald)
        let cap = CGMutablePath()
        cap.move(to: CGPoint(x: 770, y: 1010))
        cap.addLine(to: CGPoint(x: 830, y: 1010))
        cap.addLine(to: CGPoint(x: 800, y: 1075))
        cap.closeSubpath()
        p.fill(cap, Pal.emerald, alpha: 0.9)
        S.drawSkyline(p, baseY: 210, col: Pal.emeraldDeep, scale: 0.7)
    }

    plateGuide("guide-prayer", seed: 24) { p in
        let rug = CGRect(x: 420, y: 200, width: 760, height: 800)
        p.fill(CGPath(rect: rug, transform: nil), Pal.terra.mix(Pal.paper, 0.25), alpha: 0.95)
        p.stroke(CGPath(rect: rug, transform: nil), Pal.ink, 5, alpha: 0.9)
        p.stroke(CGPath(rect: rug.insetBy(dx: 34, dy: 34), transform: nil), Pal.gold, 3, alpha: 0.85)
        let arch = archPath(cx: 800, baseY: 320, width: 480, height: 520)
        p.fill(arch, Pal.emerald.mix(Pal.paper, 0.2), alpha: 0.9)
        p.hatch(arch, angle: .pi / 2.8, spacing: 11, col: Pal.emeraldDeep, width: 1.2, alpha: 0.4)
        p.stroke(arch, Pal.gold, 3, alpha: 0.9)
        let star = starPolygon(center: CGPoint(x: 800, y: 560), points: 8, rOuter: 80, rInner: 36)
        p.stroke(star, Pal.goldSoft, 3, alpha: 0.95)
        for i in 0..<20 {
            let x = rug.minX + CGFloat(i) * rug.width / 19
            p.inkLine(from: CGPoint(x: x, y: rug.minY - 4), to: CGPoint(x: x, y: rug.minY - 34), Pal.terra, 2.6, alpha: 0.8)
            p.inkLine(from: CGPoint(x: x, y: rug.maxY + 4), to: CGPoint(x: x, y: rug.maxY + 34), Pal.terra, 2.6, alpha: 0.8)
        }
    }

    plateGuide("guide-names", seed: 25) { p in
        S.girih(p, center: CGPoint(x: 800, y: 620), radius: 310, col: Pal.gold, layers: 2)
        for i in 0..<99 {
            let a = CGFloat(i) * 2 * .pi / 99 - .pi / 2
            let r: CGFloat = 425
            p.disc(center: CGPoint(x: 800 + cos(a) * r, y: 620 + sin(a) * r), r: 6.5, col: i % 33 == 0 ? Pal.terra : Pal.emerald, alpha: 0.85)
        }
        p.ring(center: CGPoint(x: 800, y: 620), r: 455, col: Pal.ink, width: 2, alpha: 0.5)
    }

    plateGuide("guide-presence", seed: 26) { p in
        hangLamp(p, cx: 800, topY: 780, size: 300, glow: true)
        for i in 0..<24 {
            let a = CGFloat(i) * .pi / 12
            let c = CGPoint(x: 800, y: 620)
            p.inkLine(
                from: CGPoint(x: c.x + cos(a) * 280, y: c.y + sin(a) * 280),
                to: CGPoint(x: c.x + cos(a) * CGFloat(340 + (i % 2) * 50), y: c.y + sin(a) * CGFloat(340 + (i % 2) * 50)),
                Pal.gold, 2.4, alpha: 0.5
            )
        }
        S.borderBand(p, y: 80, height: 52, col: Pal.emerald)
        S.borderBand(p, y: 1068, height: 52, col: Pal.emerald)
    }

    plateGuide("guide-gratitude", seed: 27) { p in
        let arch1 = archPath(cx: 480, baseY: 300, width: 420, height: 560)
        let arch2 = archPath(cx: 1120, baseY: 300, width: 420, height: 560)
        p.fill(arch1, Pal.sky, alpha: 0.7)
        p.fill(arch2, Pal.dusk.mix(Pal.paper, 0.5), alpha: 0.7)
        p.stroke(arch1, Pal.ink, 4.4, alpha: 0.85)
        p.stroke(arch2, Pal.ink, 4.4, alpha: 0.85)
        p.ctx.saveGState()
        p.ctx.addPath(arch1)
        p.ctx.clip()
        let sun = CGPoint(x: 480, y: 600)
        p.disc(center: sun, r: 80, col: Pal.goldSoft)
        S.sunRays(p, center: sun, r: 80, col: Pal.gold)
        p.ctx.restoreGState()
        p.ctx.saveGState()
        p.ctx.addPath(arch2)
        p.ctx.clip()
        S.stars(p, above: 320, count: 18, col: Pal.gold)
        S.crescent(p, center: CGPoint(x: 1120, y: 620), r: 70, col: Pal.goldSoft)
        p.ctx.restoreGState()
        let star = starPolygon(center: CGPoint(x: 800, y: 1000), points: 8, rOuter: 70, rInner: 32)
        p.stroke(star, Pal.gold, 3, alpha: 0.9)
    }

    plateGuide("guide-day", seed: 28) { p in
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 120, y: 420))
        path.addCurve(to: CGPoint(x: 1480, y: 520), control1: CGPoint(x: 560, y: 200), control2: CGPoint(x: 1050, y: 760))
        p.stroke(path, Pal.emerald, 5, alpha: 0.7)
        var t: CGFloat = 0
        var idx = 0
        while t <= 1.001 {
            let x = 120 + t * 1360
            let y = 420 + sin(t * .pi * 0.9 + 0.2) * 140 * sin(t * 3)
            p.disc(center: CGPoint(x: x, y: y + 40), r: idx % 4 == 0 ? 17 : 11, col: idx % 4 == 0 ? Pal.gold : Pal.terra)
            p.ring(center: CGPoint(x: x, y: y + 40), r: idx % 4 == 0 ? 17 : 11, col: Pal.ink, width: 1.8, alpha: 0.6)
            t += 0.09
            idx += 1
        }
        let sun = CGPoint(x: 250, y: 880)
        p.disc(center: sun, r: 85, col: Pal.goldSoft)
        p.ring(center: sun, r: 85, col: Pal.ink, width: 2.2, alpha: 0.6)
        S.sunRays(p, center: sun, r: 85, col: Pal.gold)
        S.crescent(p, center: CGPoint(x: 1340, y: 880), r: 80, col: Pal.goldSoft)
    }

    let hero = Plate(w: 1600, h: 1200, seed: 31)
    hero.paper()
    hero.fibers()
    S.girih(hero, center: CGPoint(x: 800, y: 600), radius: 300, col: Pal.gold, layers: 3)
    S.girih(hero, center: CGPoint(x: 180, y: 600), radius: 200, col: Pal.emerald, layers: 2)
    S.girih(hero, center: CGPoint(x: 1420, y: 600), radius: 200, col: Pal.emerald, layers: 2)
    S.stars(hero, above: 0, count: 26, col: Pal.terra)
    hero.grain()
    hero.vignette()
    hero.frame()
    hero.save("names-hero", dir: S.dir)

    let ob1 = Plate(w: 1400, h: 1400, seed: 41)
    ob1.paper()
    ob1.fibers()
    var pts1: [CGPoint] = []
    for i in 0..<26 {
        let t = CGFloat(i) / 25
        let x = 700 + sin(t * .pi * 2.2 + 0.4) * 240
        let y = 1250 - t * 950
        pts1.append(CGPoint(x: x, y: y))
    }
    S.beads(ob1, along: pts1, beadR: 34, col: Pal.emerald, divEvery: 11)
    tassel(ob1, at: CGPoint(x: pts1.last!.x, y: pts1.last!.y - 20), len: 190, col: Pal.terra)
    S.borderBand(ob1, y: 70, height: 56, col: Pal.gold)
    ob1.grain()
    ob1.vignette()
    ob1.frame()
    ob1.save("onboard-1", dir: S.dir)

    let ob2 = Plate(w: 1400, h: 1400, seed: 42)
    ob2.paper(Pal.sky, bottom: Pal.paper)
    ob2.fibers()
    let sun2 = CGPoint(x: 700, y: 960)
    ob2.disc(center: sun2, r: 130, col: Pal.goldSoft)
    ob2.ring(center: sun2, r: 130, col: Pal.ink, width: 2.8, alpha: 0.7)
    S.sunRays(ob2, center: sun2, r: 130, col: Pal.gold)
    S.drawSkyline(ob2, baseY: 420, col: Pal.emeraldDeep)
    let ground2 = CGPath(rect: CGRect(x: 46, y: 46, width: 1308, height: 374), transform: nil)
    ob2.fill(ground2, Pal.paperDark, alpha: 0.7)
    ob2.hatch(ground2, angle: 0.05, spacing: 14, col: Pal.emerald, width: 1.2, alpha: 0.3)
    birds(ob2, count: 5, minY: 1080, maxY: 1300, col: Pal.ink)
    ob2.grain()
    ob2.vignette()
    ob2.frame()
    ob2.save("onboard-2", dir: S.dir)

    let ob3 = Plate(w: 1400, h: 1400, seed: 43)
    ob3.paper()
    ob3.fibers()
    S.girih(ob3, center: CGPoint(x: 700, y: 740), radius: 360, col: Pal.gold, layers: 3)
    for i in 0..<99 {
        let a = CGFloat(i) * 2 * .pi / 99 - .pi / 2
        ob3.disc(center: CGPoint(x: 700 + cos(a) * 490, y: 740 + sin(a) * 490), r: 7, col: i % 33 == 0 ? Pal.terra : Pal.emerald, alpha: 0.85)
    }
    S.borderBand(ob3, y: 80, height: 56, col: Pal.emerald)
    ob3.grain()
    ob3.vignette()
    ob3.frame()
    ob3.save("onboard-3", dir: S.dir)

    let ob4 = Plate(w: 1400, h: 1400, seed: 44)
    ob4.paper(Pal.dusk.mix(Pal.paper, 0.45), bottom: Pal.paperDark)
    ob4.fibers()
    S.stars(ob4, above: 800, count: 30, col: Pal.gold)
    S.crescent(ob4, center: CGPoint(x: 1050, y: 1090), r: 95, col: Pal.goldSoft)
    let shelfY: CGFloat = 430
    ob4.inkLine(from: CGPoint(x: 150, y: shelfY), to: CGPoint(x: 1250, y: shelfY), Pal.ink, 8, alpha: 0.85)
    hangLamp(ob4, cx: 420, topY: shelfY + 320, size: 230, glow: true)
    var pts4: [CGPoint] = []
    for i in 0..<18 {
        let t = CGFloat(i) / 17
        let a = t * .pi * 1.9 + .pi * 0.1
        pts4.append(CGPoint(x: 870 + cos(a) * 170, y: shelfY + 190 + sin(a) * 120))
    }
    S.beads(ob4, along: pts4, beadR: 26, col: Pal.terra, divEvery: 9)
    ob4.grain()
    ob4.vignette()
    ob4.frame()
    ob4.save("onboard-4", dir: S.dir)

    print("done")
}

extension Pal {
    static let walnutish = Col(r: 0.43, g: 0.29, b: 0.17)
}

run()
