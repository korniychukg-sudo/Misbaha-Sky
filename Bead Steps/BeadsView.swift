import SwiftUI

struct RoundSpec: Equatable {
    var itemId: String
    var title: String
    var arabic: String
    var translit: String
    var english: String
    var target: Int
    var setId: String?
    var queueIds: [String]
    var queueIndex: Int

    static func fromItem(_ item: DhikrItem, setId: String?, queueIds: [String], queueIndex: Int) -> RoundSpec {
        RoundSpec(
            itemId: item.id,
            title: item.translit,
            arabic: item.arabic,
            translit: item.translit,
            english: item.english,
            target: item.count,
            setId: setId,
            queueIds: queueIds,
            queueIndex: queueIndex
        )
    }
}

struct FreePhrase: Identifiable, Equatable {
    let id: String
    let arabic: String
    let translit: String
    let english: String

    static let all: [FreePhrase] = [
        FreePhrase(id: "free-subhan", arabic: "سُبْحَانَ اللَّهِ", translit: "Subhan Allah", english: "Glory be to Allah."),
        FreePhrase(id: "free-tahmid", arabic: "الْحَمْدُ لِلَّهِ", translit: "Alhamdu lillah", english: "All praise belongs to Allah."),
        FreePhrase(id: "free-takbir", arabic: "اللَّهُ أَكْبَرُ", translit: "Allahu akbar", english: "Allah is greater."),
        FreePhrase(id: "free-tahlil", arabic: "لَا إِلَهَ إِلَّا اللَّهُ", translit: "La ilaha illallah", english: "There is no god but Allah."),
        FreePhrase(id: "free-bihamdih", arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", translit: "Subhan Allahi wa bihamdih", english: "Glory be to Allah, and praise is His."),
        FreePhrase(id: "free-istighfar", arabic: "أَسْتَغْفِرُ اللَّهَ", translit: "Astaghfirullah", english: "I seek the forgiveness of Allah."),
        FreePhrase(id: "free-salawat", arabic: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ", translit: "Allahumma salli 'ala Muhammad", english: "O Allah, send blessings upon Muhammad."),
        FreePhrase(id: "free-hawqala", arabic: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", translit: "La hawla wa la quwwata illa billah", english: "There is no power and no strength except by Allah.")
    ]
}

struct BeadsView: View {
    @EnvironmentObject var store: BSStore
    @StateObject private var engine = BeadEngine()
    @State private var round: RoundSpec = RoundSpec.fromItem(
        AdhkarData.prayerSet.items[1], setId: nil, queueIds: [], queueIndex: 0
    )
    @State private var showChooser = false
    @State private var completed = false
    @State private var setFinished = false

    var body: some View {
        GeometryReader { geo in
            let wide = geo.size.width > geo.size.height && geo.size.width > 620
            ZStack {
                BSTheme.paper.ignoresSafeArea()
                if wide {
                    HStack(spacing: 0) {
                        infoColumn
                            .frame(width: geo.size.width * 0.42)
                            .padding(.horizontal, 20)
                        strandArea
                    }
                } else {
                    VStack(spacing: 0) {
                        dhikrCard
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                        strandArea
                        bottomBar
                            .padding(.horizontal, 16)
                            .padding(.bottom, 10)
                    }
                }
                if completed { completionOverlay }
            }
        }
        .sheet(isPresented: $showChooser) {
            DhikrChooserSheet { spec in
                startRound(spec)
            }
            .environmentObject(store)
        }
        .onReceive(store.$pendingLaunch) { req in
            guard let req = req else { return }
            startRound(req)
            store.pendingLaunch = nil
        }
    }

    private var infoColumn: some View {
        VStack(spacing: 16) {
            Spacer()
            dhikrCard
            counterCluster
            bottomButtons
            Spacer()
        }
    }

    private var strandArea: some View {
        ZStack(alignment: .topTrailing) {
            MisbahaStrand(
                engine: engine,
                style: store.beadStyle,
                sessionTarget: round.target,
                onAdvance: { handleAdvance() },
                onSettleBack: {}
            )
            .clipped()
            VStack(alignment: .trailing, spacing: 6) {
                countBadge
            }
            .padding(.trailing, 18)
            .padding(.top, 12)
        }
    }

    private var countBadge: some View {
        VStack(spacing: 2) {
            ZStack {
                ProgressRing(
                    progress: round.target > 0 ? Double(engine.committed) / Double(round.target) : 0,
                    lineWidth: 5
                )
                .frame(width: 74, height: 74)
                VStack(spacing: 0) {
                    Text("\(engine.committed)")
                        .font(BSTheme.round(26))
                        .foregroundColor(BSTheme.ink)
                    if round.target > 0 {
                        Text("of \(round.target)")
                            .font(BSTheme.text(11, .medium))
                            .foregroundColor(BSTheme.inkFaint)
                    }
                }
            }
            .padding(10)
            .background(Circle().fill(BSTheme.card.opacity(0.92)))
        }
    }

    private var dhikrCard: some View {
        Button {
            showChooser = true
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if !round.queueIds.isEmpty {
                        BSChip(text: "Step \(round.queueIndex + 1) of \(round.queueIds.count)", tint: BSTheme.terra)
                    } else {
                        BSChip(text: round.target > 0 ? "\(round.target) beads" : "Open count", tint: BSTheme.emerald)
                    }
                    Spacer()
                    Text("Change")
                        .font(BSTheme.text(12, .semibold))
                        .foregroundColor(BSTheme.gold)
                }
                Text(round.arabic)
                    .font(BSTheme.arabic(round.arabic.count > 60 ? 20 : 28))
                    .foregroundColor(BSTheme.ink)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(4)
                    .minimumScaleFactor(0.6)
                if store.state.showTranslit {
                    Text(round.translit)
                        .font(BSTheme.text(14, .semibold))
                        .foregroundColor(BSTheme.emerald)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                }
                Text(round.english)
                    .font(BSTheme.text(13))
                    .foregroundColor(BSTheme.inkSoft)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(ScalePressStyle())
        .bsCard()
    }

    private var counterCluster: some View {
        HStack(spacing: 18) {
            countBadge
            VStack(alignment: .leading, spacing: 6) {
                statLine(value: "\(store.todayCount)", label: "today")
                statLine(value: "\(store.streak)", label: "day streak")
            }
        }
    }

    private func statLine(value: String, label: String) -> some View {
        HStack(spacing: 6) {
            Text(value)
                .font(BSTheme.round(18))
                .foregroundColor(BSTheme.emerald)
            Text(label)
                .font(BSTheme.text(12))
                .foregroundColor(BSTheme.inkSoft)
        }
    }

    private var bottomBar: some View {
        HStack {
            bottomButtons
            Spacer()
            HStack(spacing: 14) {
                statLine(value: "\(store.todayCount)", label: "today")
                statLine(value: "\(store.streak)", label: "streak")
            }
        }
    }

    private var bottomButtons: some View {
        HStack(spacing: 10) {
            Button {
                undoBead()
            } label: {
                smallControl(label: "Undo")
            }
            .buttonStyle(ScalePressStyle())
            Button {
                restartRound()
            } label: {
                smallControl(label: "Restart")
            }
            .buttonStyle(ScalePressStyle())
        }
    }

    private func smallControl(label: String) -> some View {
        Text(label)
            .font(BSTheme.text(13, .semibold))
            .foregroundColor(BSTheme.inkSoft)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Capsule().fill(BSTheme.card))
            .overlay(Capsule().strokeBorder(BSTheme.line, lineWidth: 1))
    }

    private var completionOverlay: some View {
        ZStack {
            BSTheme.ink.opacity(0.35).ignoresSafeArea()
            VStack(spacing: 16) {
                ZStack {
                    GeometricRosette(tint: BSTheme.gold, petals: 10)
                        .frame(width: 86, height: 86)
                    Text("\(round.target)")
                        .font(BSTheme.round(28))
                        .foregroundColor(BSTheme.emerald)
                }
                Text(setFinished ? "Set complete" : "Round complete")
                    .font(BSTheme.serif(24))
                    .foregroundColor(BSTheme.ink)
                Text(setFinished
                     ? "Every remembrance in this set has been counted. Well done."
                     : round.translit)
                    .font(BSTheme.text(14))
                    .foregroundColor(BSTheme.inkSoft)
                    .multilineTextAlignment(.center)
                VStack(spacing: 10) {
                    if let next = nextInQueue() {
                        Button {
                            advanceQueue()
                        } label: {
                            primaryButton(title: "Continue: \(next.translit)", subtitle: "\(next.count) beads")
                        }
                        .buttonStyle(ScalePressStyle())
                    } else {
                        Button {
                            restartRound()
                            completed = false
                            setFinished = false
                        } label: {
                            primaryButton(title: "Count again", subtitle: nil)
                        }
                        .buttonStyle(ScalePressStyle())
                    }
                    Button {
                        completed = false
                        setFinished = false
                        restartRound()
                        showChooser = true
                    } label: {
                        Text("Choose another dhikr")
                            .font(BSTheme.text(14, .semibold))
                            .foregroundColor(BSTheme.emerald)
                    }
                }
            }
            .padding(26)
            .frame(maxWidth: 420)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(BSTheme.paper)
                    .shadow(color: BSTheme.ink.opacity(0.25), radius: 20, x: 0, y: 8)
            )
            .padding(.horizontal, 30)
        }
    }

    private func primaryButton(title: String, subtitle: String?) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(BSTheme.text(15, .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            if let s = subtitle {
                Text(s)
                    .font(BSTheme.text(11))
                    .opacity(0.8)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 22)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Capsule().fill(BSTheme.emerald))
    }

    private func handleAdvance() {
        let c = engine.committed
        if c > 0 && c % 33 == 0 {
            BSHaptics.divider()
        } else {
            BSHaptics.bead()
        }
        if round.target > 0 && c >= round.target {
            finishRound()
        }
    }

    private func finishRound() {
        store.logRound(itemId: round.itemId, title: round.title, count: round.target, setId: round.setId)
        if nextInQueue() == nil {
            if let setId = round.setId, !round.queueIds.isEmpty {
                store.completeSet(setId)
                setFinished = true
            }
        }
        BSHaptics.success()
        withAnimation(.easeOut(duration: 0.3)) {
            completed = true
        }
    }

    private func nextInQueue() -> DhikrItem? {
        guard !round.queueIds.isEmpty, round.queueIndex + 1 < round.queueIds.count else { return nil }
        return BSCatalog.item(round.queueIds[round.queueIndex + 1])
    }

    private func advanceQueue() {
        guard let next = nextInQueue() else { return }
        round = RoundSpec.fromItem(next, setId: round.setId, queueIds: round.queueIds, queueIndex: round.queueIndex + 1)
        engine.reset(to: 0)
        completed = false
        setFinished = false
    }

    private func startRound(_ spec: RoundSpec) {
        flushOpenCount()
        round = spec
        engine.reset(to: 0)
        completed = false
        setFinished = false
        showChooser = false
    }

    private func restartRound() {
        flushOpenCount()
        engine.reset(to: 0)
    }

    private func undoBead() {
        if engine.committed > 0 {
            engine.committed -= 1
            engine.fraction = 0
            BSHaptics.tap()
        }
    }

    private func flushOpenCount() {
        if round.target == 0 && engine.committed > 0 {
            store.logRound(itemId: round.itemId, title: round.title, count: engine.committed, setId: nil)
        }
    }
}

struct DhikrChooserSheet: View {
    @EnvironmentObject var store: BSStore
    @Environment(\.presentationMode) var presentation
    let onPick: (RoundSpec) -> Void
    @State private var freeTarget: Int = 33

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    BSSectionHeader(title: "Free counting", subtitle: "Pick a phrase and a target")
                    HStack(spacing: 8) {
                        ForEach([33, 99, 100, 300, 0], id: \.self) { t in
                            Button {
                                freeTarget = t
                                BSHaptics.tap()
                            } label: {
                                Text(t == 0 ? "Open" : "\(t)")
                                    .font(BSTheme.text(13, .semibold))
                                    .foregroundColor(freeTarget == t ? .white : BSTheme.emerald)
                                    .padding(.horizontal, 13)
                                    .padding(.vertical, 7)
                                    .background(
                                        Capsule().fill(freeTarget == t ? BSTheme.emerald : BSTheme.emerald.opacity(0.1))
                                    )
                            }
                            .buttonStyle(ScalePressStyle())
                        }
                    }
                    VStack(spacing: 8) {
                        ForEach(FreePhrase.all) { phrase in
                            Button {
                                onPick(RoundSpec(
                                    itemId: phrase.id,
                                    title: phrase.translit,
                                    arabic: phrase.arabic,
                                    translit: phrase.translit,
                                    english: phrase.english,
                                    target: freeTarget,
                                    setId: nil,
                                    queueIds: [],
                                    queueIndex: 0
                                ))
                                presentation.wrappedValue.dismiss()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(phrase.translit)
                                            .font(BSTheme.text(14, .semibold))
                                            .foregroundColor(BSTheme.ink)
                                        Text(phrase.english)
                                            .font(BSTheme.text(12))
                                            .foregroundColor(BSTheme.inkSoft)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    Text(phrase.arabic)
                                        .font(BSTheme.arabic(17))
                                        .foregroundColor(BSTheme.emerald)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(BSTheme.card)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .strokeBorder(BSTheme.line, lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(ScalePressStyle())
                        }
                    }
                    BSSectionHeader(title: "From the sets", subtitle: "Any single remembrance")
                    ForEach(BSCatalog.sets) { set in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(set.title)
                                .font(BSTheme.serif(16))
                                .foregroundColor(BSTheme.ink)
                            VStack(spacing: 6) {
                                ForEach(set.items) { item in
                                    Button {
                                        onPick(RoundSpec.fromItem(item, setId: nil, queueIds: [], queueIndex: 0))
                                        presentation.wrappedValue.dismiss()
                                    } label: {
                                        HStack {
                                            Text(item.translit)
                                                .font(BSTheme.text(13, .medium))
                                                .foregroundColor(BSTheme.ink)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.7)
                                            Spacer()
                                            BSChip(text: "\(item.count)", tint: BSTheme.gold)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 9)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(BSTheme.card)
                                        )
                                    }
                                    .buttonStyle(ScalePressStyle())
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(BSTheme.paper.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Choose a dhikr")
                        .font(BSTheme.serif(17))
                        .foregroundColor(BSTheme.ink)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentation.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                            .font(BSTheme.text(14, .semibold))
                            .foregroundColor(BSTheme.emerald)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
