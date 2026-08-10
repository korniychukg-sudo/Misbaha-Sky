import Foundation
import SwiftUI

struct SessionRecord: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var date: Date = Date()
    var itemId: String = ""
    var title: String = ""
    var count: Int = 0
    var setId: String? = nil
}

struct BSState: Codable {
    var totalBeads: Int = 0
    var daily: [String: Int] = [:]
    var perItem: [String: Int] = [:]
    var sessions: [SessionRecord] = []
    var setCompletions: [String: Int] = [:]
    var setDayLog: [String: [String]] = [:]
    var prayerByDay: [String: Int] = [:]
    var namesRead: Set<Int> = []
    var favNames: Set<Int> = []
    var guidesRead: Set<String> = []
    var quizBest: Int = 0
    var quizRounds: Int = 0
    var stylesTried: Set<String> = []
    var beadStyleRaw: String = BeadStyle.jade.rawValue
    var hapticsOn: Bool = true
    var showTranslit: Bool = true
    var onboarded: Bool = false
    var earned: Set<String> = []
    var roundsCompleted: Int = 0

    init() {}

    enum CodingKeys: String, CodingKey {
        case totalBeads, daily, perItem, sessions, setCompletions, setDayLog, prayerByDay
        case namesRead, favNames, guidesRead, quizBest, quizRounds, stylesTried
        case beadStyleRaw, hapticsOn, showTranslit, onboarded, earned, roundsCompleted
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        totalBeads = (try? c.decodeIfPresent(Int.self, forKey: .totalBeads)) ?? 0
        daily = (try? c.decodeIfPresent([String: Int].self, forKey: .daily)) ?? [:]
        perItem = (try? c.decodeIfPresent([String: Int].self, forKey: .perItem)) ?? [:]
        sessions = (try? c.decodeIfPresent([SessionRecord].self, forKey: .sessions)) ?? []
        setCompletions = (try? c.decodeIfPresent([String: Int].self, forKey: .setCompletions)) ?? [:]
        setDayLog = (try? c.decodeIfPresent([String: [String]].self, forKey: .setDayLog)) ?? [:]
        prayerByDay = (try? c.decodeIfPresent([String: Int].self, forKey: .prayerByDay)) ?? [:]
        namesRead = (try? c.decodeIfPresent(Set<Int>.self, forKey: .namesRead)) ?? []
        favNames = (try? c.decodeIfPresent(Set<Int>.self, forKey: .favNames)) ?? []
        guidesRead = (try? c.decodeIfPresent(Set<String>.self, forKey: .guidesRead)) ?? []
        quizBest = (try? c.decodeIfPresent(Int.self, forKey: .quizBest)) ?? 0
        quizRounds = (try? c.decodeIfPresent(Int.self, forKey: .quizRounds)) ?? 0
        stylesTried = (try? c.decodeIfPresent(Set<String>.self, forKey: .stylesTried)) ?? []
        beadStyleRaw = (try? c.decodeIfPresent(String.self, forKey: .beadStyleRaw)) ?? BeadStyle.jade.rawValue
        hapticsOn = (try? c.decodeIfPresent(Bool.self, forKey: .hapticsOn)) ?? true
        showTranslit = (try? c.decodeIfPresent(Bool.self, forKey: .showTranslit)) ?? true
        onboarded = (try? c.decodeIfPresent(Bool.self, forKey: .onboarded)) ?? false
        earned = (try? c.decodeIfPresent(Set<String>.self, forKey: .earned)) ?? []
        roundsCompleted = (try? c.decodeIfPresent(Int.self, forKey: .roundsCompleted)) ?? 0
    }
}

final class BSStore: ObservableObject {
    @Published private(set) var state: BSState
    @Published var newBadge: BSBadge? = nil
    @Published var pendingLaunch: RoundSpec? = nil
    @Published var activeTab: Int = 0

    private static let key = "beadsteps.state.v1"

    static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.key),
           let decoded = try? JSONDecoder().decode(BSState.self, from: data) {
            state = decoded
        } else {
            state = BSState()
        }
        BSHaptics.enabled = state.hapticsOn
    }

    private func save() {
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: Self.key)
        }
    }

    static func dayKey(_ date: Date = Date()) -> String {
        dayFormatter.string(from: date)
    }

    var beadStyle: BeadStyle {
        BeadStyle(rawValue: state.beadStyleRaw) ?? .jade
    }

    var todayCount: Int {
        state.daily[Self.dayKey()] ?? 0
    }

    var streak: Int {
        var run = 0
        var day = Date()
        let cal = Calendar.current
        if state.daily[Self.dayKey(day)] == nil {
            guard let prev = cal.date(byAdding: .day, value: -1, to: day) else { return 0 }
            day = prev
        }
        while state.daily[Self.dayKey(day)] != nil {
            run += 1
            guard let prev = cal.date(byAdding: .day, value: -1, to: day) else { break }
            day = prev
        }
        return run
    }

    var dailyName: DivineName {
        let cal = Calendar.current
        let ord = cal.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let year = cal.component(.year, from: Date())
        let idx = (ord + year * 17) % BSCatalog.names.count
        return BSCatalog.names[idx]
    }

    func suggestedSet() -> AdhkarSet {
        let hour = Calendar.current.component(.hour, from: Date())
        let id: String
        switch hour {
        case 4..<7: id = "waking"
        case 7..<11: id = "morning"
        case 11..<15: id = "prayer"
        case 15..<20: id = "evening"
        case 20..<24: id = "sleep"
        default: id = "sleep"
        }
        return BSCatalog.set(id) ?? BSCatalog.sets[0]
    }

    func logRound(itemId: String, title: String, count: Int, setId: String?) {
        guard count > 0 else { return }
        let day = Self.dayKey()
        state.totalBeads += count
        state.daily[day, default: 0] += count
        state.perItem[itemId, default: 0] += count
        state.roundsCompleted += 1
        var rec = SessionRecord()
        rec.itemId = itemId
        rec.title = title
        rec.count = count
        rec.setId = setId
        state.sessions.insert(rec, at: 0)
        if state.sessions.count > 300 {
            state.sessions.removeLast(state.sessions.count - 300)
        }
        evaluateBadges()
        save()
    }

    func completeSet(_ setId: String) {
        let day = Self.dayKey()
        state.setCompletions[setId, default: 0] += 1
        var days = state.setDayLog[setId] ?? []
        if !days.contains(day) { days.append(day) }
        if days.count > 60 { days.removeFirst(days.count - 60) }
        state.setDayLog[setId] = days
        if setId == "prayer" {
            state.prayerByDay[day, default: 0] += 1
        }
        evaluateBadges()
        save()
    }

    func markNameRead(_ id: Int) {
        if !state.namesRead.contains(id) {
            state.namesRead.insert(id)
            evaluateBadges()
            save()
        }
    }

    func toggleFavName(_ id: Int) {
        if state.favNames.contains(id) {
            state.favNames.remove(id)
        } else {
            state.favNames.insert(id)
        }
        save()
    }

    func markGuideRead(_ id: String) {
        if !state.guidesRead.contains(id) {
            state.guidesRead.insert(id)
            evaluateBadges()
            save()
        }
    }

    func quizFinished(score: Int, total: Int) {
        state.quizRounds += 1
        if score > state.quizBest { state.quizBest = score }
        if score == total { award("b-quiz") }
        evaluateBadges()
        save()
    }

    func setBeadStyle(_ style: BeadStyle) {
        state.beadStyleRaw = style.rawValue
        state.stylesTried.insert(style.rawValue)
        evaluateBadges()
        save()
    }

    func setHaptics(_ on: Bool) {
        state.hapticsOn = on
        BSHaptics.enabled = on
        save()
    }

    func setShowTranslit(_ on: Bool) {
        state.showTranslit = on
        save()
    }

    func finishOnboarding() {
        state.onboarded = true
        state.stylesTried.insert(state.beadStyleRaw)
        save()
    }

    func resetAll() {
        state = BSState()
        state.onboarded = true
        save()
    }

    var earnedBadges: [BSBadge] {
        BSCatalog.badges.filter { state.earned.contains($0.id) }
    }

    private func award(_ id: String) {
        guard !state.earned.contains(id) else { return }
        state.earned.insert(id)
        if let badge = BSCatalog.badges.first(where: { $0.id == id }) {
            newBadge = badge
        }
    }

    private func evaluateBadges() {
        let day = Self.dayKey()
        if state.roundsCompleted >= 1 { award("b-first") }
        if (state.daily[day] ?? 0) >= 100 { award("b-hundred") }
        if (state.daily[day] ?? 0) >= 500 { award("b-fivehundred") }
        if state.totalBeads >= 1000 { award("b-thousand") }
        if state.totalBeads >= 10000 { award("b-tenthousand") }
        if streak >= 7 { award("b-week") }
        if streak >= 30 { award("b-month") }
        if BSCatalog.sets.allSatisfy({ (state.setCompletions[$0.id] ?? 0) > 0 }) { award("b-allsets") }
        if let m = state.setDayLog["morning"], let e = state.setDayLog["evening"],
           !Set(m).intersection(Set(e)).isEmpty { award("b-morningevening") }
        if (state.prayerByDay[day] ?? 0) >= 5 { award("b-prayerweek") }
        if state.namesRead.count >= 25 { award("b-names25") }
        if state.namesRead.count >= 99 { award("b-names99") }
        if BSCatalog.guides.allSatisfy({ state.guidesRead.contains($0.id) }) { award("b-guides") }
        if (state.setCompletions["sleep"] ?? 0) > 0 { award("b-night") }
        if (state.setCompletions["road"] ?? 0) > 0 { award("b-traveler") }
        if state.stylesTried.count >= BeadStyle.allCases.count { award("b-styles") }
        if state.roundsCompleted >= 100 { award("b-hundredsessions") }
    }

    func heatValue(for date: Date) -> Int {
        state.daily[Self.dayKey(date)] ?? 0
    }

}
