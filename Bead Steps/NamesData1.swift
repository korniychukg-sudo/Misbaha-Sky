import Foundation

enum NamesData {
    private static let block1: [DivineName] = [
        DivineName(id: 1, arabic: "الرَّحْمَنُ", translit: "Ar-Rahman", meaning: "The Most Merciful", reflection: "Mercy wide enough to reach everything that breathes."),
        DivineName(id: 2, arabic: "الرَّحِيمُ", translit: "Ar-Rahim", meaning: "The Especially Merciful", reflection: "Mercy that bends close, to one person at a time."),
        DivineName(id: 3, arabic: "الْمَلِكُ", translit: "Al-Malik", meaning: "The King", reflection: "Every other ownership is borrowed and brief."),
        DivineName(id: 4, arabic: "الْقُدُّوسُ", translit: "Al-Quddus", meaning: "The Most Holy", reflection: "Free of every flaw the mind could name."),
        DivineName(id: 5, arabic: "السَّلَامُ", translit: "As-Salam", meaning: "The Source of Peace", reflection: "Peace is not found; it is given, from here."),
        DivineName(id: 6, arabic: "الْمُؤْمِنُ", translit: "Al-Mu'min", meaning: "The Giver of Security", reflection: "The One whose promise makes fear unnecessary."),
        DivineName(id: 7, arabic: "الْمُهَيْمِنُ", translit: "Al-Muhaymin", meaning: "The Guardian", reflection: "Watching over all things without a moment of neglect."),
        DivineName(id: 8, arabic: "الْعَزِيزُ", translit: "Al-'Aziz", meaning: "The Almighty", reflection: "Strength that nothing can bargain with."),
        DivineName(id: 9, arabic: "الْجَبَّارُ", translit: "Al-Jabbar", meaning: "The Compeller", reflection: "The One who mends what is broken and none can resist."),
        DivineName(id: 10, arabic: "الْمُتَكَبِّرُ", translit: "Al-Mutakabbir", meaning: "The Supreme in Greatness", reflection: "Greatness belongs to Him; in people it is a costume."),
        DivineName(id: 11, arabic: "الْخَالِقُ", translit: "Al-Khaliq", meaning: "The Creator", reflection: "Every made thing carries the mark of a Maker.")
    ]

    private static let block2: [DivineName] = [
        DivineName(id: 12, arabic: "الْبَارِئُ", translit: "Al-Bari'", meaning: "The Originator", reflection: "Bringing into being without a model to copy."),
        DivineName(id: 13, arabic: "الْمُصَوِّرُ", translit: "Al-Musawwir", meaning: "The Fashioner", reflection: "The One who gave every face its own face."),
        DivineName(id: 14, arabic: "الْغَفَّارُ", translit: "Al-Ghaffar", meaning: "The Ever-Forgiving", reflection: "Forgiving not once, but as a habit of His."),
        DivineName(id: 15, arabic: "الْقَهَّارُ", translit: "Al-Qahhar", meaning: "The Subduer", reflection: "Every proud thing eventually sits down."),
        DivineName(id: 16, arabic: "الْوَهَّابُ", translit: "Al-Wahhab", meaning: "The Bestower", reflection: "Giving freely, with no ledger kept against you."),
        DivineName(id: 17, arabic: "الرَّزَّاقُ", translit: "Ar-Razzaq", meaning: "The Provider", reflection: "Provision arrives by routes no planner drew."),
        DivineName(id: 18, arabic: "الْفَتَّاحُ", translit: "Al-Fattah", meaning: "The Opener", reflection: "Doors open at their hour, not at our knocking."),
        DivineName(id: 19, arabic: "الْعَلِيمُ", translit: "Al-'Alim", meaning: "The All-Knowing", reflection: "Nothing said quietly was said unheard."),
        DivineName(id: 20, arabic: "الْقَابِضُ", translit: "Al-Qabid", meaning: "The Withholder", reflection: "What is held back is measured, not forgotten."),
        DivineName(id: 21, arabic: "الْبَاسِطُ", translit: "Al-Basit", meaning: "The Expander", reflection: "The same hand that narrows a thing can widen it."),
        DivineName(id: 22, arabic: "الْخَافِضُ", translit: "Al-Khafid", meaning: "The Abaser", reflection: "No height is safe that was built on wrong.")
    ]

    private static let block3: [DivineName] = [
        DivineName(id: 23, arabic: "الرَّافِعُ", translit: "Ar-Rafi'", meaning: "The Exalter", reflection: "He raises the humble the world overlooked."),
        DivineName(id: 24, arabic: "الْمُعِزُّ", translit: "Al-Mu'izz", meaning: "The Giver of Honour", reflection: "Honour given by Him needs no audience."),
        DivineName(id: 25, arabic: "الْمُذِلُّ", translit: "Al-Mudhill", meaning: "The Humbler", reflection: "Disgrace reaches only where He permits it."),
        DivineName(id: 26, arabic: "السَّمِيعُ", translit: "As-Sami'", meaning: "The All-Hearing", reflection: "The whisper and the shout arrive the same."),
        DivineName(id: 27, arabic: "الْبَصِيرُ", translit: "Al-Basir", meaning: "The All-Seeing", reflection: "Seen entirely, and still shown mercy."),
        DivineName(id: 28, arabic: "الْحَكَمُ", translit: "Al-Hakam", meaning: "The Judge", reflection: "The verdict that no appeal can overturn — and none will need to."),
        DivineName(id: 29, arabic: "الْعَدْلُ", translit: "Al-'Adl", meaning: "The Utterly Just", reflection: "Not an atom's weight will be misplaced."),
        DivineName(id: 30, arabic: "اللَّطِيفُ", translit: "Al-Latif", meaning: "The Subtle and Kind", reflection: "Kindness so fine it is noticed only afterwards."),
        DivineName(id: 31, arabic: "الْخَبِيرُ", translit: "Al-Khabir", meaning: "The All-Aware", reflection: "Aware of the inside of things, not just their surface."),
        DivineName(id: 32, arabic: "الْحَلِيمُ", translit: "Al-Halim", meaning: "The Forbearing", reflection: "He is not hasty with those who are."),
        DivineName(id: 33, arabic: "الْعَظِيمُ", translit: "Al-'Azim", meaning: "The Magnificent", reflection: "Too great for the mind, near enough for the heart.")
    ]

    static let part1: [DivineName] = block1 + block2 + block3
}
