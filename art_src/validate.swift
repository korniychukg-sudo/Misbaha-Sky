import Foundation

@main
struct Validate {
    static func main() {
        var failures = 0
        func check(_ cond: Bool, _ label: String) {
            if !cond {
                failures += 1
                print("FAIL: \(label)")
            }
        }

        let sets = MSCatalog.sets
        check(sets.count == 8, "8 sets")
        var itemIds = Set<String>()
        for s in sets {
            check(!s.items.isEmpty, "set \(s.id) has items")
            check(!s.intro.isEmpty, "set \(s.id) intro")
            for it in s.items {
                check(it.count > 0, "count>0 \(it.id)")
                check(!it.arabic.isEmpty, "arabic \(it.id)")
                check(!it.translit.isEmpty, "translit \(it.id)")
                check(!it.english.isEmpty, "english \(it.id)")
                check(!it.source.isEmpty, "source \(it.id)")
                check(itemIds.insert(it.id).inserted, "unique id \(it.id)")
            }
        }
        let prayer = sets.first { $0.id == "prayer" }!
        let tasbihSum = prayer.items.filter { ["prayer-tasbih", "prayer-tahmid", "prayer-takbir"].contains($0.id) }.reduce(0) { $0 + $1.count }
        check(tasbihSum == 100, "prayer tasbih sums to 100")

        let names = MSCatalog.names
        check(names.count == 99, "99 names")
        check(Set(names.map { $0.id }).count == 99, "unique name ids")
        check(names.enumerated().allSatisfy { $0.offset + 1 == $0.element.id }, "names ordered 1-99")
        check(Set(names.map { $0.translit }).count >= 97, "distinct transliterations")
        for n in names {
            check(!n.arabic.isEmpty && !n.meaning.isEmpty && !n.reflection.isEmpty, "name fields \(n.id)")
        }

        check(MSCatalog.guides.count == 8, "8 guides")
        for g in MSCatalog.guides {
            check(g.sections.count >= 3, "guide sections \(g.id)")
            check(!g.facts.isEmpty, "guide facts \(g.id)")
        }
        check(Set(MSCatalog.glossary.map { $0.id }).count == MSCatalog.glossary.count, "glossary unique")
        check(MSCatalog.glossary.count >= 28, "glossary >= 28")
        check(Set(MSCatalog.badges.map { $0.id }).count == MSCatalog.badges.count, "badges unique")
        check(MSCatalog.badges.count == 18, "18 badges")

        for seed in 1...400 {
            let round = QuizEngine.makeRound(count: 10, seed: UInt64(seed))
            check(round.count == 10, "round \(seed) has 10")
            for q in round {
                check(q.options.count == 4, "4 options seed \(seed)")
                check(Set(q.options).count == 4, "distinct options seed \(seed): \(q.options)")
                check(q.correctIndex >= 0 && q.correctIndex < 4, "correct index seed \(seed)")
                check(!q.prompt.isEmpty && !q.explanation.isEmpty, "q text seed \(seed)")
            }
        }

        let art = ["set-prayer", "set-morning", "set-evening", "set-sleep", "set-waking", "set-door", "set-road", "set-heart",
                   "guide-dhikr", "guide-misbaha", "guide-rhythm", "guide-prayer", "guide-names", "guide-presence", "guide-gratitude", "guide-day",
                   "names-hero", "onboard-1", "onboard-2", "onboard-3", "onboard-4"]
        let artDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "../Misbaha Sky/Art"
        for a in art {
            check(FileManager.default.fileExists(atPath: "\(artDir)/\(a).jpg"), "art \(a)")
        }
        let usedArt = sets.map { $0.artName } + MSCatalog.guides.map { $0.artName }
        for a in usedArt {
            check(art.contains(a), "art referenced exists: \(a)")
        }

        if failures == 0 {
            print("ALL OK: \(sets.count) sets, \(itemIds.count) dhikr items, 99 names, \(MSCatalog.guides.count) guides, \(MSCatalog.glossary.count) terms, \(MSCatalog.badges.count) badges, 400 quiz rounds validated")
        } else {
            print("\(failures) FAILURES")
            exit(1)
        }
    }
}
