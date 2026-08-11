import SwiftUI

extension Color {
    init(bsHex: UInt32) {
        let r = Double((bsHex >> 16) & 0xFF) / 255.0
        let g = Double((bsHex >> 8) & 0xFF) / 255.0
        let b = Double(bsHex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

enum BSTheme {
    static let paper = Color(bsHex: 0xF6EFE1)
    static let paperDeep = Color(bsHex: 0xEFE5CF)
    static let card = Color(bsHex: 0xFCF8ED)
    static let ink = Color(bsHex: 0x2A2419)
    static let inkSoft = Color(bsHex: 0x5C5343)
    static let inkFaint = Color(bsHex: 0x8A7F6A)
    static let emerald = Color(bsHex: 0x1E5C4B)
    static let emeraldDeep = Color(bsHex: 0x133E33)
    static let emeraldSoft = Color(bsHex: 0xDDE9E0)
    static let gold = Color(bsHex: 0xB98F35)
    static let goldSoft = Color(bsHex: 0xE9D9AE)
    static let terra = Color(bsHex: 0xA85B38)
    static let terraSoft = Color(bsHex: 0xEFDCCB)
    static let night = Color(bsHex: 0x1C2B33)
    static let line = Color(bsHex: 0xD9CDB4)

    static let corner: CGFloat = 18

    static func serif(_ size: CGFloat, _ weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
    static func text(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    static func round(_ size: CGFloat, _ weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
    static func arabic(_ size: CGFloat, _ weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

struct BSCardStyle: ViewModifier {
    var padding: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: BSTheme.corner, style: .continuous)
                    .fill(BSTheme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: BSTheme.corner, style: .continuous)
                            .strokeBorder(BSTheme.line, lineWidth: 1)
                    )
                    .shadow(color: BSTheme.ink.opacity(0.06), radius: 8, x: 0, y: 3)
            )
    }
}

extension View {
    func bsCard(padding: CGFloat = 16) -> some View { modifier(BSCardStyle(padding: padding)) }
}

enum BeadStyle: String, CaseIterable, Codable, Identifiable {
    case jade, amber, walnut, coral, onyx, rosewood, lapis, pearl
    var id: String { rawValue }
    var title: String {
        switch self {
        case .jade: return "Jade"
        case .amber: return "Amber"
        case .walnut: return "Walnut"
        case .coral: return "Coral"
        case .onyx: return "Onyx"
        case .rosewood: return "Rosewood"
        case .lapis: return "Lapis"
        case .pearl: return "Pearl"
        }
    }
    var base: Color {
        switch self {
        case .jade: return Color(bsHex: 0x2F7A5F)
        case .amber: return Color(bsHex: 0xC98A2E)
        case .walnut: return Color(bsHex: 0x6E4A2B)
        case .coral: return Color(bsHex: 0xC96B52)
        case .onyx: return Color(bsHex: 0x33393E)
        case .rosewood: return Color(bsHex: 0x77363B)
        case .lapis: return Color(bsHex: 0x2C4A8A)
        case .pearl: return Color(bsHex: 0xE8E0D0)
        }
    }
    var deep: Color {
        switch self {
        case .jade: return Color(bsHex: 0x174C3A)
        case .amber: return Color(bsHex: 0x8A5A17)
        case .walnut: return Color(bsHex: 0x452C17)
        case .coral: return Color(bsHex: 0x8A3E2C)
        case .onyx: return Color(bsHex: 0x15191C)
        case .rosewood: return Color(bsHex: 0x4A1E22)
        case .lapis: return Color(bsHex: 0x172B58)
        case .pearl: return Color(bsHex: 0xB9AE99)
        }
    }
    var glint: Color {
        switch self {
        case .jade: return Color(bsHex: 0x9FD4BC)
        case .amber: return Color(bsHex: 0xF2CE8B)
        case .walnut: return Color(bsHex: 0xB98D62)
        case .coral: return Color(bsHex: 0xF2B29A)
        case .onyx: return Color(bsHex: 0x7C8890)
        case .rosewood: return Color(bsHex: 0xC08287)
        case .lapis: return Color(bsHex: 0x8FA8DE)
        case .pearl: return Color(bsHex: 0xFFFBF0)
        }
    }
    var stringColor: Color {
        switch self {
        case .pearl: return Color(bsHex: 0x8A7F6A)
        default: return Color(bsHex: 0x3A3128)
        }
    }
}
