import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: BSStore
    @State private var confirmReset = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                beadStyleCard
                togglesCard
                aboutCard
                resetCard
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(BSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(BSTheme.serif(18))
                    .foregroundColor(BSTheme.ink)
            }
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
        VStack(alignment: .leading, spacing: 12) {
            Text("Bead material")
                .font(BSTheme.serif(16))
                .foregroundColor(BSTheme.ink)
            HStack(spacing: 10) {
                ForEach(BeadStyle.allCases) { style in
                    Button {
                        store.setBeadStyle(style)
                        BSHaptics.tap()
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
                                if store.beadStyle == style {
                                    Circle()
                                        .strokeBorder(BSTheme.gold, lineWidth: 2)
                                        .frame(width: 46, height: 46)
                                }
                            }
                            .frame(width: 48, height: 48)
                            Text(style.title)
                                .font(BSTheme.text(10, .semibold))
                                .foregroundColor(store.beadStyle == style ? BSTheme.ink : BSTheme.inkFaint)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(ScalePressStyle())
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .bsCard()
    }

    private var togglesCard: some View {
        VStack(spacing: 12) {
            Toggle(isOn: Binding(
                get: { store.state.hapticsOn },
                set: { store.setHaptics($0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Haptic beads")
                        .font(BSTheme.text(14, .semibold))
                        .foregroundColor(BSTheme.ink)
                    Text("A small tick as each bead crosses the thumb")
                        .font(BSTheme.text(11))
                        .foregroundColor(BSTheme.inkSoft)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: BSTheme.emerald))
            Divider()
            Toggle(isOn: Binding(
                get: { store.state.showTranslit },
                set: { store.setShowTranslit($0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Transliteration")
                        .font(BSTheme.text(14, .semibold))
                        .foregroundColor(BSTheme.ink)
                    Text("Show the Latin reading under the Arabic")
                        .font(BSTheme.text(11))
                        .foregroundColor(BSTheme.inkSoft)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: BSTheme.emerald))
        }
        .bsCard()
    }

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About Bead Steps")
                .font(BSTheme.serif(16))
                .foregroundColor(BSTheme.ink)
            Text("Bead Steps is a pocket misbaha: a strand of prayer beads you pull with your thumb, with the counted remembrances of the Muslim day arranged around it. Everything lives on this device — there is no account, no network, and nothing leaves your phone.")
                .font(BSTheme.text(13))
                .foregroundColor(BSTheme.inkSoft)
                .lineSpacing(4)
            Text("The remembrances follow widely related wordings from the established hadith collections named under each one. May your counting be present and unhurried.")
                .font(BSTheme.text(13))
                .foregroundColor(BSTheme.inkSoft)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .bsCard()
    }

    private var resetCard: some View {
        Button {
            confirmReset = true
        } label: {
            HStack {
                Spacer()
                Text("Reset all progress")
                    .font(BSTheme.text(14, .semibold))
                    .foregroundColor(BSTheme.terra)
                Spacer()
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(BSTheme.terraSoft.opacity(0.5))
            )
        }
        .buttonStyle(ScalePressStyle())
    }
}
