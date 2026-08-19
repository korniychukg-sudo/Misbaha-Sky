import Foundation

struct DhikrItem: Identifiable, Hashable {
    let id: String
    let arabic: String
    let translit: String
    let english: String
    let count: Int
    let note: String
    let source: String
}

struct AdhkarSet: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let timeHint: String
    let artName: String
    let intro: String
    let items: [DhikrItem]

    var totalBeads: Int { items.reduce(0) { $0 + $1.count } }
}

struct DivineName: Identifiable, Hashable {
    let id: Int
    let arabic: String
    let translit: String
    let meaning: String
    let reflection: String
}

struct MSGuideSection: Hashable {
    let heading: String
    let body: String
}

struct MSGuide: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let artName: String
    let minutes: Int
    let sections: [MSGuideSection]
    let facts: [String]
}

struct MSTerm: Identifiable, Hashable {
    let id: String
    let term: String
    let definition: String
}

struct MSBadge: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
}

struct FreeTarget: Identifiable, Hashable {
    let id: String
    let title: String
    let count: Int
}

enum MSCatalog {
    static let sets: [AdhkarSet] = AdhkarData.all
    static let names: [DivineName] = NamesData.all
    static let guides: [MSGuide] = LoreData.guides
    static let glossary: [MSTerm] = LoreData.glossary
    static let badges: [MSBadge] = LoreData.badges

    static let freeTargets: [FreeTarget] = [
        FreeTarget(id: "f33", title: "One round", count: 33),
        FreeTarget(id: "f99", title: "Full strand", count: 99),
        FreeTarget(id: "f100", title: "One hundred", count: 100),
        FreeTarget(id: "f300", title: "Long sitting", count: 300),
        FreeTarget(id: "f1000", title: "One thousand", count: 1000)
    ]

    static func set(_ id: String) -> AdhkarSet? { sets.first { $0.id == id } }

    static func item(_ id: String) -> DhikrItem? {
        for s in sets {
            if let it = s.items.first(where: { $0.id == id }) { return it }
        }
        return nil
    }

    static func setOfItem(_ id: String) -> AdhkarSet? {
        sets.first { $0.items.contains { $0.id == id } }
    }
}
