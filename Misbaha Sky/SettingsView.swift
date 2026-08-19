import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: MSStore
    @State private var confirmReset = false
    @State private var showPrivacy = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                beadStyleCard
                togglesCard
                aboutCard
                privacyCard
                resetCard
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(MSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(MSTheme.serif(18))
                    .foregroundColor(MSTheme.ink)
            }
        }
        .sheet(isPresented: $showPrivacy) {
            SkyWebPanel(urlString: SkyLink.source)
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.black.ignoresSafeArea())
        }
        .alert(isPresented: $confirmReset) {
            Alert(
                title: Text("Start over?"),
                message: Text("This clears every count, badge and record. It cannot be undone."),
                primaryButton: .destructive(Text("Reset everything")) {
                    store.resetAll()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private var beadStyleCard: some View {
        let unlockedCount = BeadStyle.allCases.filter { store.isUnlocked($0) }.count
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("The strand shelf")
                    .font(MSTheme.serif(16))
                    .foregroundColor(MSTheme.ink)
                Spacer()
                MSChip(text: "\(unlockedCount) of \(BeadStyle.allCases.count)", tint: MSTheme.gold)
            }
            Text("Materials are earned by practice. The strand you count with is the one you chose here.")
                .font(MSTheme.text(11))
                .foregroundColor(MSTheme.inkFaint)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 12) {
                ForEach(BeadStyle.allCases) { style in
                    let unlocked = store.isUnlocked(style)
                    Button {
                        if unlocked {
                            store.setBeadStyle(style)
                            MSHaptics.tap()
                        } else {
                            MSHaptics.warm()
                        }
                    } label: {
                        VStack(spacing: 5) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [style.glint, style.base, style.deep],
                                            center: .init(x: 0.35, y: 0.3),
                                            startRadius: 2, endRadius: 26
                                        )
                                    )
                                    .frame(width: 38, height: 38)
                                    .opacity(unlocked ? 1 : 0.28)
                                if !unlocked {
                                    Circle()
                                        .strokeBorder(MSTheme.line, style: StrokeStyle(lineWidth: 1.6, dash: [4, 3]))
                                        .frame(width: 46, height: 46)
                                }
                                if store.beadStyle == style {
                                    Circle()
                                        .strokeBorder(MSTheme.gold, lineWidth: 2)
                                        .frame(width: 46, height: 46)
                                }
                            }
                            .frame(width: 48, height: 48)
                            Text(style.title)
                                .font(MSTheme.text(10, .semibold))
                                .foregroundColor(unlocked ? (store.beadStyle == style ? MSTheme.ink : MSTheme.inkSoft) : MSTheme.inkFaint)
                            Text(unlocked ? (store.beadStyle == style ? "In hand" : "Ready") : store.unlockHint(style))
                                .font(MSTheme.text(8))
                                .foregroundColor(MSTheme.inkFaint)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .frame(height: 22, alignment: .top)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(ScalePressStyle())
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .msCard()
    }

    private var togglesCard: some View {
        VStack(spacing: 12) {
            Toggle(isOn: Binding(
                get: { store.state.hapticsOn },
                set: { store.setHaptics($0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Haptic beads")
                        .font(MSTheme.text(14, .semibold))
                        .foregroundColor(MSTheme.ink)
                    Text("A small tick as each bead crosses the thumb")
                        .font(MSTheme.text(11))
                        .foregroundColor(MSTheme.inkSoft)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: MSTheme.emerald))
            Divider()
            Toggle(isOn: Binding(
                get: { store.state.showTranslit },
                set: { store.setShowTranslit($0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Transliteration")
                        .font(MSTheme.text(14, .semibold))
                        .foregroundColor(MSTheme.ink)
                    Text("Show the Latin reading under the Arabic")
                        .font(MSTheme.text(11))
                        .foregroundColor(MSTheme.inkSoft)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: MSTheme.emerald))
        }
        .msCard()
    }

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About Misbaha Sky")
                .font(MSTheme.serif(16))
                .foregroundColor(MSTheme.ink)
            Text("Misbaha Sky is a pocket misbaha: a strand of prayer beads you pull with your thumb, with the counted remembrances of the Muslim day arranged around it. Everything lives on this device — there is no account, no network, and nothing leaves your phone.")
                .font(MSTheme.text(13))
                .foregroundColor(MSTheme.inkSoft)
                .lineSpacing(4)
            Text("The remembrances follow widely related wordings from the established hadith collections named under each one. May your counting be present and unhurried.")
                .font(MSTheme.text(13))
                .foregroundColor(MSTheme.inkSoft)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .msCard()
    }

    private var privacyCard: some View {
        Button {
            showPrivacy = true
            MSHaptics.tap()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(MSTheme.emeraldSoft).frame(width: 44, height: 44)
                    LearnIcon(size: 22, color: MSTheme.emerald)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Privacy Policy")
                        .font(MSTheme.serif(16))
                        .foregroundColor(MSTheme.ink)
                    Text("How this app treats your data")
                        .font(MSTheme.text(12))
                        .foregroundColor(MSTheme.inkSoft)
                }
                Spacer()
                ChevronIcon()
            }
            .msCard(padding: 12)
        }
        .buttonStyle(ScalePressStyle())
    }

    private var resetCard: some View {
        Button {
            confirmReset = true
        } label: {
            HStack {
                Spacer()
                Text("Reset all progress")
                    .font(MSTheme.text(14, .semibold))
                    .foregroundColor(MSTheme.terra)
                Spacer()
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(MSTheme.terraSoft.opacity(0.5))
            )
        }
        .buttonStyle(ScalePressStyle())
    }
}
