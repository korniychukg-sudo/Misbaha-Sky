import Foundation

extension AdhkarData {
    static let doorSet = AdhkarSet(
        id: "door",
        title: "Through the Door",
        subtitle: "Leaving, returning, and the blessing between",
        timeHint: "Every crossing",
        artName: "set-door",
        intro: "A door is a decision. These are the words for stepping out into the world, for stepping back into the home, and for the blessing on the Prophet that travels well through any part of the day.",
        items: [
            DhikrItem(
                id: "door-leaving",
                arabic: "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
                translit: "Bismillahi tawakkaltu 'alallahi wa la hawla wa la quwwata illa billah",
                english: "In the name of Allah; I place my trust in Allah, and there is no power and no strength except by Allah.",
                count: 1,
                note: "Said when stepping out of the house.",
                source: "Abu Dawud"
            ),
            DhikrItem(
                id: "door-entering",
                arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلِجِ وَخَيْرَ الْمَخْرَجِ، بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا",
                translit: "Allahumma inni as'aluka khayral-mawliji wa khayral-makhraj, bismillahi walajna wa bismillahi kharajna wa 'alallahi rabbina tawakkalna",
                english: "O Allah, I ask You for the best entering and the best leaving. In the name of Allah we enter, in the name of Allah we leave, and upon Allah our Lord we rely.",
                count: 1,
                note: "Said at the threshold when coming home.",
                source: "Abu Dawud"
            ),
            DhikrItem(
                id: "door-salawat",
                arabic: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ",
                translit: "Allahumma salli 'ala Muhammadin wa 'ala ali Muhammad",
                english: "O Allah, send blessings upon Muhammad and upon the family of Muhammad.",
                count: 10,
                note: "The blessing on the Prophet, welcome at any hour.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "door-hawqala",
                arabic: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
                translit: "La hawla wa la quwwata illa billah",
                english: "There is no power and no strength except by Allah.",
                count: 33,
                note: "Called a treasure from the treasures of Paradise.",
                source: "Al-Bukhari"
            )
        ]
    )

    static let roadSet = AdhkarSet(
        id: "road",
        title: "On the Road",
        subtitle: "For journeys long and short",
        timeHint: "When travelling",
        artName: "set-road",
        intro: "Travel unsettles the ordinary day, so it carries its own remembrance: words for mounting whatever carries you, and a plea that the journey hold goodness in it.",
        items: [
            DhikrItem(
                id: "road-takbir",
                arabic: "اللَّهُ أَكْبَرُ",
                translit: "Allahu akbar",
                english: "Allah is greater.",
                count: 3,
                note: "Three takbirs when the journey begins.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "road-sakhkhara",
                arabic: "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ",
                translit: "Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila rabbina lamunqalibun",
                english: "Glory be to the One who placed this at our service, for we could never have mastered it ourselves — and to our Lord we shall surely return.",
                count: 1,
                note: "Said on mounting a ride, ancient or modern.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "road-birr",
                arabic: "اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى وَمِنَ الْعَمَلِ مَا تَرْضَى",
                translit: "Allahumma inna nas'aluka fi safarina hadhal-birra wat-taqwa wa minal-'amali ma tarda",
                english: "O Allah, we ask You in this journey of ours for righteousness, for mindfulness of You, and for deeds that please You.",
                count: 1,
                note: "From the traveller's plea of the Prophet.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "road-istighfar",
                arabic: "أَسْتَغْفِرُ اللَّهَ",
                translit: "Astaghfirullah",
                english: "I seek the forgiveness of Allah.",
                count: 33,
                note: "Miles pass easier with the tongue at work.",
                source: "Muslim"
            )
        ]
    )

    static let heartSet = AdhkarSet(
        id: "heart",
        title: "In Hardship, In Thanks",
        subtitle: "Words for the heavy day and the bright one",
        timeHint: "Whenever needed",
        artName: "set-heart",
        intro: "Some remembrance belongs to no hour of the clock. These are the words reached for when the day turns heavy — and the ones owed when it turns out well.",
        items: [
            DhikrItem(
                id: "heart-hasbuna",
                arabic: "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ",
                translit: "Hasbunallahu wa ni'mal-wakil",
                english: "Allah is sufficient for us, and what an excellent guardian He is.",
                count: 7,
                note: "The words of Ibrahim when the fire was lit.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "heart-hawqala",
                arabic: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
                translit: "La hawla wa la quwwata illa billah",
                english: "There is no power and no strength except by Allah.",
                count: 33,
                note: "For the moment the task is larger than the hands.",
                source: "Al-Bukhari"
            ),
            DhikrItem(
                id: "heart-istirja",
                arabic: "إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ",
                translit: "Inna lillahi wa inna ilayhi raji'un",
                english: "Surely we belong to Allah, and surely to Him we return.",
                count: 1,
                note: "Said at loss of any size, from keys to people.",
                source: "Muslim"
            ),
            DhikrItem(
                id: "heart-sahla",
                arabic: "اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا",
                translit: "Allahumma la sahla illa ma ja'altahu sahla, wa anta taj'alul-hazna idha shi'ta sahla",
                english: "O Allah, nothing is easy except what You make easy — and You make the hard thing easy when You will.",
                count: 1,
                note: "For the door that will not open.",
                source: "Ibn Hibban"
            ),
            DhikrItem(
                id: "heart-dhunnun",
                arabic: "لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
                translit: "La ilaha illa anta subhanaka inni kuntu minaz-zalimin",
                english: "There is no god but You; glory be to You — surely I have been among the wrongdoers.",
                count: 3,
                note: "The call of Yunus from inside the whale.",
                source: "At-Tirmidhi"
            ),
            DhikrItem(
                id: "heart-salihat",
                arabic: "الْحَمْدُ لِلَّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ",
                translit: "Alhamdu lillahil-ladhi bini'matihi tatimmus-salihat",
                english: "Praise belongs to Allah, by whose favour good things reach completion.",
                count: 1,
                note: "For the day that ended better than it began.",
                source: "Ibn Majah"
            )
        ]
    )

    static let all: [AdhkarSet] = [
        prayerSet, morningSet, eveningSet, sleepSet,
        wakingSet, doorSet, roadSet, heartSet
    ]
}
