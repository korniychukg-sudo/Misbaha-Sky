import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let prompt: String
    let arabicHint: String?
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

struct SeededRandom: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 0x9E3779B97F4A7C15 : seed }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}

enum QuizEngine {
    static func makeRound(count: Int = 10, seed: UInt64 = UInt64(Date().timeIntervalSince1970)) -> [QuizQuestion] {
        var rng = SeededRandom(seed: seed)
        var questions: [QuizQuestion] = []
        var usedNameIds: Set<Int> = []
        var usedTermIds: Set<String> = []

        let kinds = (0..<count).map { i in i % 4 }
        for kind in kinds.shuffled(using: &rng) {
            switch kind {
            case 0:
                if let q = nameMeaningQuestion(&rng, used: &usedNameIds) { questions.append(q) }
            case 1:
                if let q = meaningNameQuestion(&rng, used: &usedNameIds) { questions.append(q) }
            case 2:
                if let q = glossaryQuestion(&rng, used: &usedTermIds) { questions.append(q) }
            default:
                if let q = countQuestion(&rng) { questions.append(q) }
            }
        }
        while questions.count < count {
            if let q = nameMeaningQuestion(&rng, used: &usedNameIds) { questions.append(q) } else { break }
        }
        return Array(questions.prefix(count))
    }

    private static func nameMeaningQuestion(_ rng: inout SeededRandom, used: inout Set<Int>) -> QuizQuestion? {
        let pool = MSCatalog.names.filter { !used.contains($0.id) }
        guard let pick = pool.shuffled(using: &rng).first else { return nil }
        used.insert(pick.id)
        var wrong = MSCatalog.names.filter { $0.id != pick.id }.shuffled(using: &rng).prefix(3).map { $0.meaning }
        wrong = Array(Set(wrong)).filter { $0 != pick.meaning }
        guard wrong.count >= 3 else { return nil }
        var options = Array(wrong.prefix(3)) + [pick.meaning]
        options.shuffle(using: &rng)
        guard let correct = options.firstIndex(of: pick.meaning) else { return nil }
        return QuizQuestion(
            prompt: "What does \(pick.translit) mean?",
            arabicHint: pick.arabic,
            options: options,
            correctIndex: correct,
            explanation: "\(pick.translit) — \(pick.meaning). \(pick.reflection)"
        )
    }

    private static func meaningNameQuestion(_ rng: inout SeededRandom, used: inout Set<Int>) -> QuizQuestion? {
        let pool = MSCatalog.names.filter { !used.contains($0.id) }
        guard let pick = pool.shuffled(using: &rng).first else { return nil }
        used.insert(pick.id)
        var wrong = MSCatalog.names.filter { $0.id != pick.id }.shuffled(using: &rng).prefix(3).map { $0.translit }
        wrong = Array(Set(wrong)).filter { $0 != pick.translit }
        guard wrong.count >= 3 else { return nil }
        var options = Array(wrong.prefix(3)) + [pick.translit]
        options.shuffle(using: &rng)
        guard let correct = options.firstIndex(of: pick.translit) else { return nil }
        return QuizQuestion(
            prompt: "Which name means \"\(pick.meaning)\"?",
            arabicHint: nil,
            options: options,
            correctIndex: correct,
            explanation: "\(pick.translit) means \(pick.meaning)."
        )
    }

    private static func glossaryQuestion(_ rng: inout SeededRandom, used: inout Set<String>) -> QuizQuestion? {
        let pool = MSCatalog.glossary.filter { !used.contains($0.id) }
        guard let pick = pool.shuffled(using: &rng).first else { return nil }
        used.insert(pick.id)
        let wrong = MSCatalog.glossary.filter { $0.id != pick.id }.shuffled(using: &rng).prefix(3).map { $0.term }
        guard wrong.count >= 3 else { return nil }
        var options = Array(wrong) + [pick.term]
        options.shuffle(using: &rng)
        guard let correct = options.firstIndex(of: pick.term) else { return nil }
        return QuizQuestion(
            prompt: "Which term fits: \(pick.definition)",
            arabicHint: nil,
            options: options,
            correctIndex: correct,
            explanation: "\(pick.term): \(pick.definition)"
        )
    }

    private static func countQuestion(_ rng: inout SeededRandom) -> QuizQuestion? {
        let counted = MSCatalog.sets.flatMap { set in
            set.items.filter { $0.count >= 3 }.map { (set, $0) }
        }
        guard let (set, item) = counted.shuffled(using: &rng).first else { return nil }
        let correctAnswer = "\(item.count)"
        var pool = ["3", "7", "10", "33", "34", "100"].filter { $0 != correctAnswer }
        pool.shuffle(using: &rng)
        var options = Array(pool.prefix(3)) + [correctAnswer]
        options.shuffle(using: &rng)
        guard let correct = options.firstIndex(of: correctAnswer) else { return nil }
        return QuizQuestion(
            prompt: "How many times is \(item.translit) counted in \(set.title)?",
            arabicHint: item.arabic,
            options: options,
            correctIndex: correct,
            explanation: "\(item.translit) is counted \(item.count) times in \(set.title)."
        )
    }
}
