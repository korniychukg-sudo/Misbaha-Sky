import SwiftUI

struct LearnView: View {
    @EnvironmentObject var store: BSStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                BSSectionHeader(title: "Guides", subtitle: "The craft behind the beads")
                VStack(spacing: 12) {
                    ForEach(BSCatalog.guides) { guide in
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
        .background(BSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Learn")
                    .font(BSTheme.serif(18))
                    .foregroundColor(BSTheme.ink)
            }
        }
    }

    private func guideCard(_ guide: BSGuide) -> some View {
        HStack(spacing: 12) {
            ArtImage(name: guide.artName)
                .frame(width: 76, height: 76)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(guide.title)
                    .font(BSTheme.serif(17))
                    .foregroundColor(BSTheme.ink)
                Text(guide.subtitle)
                    .font(BSTheme.text(12))
                    .foregroundColor(BSTheme.inkSoft)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    BSChip(text: "\(guide.minutes) min", tint: BSTheme.gold)
                    if store.state.guidesRead.contains(guide.id) {
                        BSChip(text: "Read", tint: BSTheme.emerald)
                    }
                }
            }
            Spacer()
            ChevronIcon()
        }
        .bsCard(padding: 12)
    }

    private var quizCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(BSTheme.terraSoft).frame(width: 54, height: 54)
                StarShape(points: 5)
                    .fill(BSTheme.terra)
                    .frame(width: 24, height: 24)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Take the quiz")
                    .font(BSTheme.serif(17))
                    .foregroundColor(BSTheme.ink)
                Text("Ten fresh questions on names, terms and counts")
                    .font(BSTheme.text(12))
                    .foregroundColor(BSTheme.inkSoft)
                if store.state.quizRounds > 0 {
                    BSChip(text: "Best \(store.state.quizBest) of 10", tint: BSTheme.terra)
                }
            }
            Spacer()
            ChevronIcon()
        }
        .bsCard(padding: 12)
    }

    private var glossaryCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(BSTheme.emeraldSoft).frame(width: 54, height: 54)
                LearnIcon(size: 26, color: BSTheme.emerald)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Glossary")
                    .font(BSTheme.serif(17))
                    .foregroundColor(BSTheme.ink)
                Text("\(BSCatalog.glossary.count) terms of the practice, plainly put")
                    .font(BSTheme.text(12))
                    .foregroundColor(BSTheme.inkSoft)
            }
            Spacer()
            ChevronIcon()
        }
        .bsCard(padding: 12)
    }
}

struct GuideDetailView: View {
    @EnvironmentObject var store: BSStore
    let guide: BSGuide

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArtPlate(name: guide.artName, height: 200)
                Text(guide.subtitle)
                    .font(BSTheme.text(14))
                    .foregroundColor(BSTheme.inkSoft)
                ForEach(Array(guide.sections.enumerated()), id: \.offset) { _, section in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(section.heading)
                            .font(BSTheme.serif(18))
                            .foregroundColor(BSTheme.emerald)
                        Text(section.body)
                            .font(BSTheme.text(14))
                            .foregroundColor(BSTheme.ink.opacity(0.85))
                            .lineSpacing(5)
                    }
                    .bsCard()
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Worth keeping")
                        .font(BSTheme.serif(16))
                        .foregroundColor(BSTheme.gold)
                    ForEach(Array(guide.facts.enumerated()), id: \.offset) { _, fact in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .fill(BSTheme.gold)
                                .frame(width: 5, height: 5)
                                .padding(.top, 6)
                            Text(fact)
                                .font(BSTheme.text(13))
                                .foregroundColor(BSTheme.inkSoft)
                        }
                    }
                }
                .bsCard()
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(BSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(guide.title)
                    .font(BSTheme.serif(18))
                    .foregroundColor(BSTheme.ink)
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
                    .font(BSTheme.text(14))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(BSTheme.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(BSTheme.line, lineWidth: 1)
                            )
                    )
                ForEach(filtered) { term in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(term.term)
                            .font(BSTheme.serif(16))
                            .foregroundColor(BSTheme.emerald)
                        Text(term.definition)
                            .font(BSTheme.text(13))
                            .foregroundColor(BSTheme.inkSoft)
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bsCard(padding: 13)
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(BSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Glossary")
                    .font(BSTheme.serif(18))
                    .foregroundColor(BSTheme.ink)
            }
        }
    }

    private var filtered: [BSTerm] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        if q.isEmpty { return BSCatalog.glossary }
        return BSCatalog.glossary.filter {
            $0.term.lowercased().contains(q) || $0.definition.lowercased().contains(q)
        }
    }
}
