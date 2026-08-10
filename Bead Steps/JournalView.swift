import SwiftUI

struct JournalView: View {
    @EnvironmentObject var store: BSStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                summaryRow
                heatmapCard
                favouritesCard
                badgesCard
                sessionsCard
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Text("Settings")
                            .font(BSTheme.serif(16))
                            .foregroundColor(BSTheme.ink)
                        Spacer()
                        ChevronIcon()
                    }
                    .bsCard(padding: 14)
                }
                .buttonStyle(ScalePressStyle())
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(BSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Journal")
                    .font(BSTheme.serif(18))
                    .foregroundColor(BSTheme.ink)
            }
        }
    }

    private var summaryRow: some View {
        HStack(spacing: 10) {
            statCard(value: "\(store.todayCount)", label: "beads today", tint: BSTheme.emerald)
            statCard(value: "\(store.streak)", label: "day streak", tint: BSTheme.gold)
            statCard(value: compact(store.state.totalBeads), label: "beads in all", tint: BSTheme.terra)
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
                .font(BSTheme.round(24))
                .foregroundColor(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(BSTheme.text(11))
                .foregroundColor(BSTheme.inkSoft)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(BSTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(BSTheme.line, lineWidth: 1)
                )
        )
    }

    private var heatmapCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Five weeks of practice")
                .font(BSTheme.serif(16))
                .foregroundColor(BSTheme.ink)
            HeatmapGrid()
            HStack(spacing: 10) {
                Text("less")
                    .font(BSTheme.text(10))
                    .foregroundColor(BSTheme.inkFaint)
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(heatColor(level: i))
                        .frame(width: 14, height: 14)
                }
                Text("more")
                    .font(BSTheme.text(10))
                    .foregroundColor(BSTheme.inkFaint)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .bsCard()
    }

    private var favouritesCard: some View {
        let top = store.state.perItem.sorted { $0.value > $1.value }.prefix(5)
        return Group {
            if !top.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Most counted")
                        .font(BSTheme.serif(16))
                        .foregroundColor(BSTheme.ink)
                    let maxVal = top.first?.value ?? 1
                    ForEach(Array(top), id: \.key) { key, value in
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text(titleFor(key))
                                    .font(BSTheme.text(13, .medium))
                                    .foregroundColor(BSTheme.ink)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                Spacer()
                                Text("\(value)")
                                    .font(BSTheme.round(13))
                                    .foregroundColor(BSTheme.emerald)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(BSTheme.line.opacity(0.4))
                                    Capsule()
                                        .fill(BSTheme.emerald)
                                        .frame(width: max(6, geo.size.width * CGFloat(value) / CGFloat(maxVal)))
                                }
                            }
                            .frame(height: 6)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .bsCard()
            }
        }
    }

    private func titleFor(_ key: String) -> String {
        if let item = BSCatalog.item(key) { return item.translit }
        if let phrase = FreePhrase.all.first(where: { $0.id == key }) { return phrase.translit }
        return key
    }

    private var badgesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Badges")
                    .font(BSTheme.serif(16))
                    .foregroundColor(BSTheme.ink)
                Spacer()
                BSChip(text: "\(store.state.earned.count) of \(BSCatalog.badges.count)", tint: BSTheme.gold)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 8)], spacing: 8) {
                ForEach(BSCatalog.badges) { badge in
                    let earned = store.state.earned.contains(badge.id)
                    VStack(spacing: 5) {
                        StarShape(points: 8)
                            .fill(earned ? BSTheme.gold : BSTheme.line.opacity(0.7))
                            .frame(width: 26, height: 26)
                        Text(badge.title)
                            .font(BSTheme.text(10, .semibold))
                            .foregroundColor(earned ? BSTheme.ink : BSTheme.inkFaint)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        Text(badge.detail)
                            .font(BSTheme.text(8))
                            .foregroundColor(BSTheme.inkFaint)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, minHeight: 92)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(earned ? BSTheme.goldSoft.opacity(0.35) : BSTheme.paperDeep.opacity(0.5))
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .bsCard()
    }

    private var sessionsCard: some View {
        Group {
            if !store.state.sessions.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent rounds")
                        .font(BSTheme.serif(16))
                        .foregroundColor(BSTheme.ink)
                    ForEach(store.state.sessions.prefix(12)) { rec in
                        HStack {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(rec.title)
                                    .font(BSTheme.text(13, .medium))
                                    .foregroundColor(BSTheme.ink)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                Text(Self.timeFormatter.string(from: rec.date))
                                    .font(BSTheme.text(10))
                                    .foregroundColor(BSTheme.inkFaint)
                            }
                            Spacer()
                            BSChip(text: "\(rec.count)", tint: BSTheme.emerald)
                        }
                        .padding(.vertical, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .bsCard()
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
    case 0: return BSTheme.line.opacity(0.35)
    case 1: return BSTheme.emerald.opacity(0.3)
    case 2: return BSTheme.emerald.opacity(0.6)
    default: return BSTheme.emerald
    }
}

struct HeatmapGrid: View {
    @EnvironmentObject var store: BSStore

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
                                    .strokeBorder(BSTheme.gold, lineWidth: 1.5)
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
