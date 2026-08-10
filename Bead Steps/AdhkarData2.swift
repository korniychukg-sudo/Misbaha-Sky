import Foundation

extension AdhkarData {
    static let eveningSet = AdhkarSet(
        id: "evening",
        title: "Evening Calm",
        subtitle: "Remembrance as the light goes",
        timeHint: "After asr, before night",
        artName: "set-evening",
        intro: "The evening adhkar close the day the way the morning ones opened it. They are said in the late afternoon and at dusk — words of shelter and gratitude before the world goes dark.",
        items: [
            DhikrItem(
                id: "evening-amsayna",
                arabic: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ",
                translit: "Amsayna wa amsal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah",
                english: "We have entered the evening, and the dominion has entered it belonging to Allah. Praise belongs to Allah; there is no god but Allah alone, without partner.",
                count: 1,
                note: "The opening line of the evening remembrance.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "evening-bika",
                arabic: "اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ",
                translit: "Allahumma bika amsayna wa bika asbahna wa bika nahya wa bika namutu wa ilaykal-masir",
                english: "O Allah, by You we enter the evening and by You we enter the morning; by You we live and by You we die, and to You is the final return.",
                count: 1,
                note: "The evening turn of the morning words.",
                source: "At-Tirmidhi"
            ),
            DhikrItem(
                id: "evening-audhu",
                arabic: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
                translit: "A'udhu bikalimatillahit-tammati min sharri ma khalaq",
                english: "I seek refuge in the perfect words of Allah from the harm of what He has created.",
                count: 3,
                note: "Spoken at nightfall, a shelter for the dark hours.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "evening-bismillah",
                arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
                translit: "Bismillahil-ladhi la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i wa huwas-sami'ul-'alim",
                english: "In the name of Allah, with whose name nothing on earth or in heaven can cause harm — and He is the All-Hearing, the All-Knowing.",
                count: 3,
                note: "Three times in the evening, as in the morning.",
                source: "Abu Dawud"
            ),
            DhikrItem(
                id: "evening-subhan100",
                arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
                translit: "Subhan Allahi wa bihamdih",
                english: "Glory be to Allah, and praise is His.",
                count: 100,
                note: "The evening hundred, matching the morning's.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "evening-tahlil10",
                arabic: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                translit: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa 'ala kulli shay'in qadir",
                english: "There is no god but Allah alone, without partner. His is the dominion and His is the praise, and He is able to do all things.",
                count: 10,
                note: "Ten declarations of oneness to close the day.",
                source: "Muslim"
            )
        ]
    )

    static let sleepSet = AdhkarSet(
        id: "sleep",
        title: "Before Sleep",
        subtitle: "The last words of the day",
        timeHint: "At the bedside",
        artName: "set-sleep",
        intro: "Sleep is a small surrender, and it has its own farewell. These are the words said once the lamp is out — ending with the counted tasbih that was given in place of a servant.",
        items: [
            DhikrItem(
                id: "sleep-bismika",
                arabic: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
                translit: "Bismika Allahumma amutu wa ahya",
                english: "In Your name, O Allah, I die and I live.",
                count: 1,
                note: "Said when lying down for the night.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "sleep-janbi",
                arabic: "بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ",
                translit: "Bismika rabbi wada'tu janbi wa bika arfa'uh, fa in amsakta nafsi farhamha, wa in arsaltaha fahfazha bima tahfazu bihi 'ibadakas-salihin",
                english: "In Your name, my Lord, I lay down my side, and by You I raise it. If You keep my soul, have mercy on it; and if You release it, guard it as You guard Your righteous servants.",
                count: 1,
                note: "The words of lying down, hand beneath the cheek.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "sleep-tasbih",
                arabic: "سُبْحَانَ اللَّهِ",
                translit: "Subhan Allah",
                english: "Glory be to Allah.",
                count: 33,
                note: "The bedtime tasbih given to Fatimah in place of a servant.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "sleep-tahmid",
                arabic: "الْحَمْدُ لِلَّهِ",
                translit: "Alhamdu lillah",
                english: "All praise belongs to Allah.",
                count: 33,
                note: "Thirty-three of praise before the eyes close.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "sleep-takbir",
                arabic: "اللَّهُ أَكْبَرُ",
                translit: "Allahu akbar",
                english: "Allah is greater.",
                count: 34,
                note: "Thirty-four completes the hundred of the night.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "sleep-qini",
                arabic: "اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ",
                translit: "Allahumma qini 'adhabaka yawma tab'athu 'ibadak",
                english: "O Allah, protect me from Your punishment on the day You raise Your servants.",
                count: 3,
                note: "Said with the right hand under the cheek.",
                source: "Abu Dawud"
            )
        ]
    )

    static let wakingSet = AdhkarSet(
        id: "waking",
        title: "On Waking",
        subtitle: "The first words back",
        timeHint: "Before rising",
        artName: "set-waking",
        intro: "The day does not begin with the feet but with the tongue. Before rising, the sleeper answers the return of the soul with three short lines of thanks.",
        items: [
            DhikrItem(
                id: "waking-ahyana",
                arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
                translit: "Alhamdu lillahil-ladhi ahyana ba'da ma amatana wa ilayhin-nushur",
                english: "Praise belongs to Allah, who gave us life after taking it from us, and to Him is the resurrection.",
                count: 1,
                note: "The first sentence of the day.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "waking-afani",
                arabic: "الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي فِي جَسَدِي وَرَدَّ عَلَيَّ رُوحِي وَأَذِنَ لِي بِذِكْرِهِ",
                translit: "Alhamdu lillahil-ladhi 'afani fi jasadi wa radda 'alayya ruhi wa adhina li bidhikrih",
                english: "Praise belongs to Allah, who kept my body sound, returned my soul to me, and allowed me to remember Him.",
                count: 1,
                note: "Thanks for the body, the soul and the permission to speak.",
                source: "At-Tirmidhi"
            ),
            DhikrItem(
                id: "waking-baqiyat",
                arabic: "سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ",
                translit: "Subhan Allahi walhamdu lillahi wa la ilaha illallahu wallahu akbar",
                english: "Glory be to Allah, praise belongs to Allah, there is no god but Allah, and Allah is greater.",
                count: 10,
                note: "The four enduring words, counted ten times to begin.",
                source: "Muslim"
            )
        ]
    )
}
