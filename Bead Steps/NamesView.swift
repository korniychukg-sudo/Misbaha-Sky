import SwiftUI

struct NamesView: View {
    @EnvironmentObject var store: BSStore
    @State private var selected: DivineName? = nil
    @State private var filter: Int = 0

    private let columns = [GridItem(.adaptive(minimum: 108), spacing: 10)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                dailyCard
                HStack {
                    picker
                    Spacer()
                    BSChip(text: "\(store.state.namesRead.count) of 99 read", tint: BSTheme.emerald)
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
        .background(BSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("The Ninety-Nine Names")
                    .font(BSTheme.serif(18))
                    .foregroundColor(BSTheme.ink)
            }
        }
        .sheet(item: $selected) { name in
            NameDetailSheet(name: name)
                .environmentObject(store)
        }
    }

    private var filteredNames: [DivineName] {
        switch filter {
        case 1: return BSCatalog.names.filter { store.state.favNames.contains($0.id) }
        case 2: return BSCatalog.names.filter { !store.state.namesRead.contains($0.id) }
        default: return BSCatalog.names
        }
    }

    private var picker: some View {
        HStack(spacing: 6) {
            ForEach(Array(["All", "Loved", "Unread"].enumerated()), id: \.offset) { idx, label in
                Button {
                    filter = idx
                    BSHaptics.tap()
                } label: {
                    Text(label)
                        .font(BSTheme.text(12, .semibold))
                        .foregroundColor(filter == idx ? .white : BSTheme.inkSoft)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(filter == idx ? BSTheme.emerald : BSTheme.card))
                        .overlay(Capsule().strokeBorder(filter == idx ? Color.clear : BSTheme.line, lineWidth: 1))
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
                        .font(BSTheme.text(11, .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    Text(name.arabic)
                        .font(BSTheme.arabic(34, .semibold))
                        .foregroundColor(.white)
                    Text("\(name.translit) — \(name.meaning)")
                        .font(BSTheme.text(14, .semibold))
                        .foregroundColor(BSTheme.goldSoft)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .padding(16)
            }
            .frame(height: 168)
            .clipShape(RoundedRectangle(cornerRadius: BSTheme.corner, style: .continuous))
        }
        .buttonStyle(ScalePressStyle())
    }

    private func nameTile(_ name: DivineName) -> some View {
        let read = store.state.namesRead.contains(name.id)
        let loved = store.state.favNames.contains(name.id)
        return VStack(spacing: 5) {
            HStack {
                Text("\(name.id)")
                    .font(BSTheme.round(10))
                    .foregroundColor(BSTheme.inkFaint)
                Spacer()
                if loved {
                    HeartIcon(size: 11, color: BSTheme.terra, filled: true)
                }
                if read {
                    CheckIcon(size: 11)
                }
            }
            Text(name.arabic)
                .font(BSTheme.arabic(21))
                .foregroundColor(BSTheme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(name.translit)
                .font(BSTheme.text(11, .semibold))
                .foregroundColor(BSTheme.emerald)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(name.meaning)
                .font(BSTheme.text(9))
                .foregroundColor(BSTheme.inkSoft)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(read ? BSTheme.emeraldSoft.opacity(0.5) : BSTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(read ? BSTheme.emerald.opacity(0.3) : BSTheme.line, lineWidth: 1)
                )
        )
    }
}

struct NameDetailSheet: View {
    @EnvironmentObject var store: BSStore
    @Environment(\.presentationMode) var presentation
    let name: DivineName

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    store.toggleFavName(name.id)
                    BSHaptics.tap()
                } label: {
                    HeartIcon(size: 20, color: BSTheme.terra, filled: store.state.favNames.contains(name.id))
                        .padding(8)
                }
                Spacer()
                Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Text("Close")
                        .font(BSTheme.text(14, .semibold))
                        .foregroundColor(BSTheme.emerald)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            ScrollView {
                VStack(spacing: 18) {
                    ZStack {
                        GeometricRosette(tint: BSTheme.gold.opacity(0.7), petals: 12)
                            .frame(width: 210, height: 210)
                        VStack(spacing: 8) {
                            Text(name.arabic)
                                .font(BSTheme.arabic(44, .semibold))
                                .foregroundColor(BSTheme.ink)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                                .frame(maxWidth: 190)
                            Text("\(name.id) of 99")
                                .font(BSTheme.round(11))
                                .foregroundColor(BSTheme.inkFaint)
                        }
                    }
                    .padding(.top, 8)
                    VStack(spacing: 4) {
                        Text(name.translit)
                            .font(BSTheme.serif(24))
                            .foregroundColor(BSTheme.emerald)
                        Text(name.meaning)
                            .font(BSTheme.text(15, .semibold))
                            .foregroundColor(BSTheme.ink)
                    }
                    Text(name.reflection)
                        .font(BSTheme.text(14))
                        .foregroundColor(BSTheme.inkSoft)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 26)
                    if !store.state.namesRead.contains(name.id) {
                        Button {
                            store.markNameRead(name.id)
                            BSHaptics.success()
                        } label: {
                            Text("Mark as read")
                                .font(BSTheme.text(15, .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 26)
                                .padding(.vertical, 11)
                                .background(Capsule().fill(BSTheme.emerald))
                        }
                        .buttonStyle(ScalePressStyle())
                    } else {
                        HStack(spacing: 6) {
                            CheckIcon()
                            Text("Read")
                                .font(BSTheme.text(14, .semibold))
                                .foregroundColor(BSTheme.emerald)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .background(BSTheme.paper.ignoresSafeArea())
    }
}
