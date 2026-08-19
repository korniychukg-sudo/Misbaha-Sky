import SwiftUI

struct QuizView: View {
    @EnvironmentObject var store: MSStore
    @State private var questions: [QuizQuestion] = []
    @State private var index = 0
    @State private var picked: Int? = nil
    @State private var score = 0
    @State private var finished = false

    var body: some View {
        Group {
            if finished {
                resultView
            } else if questions.isEmpty {
                startView
            } else {
                questionView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(MSTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Quiz")
                    .font(MSTheme.serif(18))
                    .foregroundColor(MSTheme.ink)
            }
        }
    }

    private var startView: some View {
        VStack(spacing: 18) {
            GeometricRosette(tint: MSTheme.terra, petals: 10)
                .frame(width: 110, height: 110)
            Text("Ten questions")
                .font(MSTheme.serif(24))
                .foregroundColor(MSTheme.ink)
            Text("Names and their meanings, terms of the practice, and the counts of the sets. Fresh questions every round, with an explanation for every answer.")
                .font(MSTheme.text(14))
                .foregroundColor(MSTheme.inkSoft)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            if store.state.quizRounds > 0 {
                MSChip(text: "Personal best: \(store.state.quizBest) of 10", tint: MSTheme.terra)
            }
            Button {
                startRound()
            } label: {
                Text("Begin")
                    .font(MSTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(MSTheme.emerald))
            }
            .buttonStyle(ScalePressStyle())
        }
        .padding(20)
    }

    private var questionView: some View {
        let q = questions[index]
        return ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    MSChip(text: "Question \(index + 1) of \(questions.count)", tint: MSTheme.emerald)
                    Spacer()
                    MSChip(text: "\(score) correct", tint: MSTheme.gold)
                }
                if let hint = q.arabicHint {
                    Text(hint)
                        .font(MSTheme.arabic(26))
                        .foregroundColor(MSTheme.emerald)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 4)
                }
                Text(q.prompt)
                    .font(MSTheme.serif(19))
                    .foregroundColor(MSTheme.ink)
                    .lineSpacing(3)
                VStack(spacing: 9) {
                    ForEach(Array(q.options.enumerated()), id: \.offset) { i, option in
                        Button {
                            pick(i)
                        } label: {
                            HStack {
                                Text(option)
                                    .font(MSTheme.text(14, .medium))
                                    .foregroundColor(optionTextColor(i, q: q))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if picked != nil && i == q.correctIndex {
                                    CheckIcon()
                                }
                            }
                            .padding(13)
                            .background(
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(optionFill(i, q: q))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                                            .strokeBorder(optionBorder(i, q: q), lineWidth: 1.2)
                                    )
                            )
                        }
                        .buttonStyle(ScalePressStyle())
                        .disabled(picked != nil)
                    }
                }
                if picked != nil {
                    Text(q.explanation)
                        .font(MSTheme.text(13))
                        .foregroundColor(MSTheme.inkSoft)
                        .lineSpacing(4)
                        .msCard(padding: 13)
                    Button {
                        next()
                    } label: {
                        Text(index + 1 < questions.count ? "Next question" : "See result")
                            .font(MSTheme.text(15, .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(MSTheme.emerald))
                    }
                    .buttonStyle(ScalePressStyle())
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
    }

    private var resultView: some View {
        VStack(spacing: 16) {
            ZStack {
                ProgressRing(progress: Double(score) / Double(max(1, questions.count)), lineWidth: 8, tint: MSTheme.gold)
                    .frame(width: 120, height: 120)
                VStack(spacing: 0) {
                    Text("\(score)")
                        .font(MSTheme.round(38))
                        .foregroundColor(MSTheme.ink)
                    Text("of \(questions.count)")
                        .font(MSTheme.text(12))
                        .foregroundColor(MSTheme.inkFaint)
                }
            }
            Text(resultLine)
                .font(MSTheme.serif(22))
                .foregroundColor(MSTheme.ink)
            if score == questions.count {
                Text("A perfect round.")
                    .font(MSTheme.text(14))
                    .foregroundColor(MSTheme.gold)
            }
            Button {
                startRound()
            } label: {
                Text("Another round")
                    .font(MSTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(MSTheme.emerald))
            }
            .buttonStyle(ScalePressStyle())
        }
        .padding(24)
    }

    private var resultLine: String {
        switch score {
        case 0...3: return "The beads are patient"
        case 4...6: return "A fair round"
        case 7...9: return "Well studied"
        default: return "Sound knowledge"
        }
    }

    private func optionFill(_ i: Int, q: QuizQuestion) -> Color {
        guard let p = picked else { return MSTheme.card }
        if i == q.correctIndex { return MSTheme.emeraldSoft }
        if i == p { return MSTheme.terraSoft }
        return MSTheme.card
    }

    private func optionBorder(_ i: Int, q: QuizQuestion) -> Color {
        guard let p = picked else { return MSTheme.line }
        if i == q.correctIndex { return MSTheme.emerald.opacity(0.5) }
        if i == p { return MSTheme.terra.opacity(0.5) }
        return MSTheme.line
    }

    private func optionTextColor(_ i: Int, q: QuizQuestion) -> Color {
        guard let p = picked else { return MSTheme.ink }
        if i == q.correctIndex { return MSTheme.emeraldDeep }
        if i == p { return MSTheme.terra }
        return MSTheme.inkFaint
    }

    private func pick(_ i: Int) {
        guard picked == nil else { return }
        picked = i
        if i == questions[index].correctIndex {
            score += 1
            MSHaptics.success()
        } else {
            MSHaptics.warm()
        }
    }

    private func next() {
        if index + 1 < questions.count {
            index += 1
            picked = nil
        } else {
            store.quizFinished(score: score, total: questions.count)
            finished = true
        }
    }

    private func startRound() {
        questions = QuizEngine.makeRound()
        index = 0
        picked = nil
        score = 0
        finished = false
    }
}
