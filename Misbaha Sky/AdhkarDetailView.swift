import SwiftUI

struct AdhkarDetailView: View {
    @EnvironmentObject var store: MSStore
    let set: AdhkarSet

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArtPlate(name: set.artName, height: 190)
                HStack {
                    MSChip(text: set.timeHint, tint: MSTheme.emerald)
                    MSChip(text: "\(set.totalBeads) beads in all", tint: MSTheme.gold)
                    Spacer()
                    if let done = store.state.setCompletions[set.id], done > 0 {
                        MSChip(text: "Completed \(done)x", tint: MSTheme.terra)
                    }
                }
                Text(set.intro)
                    .font(MSTheme.text(14))
                    .foregroundColor(MSTheme.inkSoft)
                    .lineSpacing(4)
                Button {
                    startWholeSet()
                } label: {
                    HStack {
                        Spacer()
                        VStack(spacing: 2) {
                            Text("Begin with the beads")
                                .font(MSTheme.text(15, .semibold))
                                .foregroundColor(.white)
                            Text("All \(set.items.count) remembrances in order")
                                .font(MSTheme.text(11))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Capsule().fill(MSTheme.emerald))
                }
                .buttonStyle(ScalePressStyle())
                MSSectionHeader(title: "The remembrances")
                VStack(spacing: 12) {
                    ForEach(Array(set.items.enumerated()), id: \.element.id) { idx, item in
                        itemCard(item, index: idx + 1)
                    }
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(MSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(set.title)
                    .font(MSTheme.serif(18))
                    .foregroundColor(MSTheme.ink)
            }
        }
    }

    private func itemCard(_ item: DhikrItem, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(index)")
                    .font(MSTheme.round(13))
                    .foregroundColor(MSTheme.gold)
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(MSTheme.goldSoft.opacity(0.5)))
                Spacer()
                MSChip(text: item.count == 1 ? "once" : "\(item.count) times", tint: MSTheme.emerald)
            }
            Text(item.arabic)
                .font(MSTheme.arabic(item.arabic.count > 80 ? 19 : 24))
                .foregroundColor(MSTheme.ink)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.trailing)
                .lineSpacing(6)
            if store.state.showTranslit {
                Text(item.translit)
                    .font(MSTheme.text(13, .semibold))
                    .foregroundColor(MSTheme.emerald)
                    .lineSpacing(2)
            }
            Text(item.english)
                .font(MSTheme.text(13))
                .foregroundColor(MSTheme.inkSoft)
                .lineSpacing(3)
            HStack {
                Text(item.note)
                    .font(MSTheme.text(11))
                    .foregroundColor(MSTheme.inkFaint)
                    .italic()
                Spacer()
                MSChip(text: item.source, tint: MSTheme.terra)
            }
            Button {
                startSingle(item)
            } label: {
                HStack {
                    Spacer()
                    BeadsIcon(size: 16, color: MSTheme.emerald)
                    Text("Count this one")
                        .font(MSTheme.text(13, .semibold))
                        .foregroundColor(MSTheme.emerald)
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(MSTheme.emerald.opacity(0.08))
                        .overlay(Capsule().strokeBorder(MSTheme.emerald.opacity(0.35), lineWidth: 1))
                )
            }
            .buttonStyle(ScalePressStyle())
        }
        .msCard()
    }

    private func startWholeSet() {
        guard let first = set.items.first else { return }
        store.pendingLaunch = RoundSpec.fromItem(
            first, setId: set.id, queueIds: set.items.map { $0.id }, queueIndex: 0
        )
        store.activeTab = 0
        MSHaptics.tap()
    }

    private func startSingle(_ item: DhikrItem) {
        store.pendingLaunch = RoundSpec.fromItem(item, setId: nil, queueIds: [], queueIndex: 0)
        store.activeTab = 0
        MSHaptics.tap()
    }
}
