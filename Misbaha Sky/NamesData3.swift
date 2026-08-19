import Foundation

extension NamesData {
    private static let block7: [DivineName] = [
        DivineName(id: 67, arabic: "الْأَحَدُ", translit: "Al-Ahad", meaning: "The Unique", reflection: "Not one of a kind — beyond kinds altogether."),
        DivineName(id: 68, arabic: "الصَّمَدُ", translit: "As-Samad", meaning: "The Eternal Refuge", reflection: "Everything needs; He is needed and needs nothing."),
        DivineName(id: 69, arabic: "الْقَادِرُ", translit: "Al-Qadir", meaning: "The All-Capable", reflection: "Able — without effort, delay or doubt."),
        DivineName(id: 70, arabic: "الْمُقْتَدِرُ", translit: "Al-Muqtadir", meaning: "The Omnipotent", reflection: "Power over the outcome and the odds alike."),
        DivineName(id: 71, arabic: "الْمُقَدِّمُ", translit: "Al-Muqaddim", meaning: "The One Who Brings Forward", reflection: "Some arrive early because He sent them early."),
        DivineName(id: 72, arabic: "الْمُؤَخِّرُ", translit: "Al-Mu'akhkhir", meaning: "The One Who Delays", reflection: "The delay was the mercy, seen later."),
        DivineName(id: 73, arabic: "الْأَوَّلُ", translit: "Al-Awwal", meaning: "The First", reflection: "Before every beginning, unbegun."),
        DivineName(id: 74, arabic: "الْآخِرُ", translit: "Al-Akhir", meaning: "The Last", reflection: "When everything ends, He remains."),
        DivineName(id: 75, arabic: "الظَّاهِرُ", translit: "Az-Zahir", meaning: "The Manifest", reflection: "Evident in every made thing that points to Him."),
        DivineName(id: 76, arabic: "الْبَاطِنُ", translit: "Al-Batin", meaning: "The Hidden", reflection: "Nearer than the vein, subtler than sight."),
        DivineName(id: 77, arabic: "الْوَالِي", translit: "Al-Wali", meaning: "The Governor", reflection: "The affairs of the world are administered, not adrift.")
    ]

    private static let block8: [DivineName] = [
        DivineName(id: 78, arabic: "الْمُتَعَالِي", translit: "Al-Muta'ali", meaning: "The Supremely Exalted", reflection: "High beyond every rising thought."),
        DivineName(id: 79, arabic: "الْبَرُّ", translit: "Al-Barr", meaning: "The Source of Goodness", reflection: "Kind in ways that were never asked for."),
        DivineName(id: 80, arabic: "التَّوَّابُ", translit: "At-Tawwab", meaning: "The Acceptor of Repentance", reflection: "He turns to the one who turns — every time."),
        DivineName(id: 81, arabic: "الْمُنْتَقِمُ", translit: "Al-Muntaqim", meaning: "The Avenger", reflection: "No wrong outruns Him, however long the road."),
        DivineName(id: 82, arabic: "الْعَفُوُّ", translit: "Al-'Afuww", meaning: "The Pardoner", reflection: "Not only forgiven — erased, as if it had not been."),
        DivineName(id: 83, arabic: "الرَّءُوفُ", translit: "Ar-Ra'uf", meaning: "The Most Tender", reflection: "Gentleness at the moments sternness was expected."),
        DivineName(id: 84, arabic: "مَالِكُ الْمُلْكِ", translit: "Malikul-Mulk", meaning: "Master of the Kingdom", reflection: "Thrones circulate; the Kingdom does not."),
        DivineName(id: 85, arabic: "ذُو الْجَلَالِ وَالْإِكْرَامِ", translit: "Dhul-Jalali wal-Ikram", meaning: "Lord of Majesty and Honour", reflection: "Awe and generosity, joined in one Lord."),
        DivineName(id: 86, arabic: "الْمُقْسِطُ", translit: "Al-Muqsit", meaning: "The Equitable", reflection: "The scales He sets need no correcting."),
        DivineName(id: 87, arabic: "الْجَامِعُ", translit: "Al-Jami'", meaning: "The Gatherer", reflection: "Scattered things — and people — are gathered at His word."),
        DivineName(id: 88, arabic: "الْغَنِيُّ", translit: "Al-Ghani", meaning: "The Self-Sufficient", reflection: "Rich without need — so His giving costs Him nothing.")
    ]

    private static let block9: [DivineName] = [
        DivineName(id: 89, arabic: "الْمُغْنِي", translit: "Al-Mughni", meaning: "The Enricher", reflection: "Wealth of the hand, and the rarer wealth of the heart."),
        DivineName(id: 90, arabic: "الْمَانِعُ", translit: "Al-Mani'", meaning: "The Withholder of Harm", reflection: "Some closed doors were bodyguards."),
        DivineName(id: 91, arabic: "الضَّارُّ", translit: "Ad-Darr", meaning: "The Author of Hardship", reflection: "Even the hard thing arrives with permission."),
        DivineName(id: 92, arabic: "النَّافِعُ", translit: "An-Nafi'", meaning: "The Giver of Benefit", reflection: "All benefit has one source, whatever hand delivers it."),
        DivineName(id: 93, arabic: "النُّورُ", translit: "An-Nur", meaning: "The Light", reflection: "By His light the eye sees light."),
        DivineName(id: 94, arabic: "الْهَادِي", translit: "Al-Hadi", meaning: "The Guide", reflection: "No one finds the way alone; the way is shown."),
        DivineName(id: 95, arabic: "الْبَدِيعُ", translit: "Al-Badi'", meaning: "The Incomparable Originator", reflection: "Creation without precedent, beauty without pattern."),
        DivineName(id: 96, arabic: "الْبَاقِي", translit: "Al-Baqi", meaning: "The Everlasting", reflection: "Everything passes; He is what remains."),
        DivineName(id: 97, arabic: "الْوَارِثُ", translit: "Al-Warith", meaning: "The Inheritor", reflection: "All that is held returns to the original Holder."),
        DivineName(id: 98, arabic: "الرَّشِيدُ", translit: "Ar-Rashid", meaning: "The Perfect Guide to Right", reflection: "His direction needs no second opinion."),
        DivineName(id: 99, arabic: "الصَّبُورُ", translit: "As-Sabur", meaning: "The Utterly Patient", reflection: "Patient with us longer than we are with anything.")
    ]

    static let all: [DivineName] = part1 + part2 + block7 + block8 + block9
}
