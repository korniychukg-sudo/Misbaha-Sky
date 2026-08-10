import UIKit

enum BSHaptics {
    private static let light = UIImpactFeedbackGenerator(style: .light)
    private static let medium = UIImpactFeedbackGenerator(style: .medium)
    private static let rigid = UIImpactFeedbackGenerator(style: .rigid)
    private static let soft = UIImpactFeedbackGenerator(style: .soft)
    private static let notify = UINotificationFeedbackGenerator()

    static var enabled = true

    static func bead() {
        guard enabled else { return }
        rigid.impactOccurred(intensity: 0.7)
    }
    static func divider() {
        guard enabled else { return }
        medium.impactOccurred(intensity: 1.0)
    }
    static func tap() {
        guard enabled else { return }
        light.impactOccurred(intensity: 0.6)
    }
    static func settle() {
        guard enabled else { return }
        soft.impactOccurred(intensity: 0.5)
    }
    static func success() {
        guard enabled else { return }
        notify.notificationOccurred(.success)
    }
    static func warm() {
        guard enabled else { return }
        notify.notificationOccurred(.warning)
    }
}
