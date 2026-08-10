import SwiftUI

struct AdhkarDetailView: View {
    @EnvironmentObject var store: BSStore
    let set: AdhkarSet

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArtPlate(name: set.artName, height: 190)
                HStack {
                    BSChip(text: set.timeHint, tint: BSTheme.emerald)
                    BSChip(text: "\(set.totalBeads) beads in all", tint: BSTheme.gold)
                    Spacer()
                    if let done = store.state.setCompletions[set.id], done > 0 {
                        BSChip(text: "Completed \(done)x", tint: BSTheme.terra)
                    }
                }
                Text(set.intro)
                    .font(BSTheme.text(14))
                    .foregroundColor(BSTheme.inkSoft)
                    .lineSpacing(4)
                Button {
                    startWholeSet()
                } label: {
                    HStack {
                        Spacer()
                        VStack(spacing: 2) {
                            Text("Begin with the beads")
                                .font(BSTheme.text(15, .semibold))
                                .foregroundColor(.white)
                            Text("All \(set.items.count) remembrances in order")
                                .font(BSTheme.text(11))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Capsule().fill(BSTheme.emerald))
                }
                .buttonStyle(ScalePressStyle())
                BSSectionHeader(title: "The remembrances")
                VStack(spacing: 12) {
                    ForEach(Array(set.items.enumerated()), id: \.element.id) { idx, item in
                        itemCard(item, index: idx + 1)
                    }
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(BSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(set.title)
                    .font(BSTheme.serif(18))
                    .foregroundColor(BSTheme.ink)
            }
        }
    }

    private func itemCard(_ item: DhikrItem, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(index)")
                    .font(BSTheme.round(13))
                    .foregroundColor(BSTheme.gold)
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(BSTheme.goldSoft.opacity(0.5)))
                Spacer()
                BSChip(text: item.count == 1 ? "once" : "\(item.count) times", tint: BSTheme.emerald)
            }
            Text(item.arabic)
                .font(BSTheme.arabic(item.arabic.count > 80 ? 19 : 24))
                .foregroundColor(BSTheme.ink)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.trailing)
                .lineSpacing(6)
            if store.state.showTranslit {
                Text(item.translit)
                    .font(BSTheme.text(13, .semibold))
                    .foregroundColor(BSTheme.emerald)
                    .lineSpacing(2)
            }
            Text(item.english)
                .font(BSTheme.text(13))
                .foregroundColor(BSTheme.inkSoft)
                .lineSpacing(3)
            HStack {
                Text(item.note)
                    .font(BSTheme.text(11))
                    .foregroundColor(BSTheme.inkFaint)
                    .italic()
                Spacer()
                BSChip(text: item.source, tint: BSTheme.terra)
            }
            Button {
                startSingle(item)
            } label: {
                HStack {
                    Spacer()
                    BeadsIcon(size: 16, color: BSTheme.emerald)
                    Text("Count this one")
                        .font(BSTheme.text(13, .semibold))
                        .foregroundColor(BSTheme.emerald)
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(BSTheme.emerald.opacity(0.08))
                        .overlay(Capsule().strokeBorder(BSTheme.emerald.opacity(0.35), lineWidth: 1))
                )
            }
            .buttonStyle(ScalePressStyle())
        }
        .bsCard()
    }

    private func startWholeSet() {
        guard let first = set.items.first else { return }
        store.pendingLaunch = RoundSpec.fromItem(
            first, setId: set.id, queueIds: set.items.map { $0.id }, queueIndex: 0
        )
        store.activeTab = 0
        BSHaptics.tap()
    }

    private func startSingle(_ item: DhikrItem) {
        store.pendingLaunch = RoundSpec.fromItem(item, setId: nil, queueIds: [], queueIndex: 0)
        store.activeTab = 0
        BSHaptics.tap()
    }
}
