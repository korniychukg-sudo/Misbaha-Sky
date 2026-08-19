import SwiftUI

struct JournalView: View {
    @EnvironmentObject var store: MSStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                summaryRow
                wirdRingCard
                heatmapCard
                rhythmCard
                favouritesCard
                badgesCard
                sessionsCard
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Text("Settings")
                            .font(MSTheme.serif(16))
                            .foregroundColor(MSTheme.ink)
                        Spacer()
                        ChevronIcon()
                    }
                    .msCard(padding: 14)
                }
                .buttonStyle(ScalePressStyle())
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(MSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Journal")
                    .font(MSTheme.serif(18))
                    .foregroundColor(MSTheme.ink)
            }
        }
    }

    private var summaryRow: some View {
        HStack(spacing: 10) {
            statCard(value: "\(store.todayCount)", label: "beads today", tint: MSTheme.emerald)
            statCard(value: "\(store.streak)", label: "day streak", tint: MSTheme.gold)
            statCard(value: compact(store.state.totalBeads), label: "beads in all", tint: MSTheme.terra)
        }
    }

    private func compact(_ n: Int) -> String {
        if n >= 100000 { return String(format: "%.0fk", Double(n) / 1000) }
        if n >= 10000 { return String(format: "%.1fk", Double(n) / 1000) }
        return "\(n)"
    }

    private func statCard(value: String, label: String, tint: Color) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(MSTheme.round(24))
                .foregroundColor(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(MSTheme.text(11))
                .foregroundColor(MSTheme.inkSoft)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(MSTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(MSTheme.line, lineWidth: 1)
                )
        )
    }

    private var wirdRingCard: some View {
        let steps = AdhkarView.wirdSteps
        let today = MSStore.dayKey()
        let done = steps.filter { step in
            if step.prayerIndex > 0 {
                return (store.state.prayerByDay[today] ?? 0) >= step.prayerIndex
            }
            return (store.state.setDayLog[step.setId] ?? []).contains(today)
        }.count
        return HStack(spacing: 14) {
            ZStack {
                ProgressRing(progress: Double(done) / Double(steps.count), lineWidth: 6, tint: MSTheme.gold)
                    .frame(width: 54, height: 54)
                Text("\(done)")
                    .font(MSTheme.round(18))
                    .foregroundColor(MSTheme.ink)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Today's wird")
                    .font(MSTheme.serif(16))
                    .foregroundColor(MSTheme.ink)
                Text(done == steps.count
                     ? "All nine stations counted — a full day."
                     : "\(done) of \(steps.count) stations of the day counted so far.")
                    .font(MSTheme.text(12))
                    .foregroundColor(MSTheme.inkSoft)
            }
            Spacer()
            Button {
                store.activeTab = 1
            } label: {
                ChevronIcon()
                    .padding(6)
            }
        }
        .msCard(padding: 14)
    }

    private var rhythmCard: some View {
        var buckets = Array(repeating: 0, count: 8)
        let cal = Calendar.current
        for rec in store.state.sessions {
            let h = cal.component(.hour, from: rec.date)
            buckets[min(7, h / 3)] += rec.count
        }
        let maxVal = max(1, buckets.max() ?? 1)
        let labels = ["0", "3", "6", "9", "12", "15", "18", "21"]
        return Group {
            if buckets.contains(where: { $0 > 0 }) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Rhythm of the day")
                        .font(MSTheme.serif(16))
                        .foregroundColor(MSTheme.ink)
                    Text("When your hands reach for the beads")
                        .font(MSTheme.text(11))
                        .foregroundColor(MSTheme.inkFaint)
                    HStack(alignment: .bottom, spacing: 7) {
                        ForEach(0..<8, id: \.self) { i in
                            VStack(spacing: 3) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(buckets[i] == maxVal ? MSTheme.gold : MSTheme.emerald.opacity(buckets[i] > 0 ? 0.7 : 0.12))
                                    .frame(height: max(5, CGFloat(buckets[i]) / CGFloat(maxVal) * 64))
                                Text(labels[i])
                                    .font(MSTheme.text(9))
                                    .foregroundColor(MSTheme.inkFaint)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .msCard()
            }
        }
    }

    private var heatmapCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Five weeks of practice")
                .font(MSTheme.serif(16))
                .foregroundColor(MSTheme.ink)
            HeatmapGrid()
            HStack(spacing: 10) {
                Text("less")
                    .font(MSTheme.text(10))
                    .foregroundColor(MSTheme.inkFaint)
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(heatColor(level: i))
                        .frame(width: 14, height: 14)
                }
                Text("more")
                    .font(MSTheme.text(10))
                    .foregroundColor(MSTheme.inkFaint)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .msCard()
    }

    private var favouritesCard: some View {
        let top = store.state.perItem.sorted { $0.value > $1.value }.prefix(5)
        return Group {
            if !top.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Most counted")
                        .font(MSTheme.serif(16))
                        .foregroundColor(MSTheme.ink)
                    let maxVal = top.first?.value ?? 1
                    ForEach(Array(top), id: \.key) { key, value in
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text(titleFor(key))
                                    .font(MSTheme.text(13, .medium))
                                    .foregroundColor(MSTheme.ink)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                Spacer()
                                Text("\(value)")
                                    .font(MSTheme.round(13))
                                    .foregroundColor(MSTheme.emerald)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(MSTheme.line.opacity(0.4))
                                    Capsule()
                                        .fill(MSTheme.emerald)
                                        .frame(width: max(6, geo.size.width * CGFloat(value) / CGFloat(maxVal)))
                                }
                            }
                            .frame(height: 6)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .msCard()
            }
        }
    }

    private func titleFor(_ key: String) -> String {
        if let item = MSCatalog.item(key) { return item.translit }
        if let phrase = FreePhrase.all.first(where: { $0.id == key }) { return phrase.translit }
        return key
    }

    private var badgesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Badges")
                    .font(MSTheme.serif(16))
                    .foregroundColor(MSTheme.ink)
                Spacer()
                MSChip(text: "\(store.state.earned.count) of \(MSCatalog.badges.count)", tint: MSTheme.gold)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 8)], spacing: 8) {
                ForEach(MSCatalog.badges) { badge in
                    let earned = store.state.earned.contains(badge.id)
                    VStack(spacing: 5) {
                        StarShape(points: 8)
                            .fill(earned ? MSTheme.gold : MSTheme.line.opacity(0.7))
                            .frame(width: 26, height: 26)
                        Text(badge.title)
                            .font(MSTheme.text(10, .semibold))
                            .foregroundColor(earned ? MSTheme.ink : MSTheme.inkFaint)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        Text(badge.detail)
                            .font(MSTheme.text(8))
                            .foregroundColor(MSTheme.inkFaint)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, minHeight: 92)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(earned ? MSTheme.goldSoft.opacity(0.35) : MSTheme.paperDeep.opacity(0.5))
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .msCard()
    }

    private var sessionsCard: some View {
        Group {
            if !store.state.sessions.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent rounds")
                        .font(MSTheme.serif(16))
                        .foregroundColor(MSTheme.ink)
                    ForEach(store.state.sessions.prefix(12)) { rec in
                        HStack {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(rec.title)
                                    .font(MSTheme.text(13, .medium))
                                    .foregroundColor(MSTheme.ink)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                Text(Self.timeFormatter.string(from: rec.date))
                                    .font(MSTheme.text(10))
                                    .foregroundColor(MSTheme.inkFaint)
                            }
                            Spacer()
                            MSChip(text: "\(rec.count)", tint: MSTheme.emerald)
                        }
                        .padding(.vertical, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .msCard()
            }
        }
    }

    static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM d, HH:mm"
        return f
    }()
}

func heatColor(level: Int) -> Color {
    switch level {
    case 0: return MSTheme.line.opacity(0.35)
    case 1: return MSTheme.emerald.opacity(0.3)
    case 2: return MSTheme.emerald.opacity(0.6)
    default: return MSTheme.emerald
    }
}

struct HeatmapGrid: View {
    @EnvironmentObject var store: MSStore

    var body: some View {
        let days = lastDays(35)
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(days, id: \.self) { day in
                let v = store.heatValue(for: day)
                RoundedRectangle(cornerRadius: 4)
                    .fill(heatColor(level: levelFor(v)))
                    .frame(height: 22)
                    .overlay(
                        Group {
                            if Calendar.current.isDateInToday(day) {
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(MSTheme.gold, lineWidth: 1.5)
                            }
                        }
                    )
            }
        }
    }

    private func levelFor(_ v: Int) -> Int {
        switch v {
        case 0: return 0
        case 1..<100: return 1
        case 100..<300: return 2
        default: return 3
        }
    }

    private func lastDays(_ n: Int) -> [Date] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return (0..<n).reversed().compactMap { cal.date(byAdding: .day, value: -$0, to: today) }
    }
}
