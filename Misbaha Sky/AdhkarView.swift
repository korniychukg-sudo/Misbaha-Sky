import SwiftUI

struct AdhkarView: View {
    @EnvironmentObject var store: MSStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                WirdCard()
                suggestionCard
                ForEach(MSCatalog.sets) { set in
                    NavigationLink(destination: AdhkarDetailView(set: set)) {
                        setCard(set)
                    }
                    .buttonStyle(ScalePressStyle())
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(MSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Adhkar")
                    .font(MSTheme.serif(18))
                    .foregroundColor(MSTheme.ink)
            }
        }
    }

    struct WirdStep: Identifiable {
        let id: String
        let label: String
        let setId: String
        let prayerIndex: Int
    }

    static let wirdSteps: [WirdStep] = [
        WirdStep(id: "w-waking", label: "Waking", setId: "waking", prayerIndex: 0),
        WirdStep(id: "w-morning", label: "Morning", setId: "morning", prayerIndex: 0),
        WirdStep(id: "w-fajr", label: "Fajr", setId: "prayer", prayerIndex: 1),
        WirdStep(id: "w-dhuhr", label: "Dhuhr", setId: "prayer", prayerIndex: 2),
        WirdStep(id: "w-asr", label: "Asr", setId: "prayer", prayerIndex: 3),
        WirdStep(id: "w-maghrib", label: "Maghrib", setId: "prayer", prayerIndex: 4),
        WirdStep(id: "w-isha", label: "Isha", setId: "prayer", prayerIndex: 5),
        WirdStep(id: "w-evening", label: "Evening", setId: "evening", prayerIndex: 0),
        WirdStep(id: "w-sleep", label: "Sleep", setId: "sleep", prayerIndex: 0)
    ]

    private var suggestionCard: some View {
        let suggested = store.suggestedSet()
        return NavigationLink(destination: AdhkarDetailView(set: suggested)) {
            HStack(spacing: 12) {
                GeometricRosette(tint: MSTheme.gold, petals: 8)
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text("For this hour")
                        .font(MSTheme.text(11, .semibold))
                        .foregroundColor(MSTheme.inkFaint)
                    Text(suggested.title)
                        .font(MSTheme.serif(17))
                        .foregroundColor(MSTheme.ink)
                    Text(suggested.timeHint)
                        .font(MSTheme.text(12))
                        .foregroundColor(MSTheme.inkSoft)
                }
                Spacer()
                ChevronIcon()
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: MSTheme.corner, style: .continuous)
                    .fill(MSTheme.goldSoft.opacity(0.45))
                    .overlay(
                        RoundedRectangle(cornerRadius: MSTheme.corner, style: .continuous)
                            .strokeBorder(MSTheme.gold.opacity(0.4), lineWidth: 1)
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
                        .font(MSTheme.serif(21))
                        .foregroundColor(.white)
                    Text(set.subtitle)
                        .font(MSTheme.text(12))
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(14)
            }
            .frame(height: 148)
            .clipped()
            HStack {
                MSChip(text: set.timeHint, tint: MSTheme.emerald)
                MSChip(text: "\(set.items.count) remembrances", tint: MSTheme.terra)
                MSChip(text: "\(set.totalBeads) beads", tint: MSTheme.gold)
                Spacer()
                if (store.state.setCompletions[set.id] ?? 0) > 0 {
                    CheckIcon()
                }
            }
            .padding(12)
            .background(MSTheme.card)
        }
        .clipShape(RoundedRectangle(cornerRadius: MSTheme.corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: MSTheme.corner, style: .continuous)
                .strokeBorder(MSTheme.line, lineWidth: 1)
        )
        .shadow(color: MSTheme.ink.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

struct WirdCard: View {
    @EnvironmentObject var store: MSStore

    private var steps: [AdhkarView.WirdStep] { AdhkarView.wirdSteps }

    private func isDone(_ step: AdhkarView.WirdStep) -> Bool {
        let today = MSStore.dayKey()
        if step.prayerIndex > 0 {
            return (store.state.prayerByDay[today] ?? 0) >= step.prayerIndex
        }
        return (store.state.setDayLog[step.setId] ?? []).contains(today)
    }

    private var doneCount: Int {
        steps.filter { isDone($0) }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    ProgressRing(progress: Double(doneCount) / Double(steps.count), lineWidth: 4, tint: MSTheme.gold)
                        .frame(width: 34, height: 34)
                    Text("\(doneCount)")
                        .font(MSTheme.round(12))
                        .foregroundColor(MSTheme.ink)
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text("The day's wird")
                        .font(MSTheme.serif(17))
                        .foregroundColor(MSTheme.ink)
                    Text(doneCount == steps.count
                         ? "Every station of the day is counted"
                         : "\(steps.count - doneCount) stations of remembrance remain")
                        .font(MSTheme.text(11))
                        .foregroundColor(MSTheme.inkSoft)
                }
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { idx, step in
                        HStack(alignment: .top, spacing: 0) {
                            if idx > 0 {
                                Rectangle()
                                    .fill(isDone(step) && isDone(steps[idx - 1]) ? MSTheme.gold.opacity(0.6) : MSTheme.line)
                                    .frame(width: 18, height: 2)
                                    .padding(.top, 19)
                            }
                            wirdNode(step)
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .msCard()
    }

    private func wirdNode(_ step: AdhkarView.WirdStep) -> some View {
        let done = isDone(step)
        return Button {
            guard let set = MSCatalog.set(step.setId), let first = set.items.first else { return }
            store.pendingLaunch = RoundSpec.fromItem(
                first, setId: set.id, queueIds: set.items.map { $0.id }, queueIndex: 0
            )
            store.activeTab = 0
            MSHaptics.tap()
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(done ? MSTheme.gold.opacity(0.16) : MSTheme.paperDeep.opacity(0.6))
                        .frame(width: 40, height: 40)
                    Circle()
                        .strokeBorder(done ? MSTheme.gold : MSTheme.line, lineWidth: 1.6)
                        .frame(width: 40, height: 40)
                    if done {
                        CheckIcon(size: 15, color: MSTheme.gold)
                    } else {
                        Text("\(steps.firstIndex(where: { $0.id == step.id }).map { $0 + 1 } ?? 0)")
                            .font(MSTheme.round(13))
                            .foregroundColor(MSTheme.inkFaint)
                    }
                }
                Text(step.label)
                    .font(MSTheme.text(10, done ? .semibold : .medium))
                    .foregroundColor(done ? MSTheme.ink : MSTheme.inkFaint)
            }
            .frame(width: 52)
        }
        .buttonStyle(ScalePressStyle())
    }
}
