import SwiftUI

struct AdhkarView: View {
    @EnvironmentObject var store: BSStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                suggestionCard
                ForEach(BSCatalog.sets) { set in
                    NavigationLink(destination: AdhkarDetailView(set: set)) {
                        setCard(set)
                    }
                    .buttonStyle(ScalePressStyle())
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(BSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Adhkar")
                    .font(BSTheme.serif(18))
                    .foregroundColor(BSTheme.ink)
            }
        }
    }

    private var suggestionCard: some View {
        let suggested = store.suggestedSet()
        return NavigationLink(destination: AdhkarDetailView(set: suggested)) {
            HStack(spacing: 12) {
                GeometricRosette(tint: BSTheme.gold, petals: 8)
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text("For this hour")
                        .font(BSTheme.text(11, .semibold))
                        .foregroundColor(BSTheme.inkFaint)
                    Text(suggested.title)
                        .font(BSTheme.serif(17))
                        .foregroundColor(BSTheme.ink)
                    Text(suggested.timeHint)
                        .font(BSTheme.text(12))
                        .foregroundColor(BSTheme.inkSoft)
                }
                Spacer()
                ChevronIcon()
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: BSTheme.corner, style: .continuous)
                    .fill(BSTheme.goldSoft.opacity(0.45))
                    .overlay(
                        RoundedRectangle(cornerRadius: BSTheme.corner, style: .continuous)
                            .strokeBorder(BSTheme.gold.opacity(0.4), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ScalePressStyle())
    }

    private func setCard(_ set: AdhkarSet) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                ArtImage(name: set.artName)
                    .frame(height: 148)
                    .clipped()
                LinearGradient(
                    colors: [Color.black.opacity(0.0), Color.black.opacity(0.45)],
                    startPoint: .center, endPoint: .bottom
                )
                VStack(alignment: .leading, spacing: 2) {
                    Text(set.title)
                        .font(BSTheme.serif(21))
                        .foregroundColor(.white)
                    Text(set.subtitle)
                        .font(BSTheme.text(12))
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(14)
            }
            .frame(height: 148)
            .clipped()
            HStack {
                BSChip(text: set.timeHint, tint: BSTheme.emerald)
                BSChip(text: "\(set.items.count) remembrances", tint: BSTheme.terra)
                BSChip(text: "\(set.totalBeads) beads", tint: BSTheme.gold)
                Spacer()
                if (store.state.setCompletions[set.id] ?? 0) > 0 {
                    CheckIcon()
                }
            }
            .padding(12)
            .background(BSTheme.card)
        }
        .clipShape(RoundedRectangle(cornerRadius: BSTheme.corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BSTheme.corner, style: .continuous)
                .strokeBorder(BSTheme.line, lineWidth: 1)
        )
        .shadow(color: BSTheme.ink.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}
