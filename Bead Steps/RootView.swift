import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: BSStore

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Group {
                    switch store.activeTab {
                    case 0:
                        BeadsView()
                    case 1:
                        NavigationView { AdhkarView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 2:
                        NavigationView { NamesView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 3:
                        NavigationView { LearnView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    default:
                        NavigationView { JournalView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                tabBar
            }
            if let badge = store.newBadge {
                BadgeToast(badge: badge)
                    .padding(.bottom, 84)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                            withAnimation(.easeIn(duration: 0.3)) {
                                if store.newBadge?.id == badge.id {
                                    store.newBadge = nil
                                }
                            }
                        }
                    }
            }
        }
        .animation(.easeOut(duration: 0.3), value: store.newBadge != nil)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton(0, "Beads") { color in AnyView(BeadsIcon(size: 24, color: color)) }
            tabButton(1, "Adhkar") { color in AnyView(SetsIcon(size: 24, color: color)) }
            tabButton(2, "Names") { color in AnyView(NamesIcon(size: 24, color: color)) }
            tabButton(3, "Learn") { color in AnyView(LearnIcon(size: 24, color: color)) }
            tabButton(4, "Journal") { color in AnyView(JournalIcon(size: 24, color: color)) }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(
            BSTheme.card
                .overlay(Rectangle().fill(BSTheme.line).frame(height: 1), alignment: .top)
                .edgesIgnoringSafeArea(.bottom)
        )
    }

    private func tabButton(_ index: Int, _ label: String, icon: @escaping (Color) -> AnyView) -> some View {
        let active = store.activeTab == index
        let color = active ? BSTheme.emerald : BSTheme.inkFaint
        return Button {
            if store.activeTab != index {
                store.activeTab = index
                BSHaptics.tap()
            }
        } label: {
            VStack(spacing: 3) {
                icon(color)
                Text(label)
                    .font(BSTheme.text(10, active ? .semibold : .medium))
                    .foregroundColor(color)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(active ? BSTheme.emerald.opacity(0.09) : Color.clear)
                    .padding(.horizontal, 8)
            )
        }
        .buttonStyle(ScalePressStyle())
    }
}
