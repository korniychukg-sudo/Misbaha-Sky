import Foundation

enum AdhkarData {
    static let prayerSet = AdhkarSet(
        id: "prayer",
        title: "After the Prayer",
        subtitle: "The tasbih that follows every salah",
        timeHint: "Five times a day",
        artName: "set-prayer",
        intro: "When the prayer ends, the beads begin. This is the most practiced sequence in the Muslim day: glorifying, praising and magnifying Allah thirty-three times each, sealed with a single declaration of His oneness.",
        items: [
            DhikrItem(
                id: "prayer-istighfar",
                arabic: "أَسْتَغْفِرُ اللَّهَ",
                translit: "Astaghfirullah",
                english: "I seek the forgiveness of Allah.",
                count: 3,
                note: "Said three times immediately after the closing of the prayer.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "prayer-tasbih",
                arabic: "سُبْحَانَ اللَّهِ",
                translit: "Subhan Allah",
                english: "Glory be to Allah.",
                count: 33,
                note: "The first third of the tasbih of the prayer.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "prayer-tahmid",
                arabic: "الْحَمْدُ لِلَّهِ",
                translit: "Alhamdu lillah",
                english: "All praise belongs to Allah.",
                count: 33,
                note: "The second third: gratitude counted out one bead at a time.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "prayer-takbir",
                arabic: "اللَّهُ أَكْبَرُ",
                translit: "Allahu akbar",
                english: "Allah is greater.",
                count: 34,
                note: "Thirty-four completes the hundred of the prayer tasbih.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "prayer-tahlil",
                arabic: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                translit: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa 'ala kulli shay'in qadir",
                english: "There is no god but Allah alone, without partner. His is the dominion and His is the praise, and He is able to do all things.",
                count: 10,
                note: "A seal of ten after the dawn and sunset prayers in particular.",
                source: "At-Tirmidhi"
            )
        ]
    )

    static let morningSet = AdhkarSet(
        id: "morning",
        title: "Morning Light",
        subtitle: "Remembrance between dawn and sunrise",
        timeHint: "After fajr",
        artName: "set-morning",
        intro: "The morning adhkar open the day before the day can open itself. They are said once the dawn prayer is done, while the light is still low — a hundred small words that put the coming hours in order.",
        items: [
            DhikrItem(
                id: "morning-asbahna",
                arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ",
                translit: "Asbahna wa asbahal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah",
                english: "We have entered the morning, and the dominion has entered it belonging to Allah. Praise belongs to Allah; there is no god but Allah alone, without partner.",
                count: 1,
                note: "The opening line of the morning remembrance.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "morning-bika",
                arabic: "اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ",
                translit: "Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilaykan-nushur",
                english: "O Allah, by You we enter the morning and by You we enter the evening; by You we live and by You we die, and to You is the resurrection.",
                count: 1,
                note: "Morning and evening carry the same words, turned around.",
                source: "At-Tirmidhi"
            ),
            DhikrItem(
                id: "morning-sayyid",
                arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
                translit: "Allahumma anta rabbi la ilaha illa ant, khalaqtani wa ana 'abduk, wa ana 'ala 'ahdika wa wa'dika mastata't, a'udhu bika min sharri ma sana't, abu'u laka bini'matika 'alayya wa abu'u bidhanbi, faghfir li fa innahu la yaghfirudh-dhunuba illa ant",
                english: "O Allah, You are my Lord; there is no god but You. You created me and I am Your servant, and I keep Your covenant and promise as far as I am able. I seek refuge in You from the harm I have done. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me — for none forgives sins but You.",
                count: 1,
                note: "Known as the master plea for forgiveness.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "morning-bismillah",
                arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
                translit: "Bismillahil-ladhi la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i wa huwas-sami'ul-'alim",
                english: "In the name of Allah, with whose name nothing on earth or in heaven can cause harm — and He is the All-Hearing, the All-Knowing.",
                count: 3,
                note: "Three times in the morning and three in the evening.",
                source: "Abu Dawud"
            ),
            DhikrItem(
                id: "morning-radhitu",
                arabic: "رَضِيتُ بِاللَّهِ رَبًّا وَبِالْإِسْلَامِ دِينًا وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
                translit: "Raditu billahi rabban wa bil-islami dinan wa bi Muhammadin sallallahu 'alayhi wa sallama nabiyya",
                english: "I am content with Allah as Lord, with Islam as religion, and with Muhammad, peace be upon him, as Prophet.",
                count: 3,
                note: "A quiet settling of the heart before the day begins.",
                source: "Abu Dawud"
            ),
            DhikrItem(
                id: "morning-hasbi",
                arabic: "حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ",
                translit: "Hasbiyallahu la ilaha illa huwa 'alayhi tawakkaltu wa huwa rabbul-'arshil-'azim",
                english: "Allah is sufficient for me; there is no god but Him. In Him I place my trust, and He is the Lord of the mighty Throne.",
                count: 7,
                note: "Seven times, morning and evening.",
                source: "Abu Dawud"
            ),
            DhikrItem(
                id: "morning-subhan100",
                arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
                translit: "Subhan Allahi wa bihamdih",
                english: "Glory be to Allah, and praise is His.",
                count: 100,
                note: "A hundred at daybreak — light on the tongue, heavy in the balance.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "morning-tahlil10",
                arabic: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                translit: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa 'ala kulli shay'in qadir",
                english: "There is no god but Allah alone, without partner. His is the dominion and His is the praise, and He is able to do all things.",
                count: 10,
                note: "Ten declarations of oneness to open the day.",
                source: "Muslim"
            )
        ]
    )
}
