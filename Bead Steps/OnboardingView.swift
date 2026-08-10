import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var store: BSStore
    @State private var page = 0

    private let pages: [(art: String, title: String, text: String)] = [
        ("onboard-1", "A misbaha in your pocket", "Bead Steps is a strand of prayer beads that behaves like the real thing. Pull it with your thumb and feel each bead cross — every thirty-third announces itself, just as a divider does."),
        ("onboard-2", "The remembrances of the day", "Eight sets of adhkar — morning, evening, after the prayer, before sleep and more — each with its Arabic, a plain reading, a translation and its source. Count a whole set in order, or any single phrase."),
        ("onboard-3", "The ninety-nine names", "All of al-Asma ul-Husna, each with its meaning and a line worth carrying. One name is surfaced every day; a season of days covers them all."),
        ("onboard-4", "Quiet, offline, yours", "Your counts, streaks and badges stay on this device. No account, no network, no notifications — just the beads, whenever your hands are free.")
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                ForEach(0..<pages.count, id: \.self) { i in
                    VStack(spacing: 20) {
                        Spacer(minLength: 10)
                        ArtImage(name: pages[i].art)
                            .frame(maxWidth: 460, maxHeight: 340)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .strokeBorder(BSTheme.line, lineWidth: 1)
                            )
                            .padding(.horizontal, 26)
                        Text(pages[i].title)
                            .font(BSTheme.serif(26))
                            .foregroundColor(BSTheme.ink)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        Text(pages[i].text)
                            .font(BSTheme.text(15))
                            .foregroundColor(BSTheme.inkSoft)
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                            .padding(.horizontal, 34)
                        Spacer()
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            HStack(spacing: 7) {
                ForEach(0..<pages.count, id: \.self) { i in
                    Capsule()
                        .fill(i == page ? BSTheme.emerald : BSTheme.line)
                        .frame(width: i == page ? 22 : 7, height: 7)
                        .animation(.easeOut(duration: 0.25), value: page)
                }
            }
            .padding(.bottom, 18)
            Button {
                if page < pages.count - 1 {
                    withAnimation { page += 1 }
                } else {
                    store.finishOnboarding()
                    BSHaptics.success()
                }
            } label: {
                Text(page < pages.count - 1 ? "Continue" : "Pick up the beads")
                    .font(BSTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 340)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(BSTheme.emerald))
            }
            .buttonStyle(ScalePressStyle())
            .padding(.horizontal, 30)
            .padding(.bottom, 12)
            if page < pages.count - 1 {
                Button {
                    store.finishOnboarding()
                } label: {
                    Text("Skip")
                        .font(BSTheme.text(13, .medium))
                        .foregroundColor(BSTheme.inkFaint)
                }
                .padding(.bottom, 14)
            } else {
                Color.clear.frame(height: 33)
            }
        }
        .background(BSTheme.paper.ignoresSafeArea())
    }
}
