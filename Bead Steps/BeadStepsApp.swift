import SwiftUI

@main
struct BeadStepsApp: App {
    @StateObject private var store = BSStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if store.state.onboarded {
                    RootView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(store)
            .preferredColorScheme(.light)
        }
    }
}
