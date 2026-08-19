import SwiftUI
import UIKit

enum MSArt {
    private static let cache = NSCache<NSString, UIImage>()

    static func image(_ name: String) -> UIImage? {
        if let hit = cache.object(forKey: name as NSString) { return hit }
        var path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "Art")
        if path == nil {
            path = Bundle.main.path(forResource: name, ofType: "png", inDirectory: "Art")
        }
        guard let p = path, let img = UIImage(contentsOfFile: p) else { return nil }
        cache.setObject(img, forKey: name as NSString)
        return img
    }
}

struct ArtImage: View {
    let name: String
    var body: some View {
        Group {
            if let ui = MSArt.image(name) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else {
                LinearGradient(
                    colors: [MSTheme.emeraldSoft, MSTheme.goldSoft],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            }
        }
    }
}

struct ArtPlate: View {
    let name: String
    var height: CGFloat = 180
    var corner: CGFloat = MSTheme.corner
    var body: some View {
        Color.clear
            .frame(height: height)
            .overlay(ArtImage(name: name))
            .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .strokeBorder(MSTheme.line, lineWidth: 1)
            )
    }
}
