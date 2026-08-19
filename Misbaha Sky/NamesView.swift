import SwiftUI

struct NamesView: View {
    @EnvironmentObject var store: MSStore
    @State private var selected: DivineName? = nil
    @State private var filter: Int = 0
    @State private var showDrill = false

    private let columns = [GridItem(.adaptive(minimum: 108), spacing: 10)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                dailyCard
                studyCard
                HStack {
                    picker
                    Spacer()
                    MSChip(text: "\(store.state.namesRead.count) of 99 read", tint: MSTheme.emerald)
                }
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(filteredNames) { name in
                        Button {
                            selected = name
                        } label: {
                            nameTile(name)
                        }
                        .buttonStyle(ScalePressStyle())
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
                Text("The Ninety-Nine Names")
                    .font(MSTheme.serif(18))
                    .foregroundColor(MSTheme.ink)
            }
        }
        .sheet(item: $selected) { name in
            NameDetailSheet(name: name)
                .environmentObject(store)
        }
        .sheet(isPresented: $showDrill) {
            NameDrillView()
                .environmentObject(store)
        }
    }

    private var studyCard: some View {
        Button {
            showDrill = true
            MSHaptics.tap()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(MSTheme.goldSoft.opacity(0.5)).frame(width: 44, height: 44)
                    StarShape(points: 8)
                        .fill(MSTheme.gold)
                        .frame(width: 20, height: 20)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Study ten")
                        .font(MSTheme.serif(16))
                        .foregroundColor(MSTheme.ink)
                    Text("A short flashcard sitting — unread names first")
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

    private var filteredNames: [DivineName] {
        switch filter {
        case 1: return MSCatalog.names.filter { store.state.favNames.contains($0.id) }
        case 2: return MSCatalog.names.filter { !store.state.namesRead.contains($0.id) }
        default: return MSCatalog.names
        }
    }

    private var picker: some View {
        HStack(spacing: 6) {
            ForEach(Array(["All", "Loved", "Unread"].enumerated()), id: \.offset) { idx, label in
                Button {
                    filter = idx
                    MSHaptics.tap()
                } label: {
                    Text(label)
                        .font(MSTheme.text(12, .semibold))
                        .foregroundColor(filter == idx ? .white : MSTheme.inkSoft)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(filter == idx ? MSTheme.emerald : MSTheme.card))
                        .overlay(Capsule().strokeBorder(filter == idx ? Color.clear : MSTheme.line, lineWidth: 1))
                }
                .buttonStyle(ScalePressStyle())
            }
        }
    }

    private var dailyCard: some View {
        let name = store.dailyName
        return Button {
            selected = name
        } label: {
            ZStack {
                ArtImage(name: "names-hero")
                    .frame(height: 168)
                    .clipped()
                    .overlay(Color.black.opacity(0.32))
                VStack(spacing: 6) {
                    Text("Name of the day")
                        .font(MSTheme.text(11, .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    Text(name.arabic)
                        .font(MSTheme.arabic(34, .semibold))
                        .foregroundColor(.white)
                    Text("\(name.translit) — \(name.meaning)")
                        .font(MSTheme.text(14, .semibold))
                        .foregroundColor(MSTheme.goldSoft)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .padding(16)
            }
            .frame(height: 168)
            .clipShape(RoundedRectangle(cornerRadius: MSTheme.corner, style: .continuous))
        }
        .buttonStyle(ScalePressStyle())
    }

    private func nameTile(_ name: DivineName) -> some View {
        let read = store.state.namesRead.contains(name.id)
        let loved = store.state.favNames.contains(name.id)
        return VStack(spacing: 5) {
            HStack {
                Text("\(name.id)")
                    .font(MSTheme.round(10))
                    .foregroundColor(MSTheme.inkFaint)
                Spacer()
                if loved {
                    HeartIcon(size: 11, color: MSTheme.terra, filled: true)
                }
                if read {
                    CheckIcon(size: 11)
                }
            }
            Text(name.arabic)
                .font(MSTheme.arabic(21))
                .foregroundColor(MSTheme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(name.translit)
                .font(MSTheme.text(11, .semibold))
                .foregroundColor(MSTheme.emerald)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(name.meaning)
                .font(MSTheme.text(9))
                .foregroundColor(MSTheme.inkSoft)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(read ? MSTheme.emeraldSoft.opacity(0.5) : MSTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(read ? MSTheme.emerald.opacity(0.3) : MSTheme.line, lineWidth: 1)
                )
        )
    }
}

struct NameDetailSheet: View {
    @EnvironmentObject var store: MSStore
    @Environment(\.presentationMode) var presentation
    let name: DivineName

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    store.toggleFavName(name.id)
                    MSHaptics.tap()
                } label: {
                    HeartIcon(size: 20, color: MSTheme.terra, filled: store.state.favNames.contains(name.id))
                        .padding(8)
                }
                Spacer()
                Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Text("Close")
                        .font(MSTheme.text(14, .semibold))
                        .foregroundColor(MSTheme.emerald)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            ScrollView {
                VStack(spacing: 18) {
                    ZStack {
                        GeometricRosette(tint: MSTheme.gold.opacity(0.7), petals: 12)
                            .frame(width: 210, height: 210)
                        VStack(spacing: 8) {
                            Text(name.arabic)
                                .font(MSTheme.arabic(44, .semibold))
                                .foregroundColor(MSTheme.ink)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                                .frame(maxWidth: 190)
                            Text("\(name.id) of 99")
                                .font(MSTheme.round(11))
                                .foregroundColor(MSTheme.inkFaint)
                        }
                    }
                    .padding(.top, 8)
                    VStack(spacing: 4) {
                        Text(name.translit)
                            .font(MSTheme.serif(24))
                            .foregroundColor(MSTheme.emerald)
                        Text(name.meaning)
                            .font(MSTheme.text(15, .semibold))
                            .foregroundColor(MSTheme.ink)
                    }
                    Text(name.reflection)
                        .font(MSTheme.text(14))
                        .foregroundColor(MSTheme.inkSoft)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 26)
                    if !store.state.namesRead.contains(name.id) {
                        Button {
                            store.markNameRead(name.id)
                            MSHaptics.success()
                        } label: {
                            Text("Mark as read")
                                .font(MSTheme.text(15, .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 26)
                                .padding(.vertical, 11)
                                .background(Capsule().fill(MSTheme.emerald))
                        }
                        .buttonStyle(ScalePressStyle())
                    } else {
                        HStack(spacing: 6) {
                            CheckIcon()
                            Text("Read")
                                .font(MSTheme.text(14, .semibold))
                                .foregroundColor(MSTheme.emerald)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .background(MSTheme.paper.ignoresSafeArea())
    }
}

struct NameDrillView: View {
    @EnvironmentObject var store: MSStore
    @Environment(\.presentationMode) var presentation
    @State private var deck: [DivineName] = []
    @State private var index = 0
    @State private var revealed = false
    @State private var knew = 0
    @State private var again = 0
    @State private var newlyRead: [Int] = []
    @State private var finished = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if !finished && !deck.isEmpty {
                    MSChip(text: "Card \(min(index + 1, deck.count)) of \(deck.count)", tint: MSTheme.emerald)
                }
                Spacer()
                Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Text("Close")
                        .font(MSTheme.text(14, .semibold))
                        .foregroundColor(MSTheme.emerald)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            Spacer()
            if finished {
                resultView
            } else if index < deck.count {
                cardView(deck[index])
            }
            Spacer()
        }
        .background(MSTheme.paper.ignoresSafeArea())
        .onAppear { buildDeck() }
    }

    private func buildDeck() {
        guard deck.isEmpty else { return }
        let unread = MSCatalog.names.filter { !store.state.namesRead.contains($0.id) }.shuffled()
        let read = MSCatalog.names.filter { store.state.namesRead.contains($0.id) }.shuffled()
        deck = Array((unread + read).prefix(10))
    }

    private func cardView(_ name: DivineName) -> some View {
        VStack(spacing: 22) {
            ZStack {
                GeometricRosette(tint: MSTheme.gold.opacity(0.6), petals: 12)
                    .frame(width: 190, height: 190)
                VStack(spacing: 6) {
                    Text(name.arabic)
                        .font(MSTheme.arabic(40, .semibold))
                        .foregroundColor(MSTheme.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .frame(maxWidth: 170)
                    Text(name.translit)
                        .font(MSTheme.serif(19))
                        .foregroundColor(MSTheme.emerald)
                }
            }
            if revealed {
                VStack(spacing: 8) {
                    Text(name.meaning)
                        .font(MSTheme.text(17, .semibold))
                        .foregroundColor(MSTheme.ink)
                    Text(name.reflection)
                        .font(MSTheme.text(13))
                        .foregroundColor(MSTheme.inkSoft)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                }
                HStack(spacing: 12) {
                    Button {
                        answer(knewIt: false)
                    } label: {
                        Text("Again")
                            .font(MSTheme.text(15, .semibold))
                            .foregroundColor(MSTheme.terra)
                            .frame(width: 130)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(MSTheme.terraSoft.opacity(0.6)))
                    }
                    .buttonStyle(ScalePressStyle())
                    Button {
                        answer(knewIt: true)
                    } label: {
                        Text("Knew it")
                            .font(MSTheme.text(15, .semibold))
                            .foregroundColor(.white)
                            .frame(width: 130)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(MSTheme.emerald))
                    }
                    .buttonStyle(ScalePressStyle())
                }
                .padding(.top, 6)
            } else {
                Text("What does this name mean?")
                    .font(MSTheme.text(14))
                    .foregroundColor(MSTheme.inkFaint)
                Button {
                    withAnimation(.easeOut(duration: 0.2)) { revealed = true }
                    MSHaptics.tap()
                } label: {
                    Text("Reveal")
                        .font(MSTheme.text(15, .semibold))
                        .foregroundColor(.white)
                        .frame(width: 180)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(MSTheme.gold))
                }
                .buttonStyle(ScalePressStyle())
            }
        }
        .padding(.horizontal, 20)
    }

    private func answer(knewIt: Bool) {
        let name = deck[index]
        if knewIt {
            knew += 1
            if !store.state.namesRead.contains(name.id) {
                newlyRead.append(name.id)
                store.markNameRead(name.id)
            }
            MSHaptics.success()
        } else {
            again += 1
            if deck.count < 26 {
                deck.append(name)
            }
            MSHaptics.settle()
        }
        revealed = false
        index += 1
        if index >= deck.count {
            finished = true
        }
    }

    private var resultView: some View {
        VStack(spacing: 14) {
            ZStack {
                ProgressRing(progress: Double(knew) / Double(max(1, knew + again)), lineWidth: 7, tint: MSTheme.gold)
                    .frame(width: 104, height: 104)
                VStack(spacing: 0) {
                    Text("\(knew)")
                        .font(MSTheme.round(32))
                        .foregroundColor(MSTheme.ink)
                    Text("known")
                        .font(MSTheme.text(11))
                        .foregroundColor(MSTheme.inkFaint)
                }
            }
            Text("Sitting complete")
                .font(MSTheme.serif(23))
                .foregroundColor(MSTheme.ink)
            Text(newlyRead.isEmpty
                 ? "Every card in this sitting was already familiar."
                 : "\(newlyRead.count) name\(newlyRead.count == 1 ? "" : "s") newly marked as read.")
                .font(MSTheme.text(13))
                .foregroundColor(MSTheme.inkSoft)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            Button {
                deck = []
                index = 0
                knew = 0
                again = 0
                newlyRead = []
                finished = false
                revealed = false
                buildDeck()
            } label: {
                Text("Another ten")
                    .font(MSTheme.text(15, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 34)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(MSTheme.emerald))
            }
            .buttonStyle(ScalePressStyle())
        }
    }
}
