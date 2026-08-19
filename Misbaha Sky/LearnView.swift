import SwiftUI

struct LearnView: View {
    @EnvironmentObject var store: MSStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                MSSectionHeader(title: "Guides", subtitle: "The craft behind the beads")
                VStack(spacing: 12) {
                    ForEach(MSCatalog.guides) { guide in
                        NavigationLink(destination: GuideDetailView(guide: guide)) {
                            guideCard(guide)
                        }
                        .buttonStyle(ScalePressStyle())
                    }
                }
                NavigationLink(destination: QuizView()) {
                    quizCard
                }
                .buttonStyle(ScalePressStyle())
                NavigationLink(destination: GlossaryView()) {
                    glossaryCard
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
                Text("Learn")
                    .font(MSTheme.serif(18))
                    .foregroundColor(MSTheme.ink)
            }
        }
    }

    private func guideCard(_ guide: MSGuide) -> some View {
        HStack(spacing: 12) {
            ArtImage(name: guide.artName)
                .frame(width: 76, height: 76)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(guide.title)
                    .font(MSTheme.serif(17))
                    .foregroundColor(MSTheme.ink)
                Text(guide.subtitle)
                    .font(MSTheme.text(12))
                    .foregroundColor(MSTheme.inkSoft)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    MSChip(text: "\(guide.minutes) min", tint: MSTheme.gold)
                    if store.state.guidesRead.contains(guide.id) {
                        MSChip(text: "Read", tint: MSTheme.emerald)
                    }
                }
            }
            Spacer()
            ChevronIcon()
        }
        .msCard(padding: 12)
    }

    private var quizCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(MSTheme.terraSoft).frame(width: 54, height: 54)
                StarShape(points: 5)
                    .fill(MSTheme.terra)
                    .frame(width: 24, height: 24)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Take the quiz")
                    .font(MSTheme.serif(17))
                    .foregroundColor(MSTheme.ink)
                Text("Ten fresh questions on names, terms and counts")
                    .font(MSTheme.text(12))
                    .foregroundColor(MSTheme.inkSoft)
                if store.state.quizRounds > 0 {
                    MSChip(text: "Best \(store.state.quizBest) of 10", tint: MSTheme.terra)
                }
            }
            Spacer()
            ChevronIcon()
        }
        .msCard(padding: 12)
    }

    private var glossaryCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(MSTheme.emeraldSoft).frame(width: 54, height: 54)
                LearnIcon(size: 26, color: MSTheme.emerald)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Glossary")
                    .font(MSTheme.serif(17))
                    .foregroundColor(MSTheme.ink)
                Text("\(MSCatalog.glossary.count) terms of the practice, plainly put")
                    .font(MSTheme.text(12))
                    .foregroundColor(MSTheme.inkSoft)
            }
            Spacer()
            ChevronIcon()
        }
        .msCard(padding: 12)
    }
}

struct GuideDetailView: View {
    @EnvironmentObject var store: MSStore
    let guide: MSGuide

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArtPlate(name: guide.artName, height: 200)
                Text(guide.subtitle)
                    .font(MSTheme.text(14))
                    .foregroundColor(MSTheme.inkSoft)
                ForEach(Array(guide.sections.enumerated()), id: \.offset) { _, section in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(section.heading)
                            .font(MSTheme.serif(18))
                            .foregroundColor(MSTheme.emerald)
                        Text(section.body)
                            .font(MSTheme.text(14))
                            .foregroundColor(MSTheme.ink.opacity(0.85))
                            .lineSpacing(5)
                    }
                    .msCard()
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Worth keeping")
                        .font(MSTheme.serif(16))
                        .foregroundColor(MSTheme.gold)
                    ForEach(Array(guide.facts.enumerated()), id: \.offset) { _, fact in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .fill(MSTheme.gold)
                                .frame(width: 5, height: 5)
                                .padding(.top, 6)
                            Text(fact)
                                .font(MSTheme.text(13))
                                .foregroundColor(MSTheme.inkSoft)
                        }
                    }
                }
                .msCard()
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(MSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(guide.title)
                    .font(MSTheme.serif(18))
                    .foregroundColor(MSTheme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .onAppear {
            store.markGuideRead(guide.id)
        }
    }
}

struct GlossaryView: View {
    @State private var query = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                TextField("Search terms", text: $query)
                    .font(MSTheme.text(14))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(MSTheme.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(MSTheme.line, lineWidth: 1)
                            )
                    )
                ForEach(filtered) { term in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(term.term)
                            .font(MSTheme.serif(16))
                            .foregroundColor(MSTheme.emerald)
                        Text(term.definition)
                            .font(MSTheme.text(13))
                            .foregroundColor(MSTheme.inkSoft)
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .msCard(padding: 13)
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(MSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Glossary")
                    .font(MSTheme.serif(18))
                    .foregroundColor(MSTheme.ink)
            }
        }
    }

    private var filtered: [MSTerm] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        if q.isEmpty { return MSCatalog.glossary }
        return MSCatalog.glossary.filter {
            $0.term.lowercased().contains(q) || $0.definition.lowercased().contains(q)
        }
    }
}
