import Foundation

enum LoreData {
    private static let guidesA: [BSGuide] = [
        BSGuide(
            id: "g-dhikr",
            title: "What Dhikr Is",
            subtitle: "The practice of remembrance",
            artName: "guide-dhikr",
            minutes: 4,
            sections: [
                BSGuideSection(
                    heading: "The word itself",
                    body: "Dhikr means remembrance. In practice it is the repetition of short phrases that praise, thank or call upon Allah — spoken aloud, whispered, or moved silently on the tongue. It is the most portable act of worship in Islam: it needs no ablution, no direction, no particular place, and no minimum length."
                ),
                BSGuideSection(
                    heading: "Why repetition",
                    body: "A phrase said once is a thought; said thirty-three times it becomes a state. Repetition is not for Allah's benefit but for the heart of the one speaking — the words wear a groove, and the mind that wanders during the tenth repetition often arrives fully by the twentieth. The counting is a fence around attention."
                ),
                BSGuideSection(
                    heading: "The core phrases",
                    body: "Four short formulas carry most of the practice. Subhan Allah — glory be to Allah — sets Him above every flaw. Alhamdu lillah — praise belongs to Allah — answers every circumstance with gratitude. La ilaha illallah — there is no god but Allah — is the sentence on which the whole religion stands. Allahu akbar — Allah is greater — greater, always, than whatever is currently filling the mind."
                ),
                BSGuideSection(
                    heading: "Light words, heavy weight",
                    body: "The Prophet described two phrases as light on the tongue and heavy in the scales: Subhan Allahi wa bihamdih, Subhan Allahil-'azim. That contrast is the whole invitation of dhikr — the cost is seconds, and the value is placed by Allah, not by the clock."
                )
            ],
            facts: [
                "Dhikr requires no ablution, though many prefer it.",
                "It may be said walking, working, lying down or riding.",
                "The tongue, the heart and the fingers can each carry the count."
            ]
        ),
        BSGuide(
            id: "g-misbaha",
            title: "The Misbaha and the Hand",
            subtitle: "How Muslims count remembrance",
            artName: "guide-misbaha",
            minutes: 4,
            sections: [
                BSGuideSection(
                    heading: "A strand of thirty-three",
                    body: "The misbaha — also called subha or tasbih — is a strand of prayer beads, most often thirty-three or ninety-nine of them, with a longer marker bead or a divider after each thirty-three. The thumb draws one bead over the finger with every phrase, so the tongue is free to speak and the heart is free to mean it, while the hand keeps the arithmetic."
                ),
                BSGuideSection(
                    heading: "Counting on the fingers",
                    body: "Before beads, there were finger joints. The Prophet counted dhikr on the fingers of his right hand and told his companions the fingers themselves will be asked and will speak. Each finger has three joints; one hand can hold fifteen counts, both hands thirty. Beads did not replace this — they simply extended it, and many still prefer the hand."
                ),
                BSGuideSection(
                    heading: "Materials and craft",
                    body: "Misbahas have been strung from date pits, olive wood, bone, amber, coral, glass and semi-precious stone. What matters is none of these. A misbaha of knotted wool counts exactly as well as one of carved amber — the bead is a bookmark for the tongue, not a jewel for the wrist."
                ),
                BSGuideSection(
                    heading: "This app's strand",
                    body: "The strand on the Beads screen behaves like the real thing: pull it toward you and a bead crosses the thumb with a small tick you can feel. Every thirty-third bead announces itself, the way a divider does between the fingers. The phone is the least of it — the words are the practice."
                )
            ],
            facts: [
                "Misbaha, subha and tasbih name the same object in different lands.",
                "Common strand lengths are 33 and 99 beads plus dividers.",
                "Counting on the right hand's finger joints is the oldest method."
            ]
        )
    ]

    private static let guidesB: [BSGuide] = [
        BSGuide(
            id: "g-rhythm",
            title: "Morning and Evening",
            subtitle: "The two anchors of the day",
            artName: "guide-rhythm",
            minutes: 5,
            sections: [
                BSGuideSection(
                    heading: "Two fixed appointments",
                    body: "Islam brackets the day with remembrance. The morning adhkar are said between the dawn prayer and sunrise; the evening adhkar in the late afternoon, before or around sunset. Between those two anchors the day can hold anything — the anchors themselves stay put."
                ),
                BSGuideSection(
                    heading: "What the words do",
                    body: "Read the morning set closely and a pattern appears: it is a checklist of dependencies. Who owns the coming hours. Whose name shields against harm. Who is sufficient when the inbox is not. The words are less a ritual than a reorientation performed before the world gets its word in."
                ),
                BSGuideSection(
                    heading: "If the hour is missed",
                    body: "The scholars of dhikr were practical people. A morning remembrance said late is better than one skipped; an evening set caught at night still counts its worth. The appointments are meant as a mercy and a rhythm, not a trap. Begin where you are, at the hour you noticed."
                ),
                BSGuideSection(
                    heading: "Starting small",
                    body: "The full sets take some minutes. A beginner does better with three items said daily than twelve said twice and abandoned. Choose the shortest phrases first — the hundred of Subhan Allahi wa bihamdih flows quickly on the beads — and let the set grow at the pace of the habit."
                )
            ],
            facts: [
                "Morning adhkar: after fajr, before the sun climbs.",
                "Evening adhkar: after asr, into the early night.",
                "Consistency in a small amount outweighs an occasional feast."
            ]
        ),
        BSGuide(
            id: "g-prayer",
            title: "After the Prayer",
            subtitle: "The tasbih of the hundred",
            artName: "guide-prayer",
            minutes: 4,
            sections: [
                BSGuideSection(
                    heading: "The sequence",
                    body: "When the prayer closes, the tongue keeps going: Astaghfirullah three times, then Subhan Allah thirty-three, Alhamdu lillah thirty-three, Allahu akbar thirty-four — a hundred in all. Some complete the hundred instead with a single la ilaha illallahu wahdahu la sharika lah; both forms are reported and both are practiced."
                ),
                BSGuideSection(
                    heading: "Why it sits here",
                    body: "The prayer is the appointment; the tasbih is the lingering afterwards. It keeps the worshipper seated a minute longer in the state the prayer built, and it forgives the prayer its human lapses — the wandering thought, the hurried bow. What the salah creased, the tasbih smooths."
                ),
                BSGuideSection(
                    heading: "Five strands a day",
                    body: "Said after each of the five prayers, the sequence puts five hundred counted phrases into an ordinary day without borrowing a single extra minute from it. This is the quiet arithmetic of the practice: it compounds. The Beads tab keeps the running total; the numbers grow faster than expected."
                )
            ],
            facts: [
                "The after-prayer tasbih totals one hundred phrases.",
                "Thirty-four takbirs — or a closing tahlil — complete the count.",
                "Five prayers make five hundred counted phrases a day."
            ]
        )
    ]

    static let guides: [BSGuide] = guidesA + guidesB + guidesC + guidesD
}
