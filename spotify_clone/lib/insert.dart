import 'package:cloud_firestore/cloud_firestore.dart';

void addMultipleDocumentsToFirestore() async {
  // Create a Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Example data - list of maps (each map represents a document)
  List<Map<String, dynamic>> documents = [
    // {
    //   "artist": "Jay-Z",
    //   "genre": "Rap",
    //   "image_path": "assets/images/EmpireState.jpg",
    //   "length": "4:37",
    //   "liked_by": [],
    //   "song_name": "EmpireState.mp3",
    //   "title": "Empire State of Mind"
    // },
    // {
    //   "artist": "Eminem",
    //   "genre": "Rap",
    //   "image_path": "assets/images/LoseYourself.jpg",
    //   "length": "5:20",
    //   "liked_by": [],
    //   "song_name": "LoseYourself.mp3",
    //   "title": "Lose Yourself"
    // },
    // {
    //   "artist": "Nicki Minaj",
    //   "genre": "Rap",
    //   "image_path": "assets/images/SuperBass.jpg",
    //   "length": "3:30",
    //   "liked_by": [],
    //   "song_name": "SuperBass.mp3",
    //   "title": "Super Bass"
    // },
    // {
    //   "artist": "Drake",
    //   "genre": "Rap",
    //   "image_path": "assets/images/HotlineBling.jpg",
    //   "length": "4:29",
    //   "liked_by": [],
    //   "song_name": "HotlineBling.mp3",
    //   "title": "Hotline Bling"
    // },
    // {
    //   "artist": "Cardi B",
    //   "genre": "Rap",
    //   "image_path": "assets/images/BodakYellow.jpg",
    //   "length": "3:41",
    //   "liked_by": [],
    //   "song_name": "BodakYellow.mp3",
    //   "title": "Bodak Yellow"
    // },
    // {
    //   "artist": "Kanye West",
    //   "genre": "Rap",
    //   "image_path": "assets/images/Stronger.jpg",
    //   "length": "5:12",
    //   "liked_by": [],
    //   "song_name": "Stronger.mp3",
    //   "title": "Stronger"
    // },
    // {
    //   "artist": "Travis Scott",
    //   "genre": "Rap",
    //   "image_path": "assets/images/SICKOMODE.jpg",
    //   "length": "5:12",
    //   "liked_by": [],
    //   "song_name": "SICKOMODE.mp3",
    //   "title": "SICKO MODE"
    // },
    // {
    //   "artist": "Lil Wayne",
    //   "genre": "Rap",
    //   "image_path": "assets/images/Lollipop.jpg",
    //   "length": "5:02",
    //   "liked_by": [],
    //   "song_name": "Lollipop.mp3",
    //   "title": "Lollipop"
    // },
    // {
    //   "artist": "Megan Thee Stallion",
    //   "genre": "Rap",
    //   "image_path": "assets/images/Savage.jpg",
    //   "length": "2:36",
    //   "liked_by": [],
    //   "song_name": "Savage.mp3",
    //   "title": "Savage"
    // },
    // {
    //   "artist": "Logic",
    //   "genre": "Rap",
    //   "image_path": "assets/images/UnderPressure.jpg",
    //   "length": "10:20",
    //   "liked_by": [],
    //   "song_name": "UnderPressure.mp3",
    //   "title": "Under Pressure"
    // },
    // {
    //   "artist": "Snoop Dogg",
    //   "genre": "Rap",
    //   "image_path": "assets/images/DropItLikeItsHot.jpg",
    //   "length": "4:33",
    //   "liked_by": [],
    //   "song_name": "DropItLikeItsHot.mp3",
    //   "title": "Drop It Like It's Hot"
    // },
    // {
    //   "artist": "ASAP Rocky",
    //   "genre": "Rap",
    //   "image_path": "assets/images/Goldie.jpg",
    //   "length": "3:15",
    //   "liked_by": [],
    //   "song_name": "Goldie.mp3",
    //   "title": "Goldie"
    // },
    // {
    //   "artist": "Wiz Khalifa",
    //   "genre": "Rap",
    //   "image_path": "assets/images/SeeYouAgain.jpg",
    //   "length": "3:50",
    //   "liked_by": [],
    //   "song_name": "SeeYouAgain.mp3",
    //   "title": "See You Again"
    // },
    // {
    //   "artist": "Post Malone",
    //   "genre": "Rap",
    //   "image_path": "assets/images/Circles.jpg",
    //   "length": "3:35",
    //   "liked_by": [],
    //   "song_name": "Circles.mp3",
    //   "title": "Circles"
    // },
    // {
    //   "artist": "Juice WRLD",
    //   "genre": "Rap",
    //   "image_path": "assets/images/LucidDreams.jpg",
    //   "length": "4:01",
    //   "liked_by": [],
    //   "song_name": "LucidDreams.mp3",
    //   "title": "Lucid Dreams"
    // },
    // {
    //   "artist": "Lil Uzi Vert",
    //   "genre": "Rap",
    //   "image_path": "assets/images/XOTourLlif3.jpg",
    //   "length": "3:02",
    //   "liked_by": [],
    //   "song_name": "XOTourLlif3.mp3",
    //   "title": "XO TOUR Llif3"
    // },
    // {
    //   "artist": "Future",
    //   "genre": "Rap",
    //   "image_path": "assets/images/MaskOff.jpg",
    //   "length": "3:24",
    //   "liked_by": [],
    //   "song_name": "MaskOff.mp3",
    //   "title": "Mask Off"
    // },
    // {
    //   "artist": "21 Savage",
    //   "genre": "Rap",
    //   "image_path": "assets/images/BankAccount.jpg",
    //   "length": "3:40",
    //   "liked_by": [],
    //   "song_name": "BankAccount.mp3",
    //   "title": "Bank Account"
    // },
    // {
    //   "artist": "YG",
    //   "genre": "Rap",
    //   "image_path": "assets/images/BigBank.jpg",
    //   "length": "4:06",
    //   "liked_by": [],
    //   "song_name": "BigBank.mp3",
    //   "title": "Big Bank"
    // },
    // {
    //   "artist": "Gucci Mane",
    //   "genre": "Rap",
    //   "image_path": "assets/images/IceCream.jpg",
    //   "length": "2:38",
    //   "liked_by": [],
    //   "song_name": "IceCream.mp3",
    //   "title": "Ice Cream"
    // },
    // {
    //   "artist": "Miles Davis",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/SoWhat.jpg",
    //   "length": "9:07",
    //   "liked_by": [],
    //   "song_name": "SoWhat.mp3",
    //   "title": "So What"
    // },

    // {
    //   "artist": "John Coltrane",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/BlueTrain.jpg",
    //   "length": "10:43",
    //   "liked_by": [],
    //   "song_name": "BlueTrain.mp3",
    //   "title": "Blue Train"
    // },

    // {
    //   "artist": "Ella Fitzgerald",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/Summertime.jpg",
    //   "length": "3:40",
    //   "liked_by": [],
    //   "song_name": "Summertime.mp3",
    //   "title": "Summertime"
    // },

    // {
    //   "artist": "Duke Ellington",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/TakeTheATrain.jpg",
    //   "length": "3:14",
    //   "liked_by": [],
    //   "song_name": "TakeTheATrain.mp3",
    //   "title": "Take the 'A' Train"
    // },

    // {
    //   "artist": "Louis Armstrong",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/WhatAWonderfulWorld.jpg",
    //   "length": "2:17",
    //   "liked_by": [],
    //   "song_name": "WhatAWonderfulWorld.mp3",
    //   "title": "What a Wonderful World"
    // },

    // {
    //   "artist": "Billie Holiday",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/StrangeFruit.jpg",
    //   "length": "3:02",
    //   "liked_by": [],
    //   "song_name": "StrangeFruit.mp3",
    //   "title": "Strange Fruit"
    // },

    // {
    //   "artist": "Thelonious Monk",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/BlueMonk.jpg",
    //   "length": "8:30",
    //   "liked_by": [],
    //   "song_name": "BlueMonk.mp3",
    //   "title": "Blue Monk"
    // },

    // {
    //   "artist": "Charlie Parker",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/NowsTheTime.jpg",
    //   "length": "3:10",
    //   "liked_by": [],
    //   "song_name": "NowsTheTime.mp3",
    //   "title": "Now's the Time"
    // },

    // {
    //   "artist": "Michael Buble",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/FeelingGood.jpg",
    //   "length": "4:02",
    //   "liked_by": [],
    //   "song_name": "FeelingGood.mp3",
    //   "title": "Feeling Good"
    // },

    // {
    //   "artist": "Stan Getz",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/GirlFromIpanema.jpg",
    //   "length": "5:24",
    //   "liked_by": [],
    //   "song_name": "GirlFromIpanema.mp3",
    //   "title": "The Girl from Ipanema"
    // },

    // {
    //   "artist": "Dave Brubeck Quartet",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/TakeFive.jpg",
    //   "length": "5:30",
    //   "liked_by": [],
    //   "song_name": "TakeFive.mp3",
    //   "title": "Take Five"
    // },

    // {
    //   "artist": "Sarah Vaughan",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/Misty.jpg",
    //   "length": "3:04",
    //   "liked_by": [],
    //   "song_name": "Misty.mp3",
    //   "title": "Misty"
    // },

    // {
    //   "artist": "Herbie Hancock",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/Chameleon.jpg",
    //   "length": "15:41",
    //   "liked_by": [],
    //   "song_name": "Chameleon.mp3",
    //   "title": "Chameleon"
    // },

    // {
    //   "artist": "Art Blakey & The Jazz Messengers",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/Moanin.jpg",
    //   "length": "9:34",
    //   "liked_by": [],
    //   "song_name": "Moanin.mp3",
    //   "title": "Moanin'"
    // },

    // {
    //   "artist": "Dizzy Gillespie",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/ANightInTunisia.jpg",
    //   "length": "7:08",
    //   "liked_by": [],
    //   "song_name": "ANightInTunisia.mp3",
    //   "title": "A Night In Tunisia"
    // },

    // {
    //   "artist": "Cannonball Adderley",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/AutumnLeaves.jpg",
    //   "length": "11:01",
    //   "liked_by": [],
    //   "song_name": "AutumnLeaves.mp3",
    //   "title": "Autumn Leaves"
    // },

    // {
    //   "artist": "Chet Baker",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/MyFunnyValentine.jpg",
    //   "length": "2:21",
    //   "liked_by": [],
    //   "song_name": "MyFunnyValentine.mp3",
    //   "title": "My Funny Valentine"
    // },

    // {
    //   "artist": "Erich Kunzel",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/SingSingSing.jpg",
    //   "length": "5:01",
    //   "liked_by": [],
    //   "song_name": "SingSingSing.mp3",
    //   "title": "Sing, Sing, Sing"
    // },

    // {
    //   "artist": "Frank Sinatra",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/FlyMeToTheMoon.jpg",
    //   "length": "2:28",
    //   "liked_by": [],
    //   "song_name": "FlyMeToTheMoon.mp3",
    //   "title": "Fly Me To The Moon"
    // },

    // {
    //   "artist": "Oscar Peterson Trio",
    //   "genre": "Jazz",
    //   "image_path": "assets/images/HymnToFreedom.jpg",
    //   "length": "5:34",
    //   "liked_by": [],
    //   "song_name": "HymnToFreedom.mp3",
    //   "title": "Hymn to Freedom"
    // },
    // {
    //   "artist": "Led Zeppelin",
    //   "genre": "Rock",
    //   "image_path": "assets/images/StairwayToHeaven.jpg",
    //   "length": "8:02",
    //   "liked_by": [],
    //   "song_name": "StairwayToHeaven.mp3",
    //   "title": "Stairway to Heaven"
    // },

    // {
    //   "artist": "The Rolling Stones",
    //   "genre": "Rock",
    //   "image_path": "assets/images/PaintItBlack.jpg",
    //   "length": "3:22",
    //   "liked_by": [],
    //   "song_name": "PaintItBlack.mp3",
    //   "title": "Paint It Black"
    // },

    // {
    //   "artist": "Queen",
    //   "genre": "Rock",
    //   "image_path": "assets/images/BohemianRhapsody.jpg",
    //   "length": "5:55",
    //   "liked_by": [],
    //   "song_name": "BohemianRhapsody.mp3",
    //   "title": "Bohemian Rhapsody"
    // },

    // {
    //   "artist": "The Beatles",
    //   "genre": "Rock",
    //   "image_path": "assets/images/HeyJude.jpg",
    //   "length": "7:11",
    //   "liked_by": [],
    //   "song_name": "HeyJude.mp3",
    //   "title": "Hey Jude"
    // },

    // {
    //   "artist": "Pink Floyd",
    //   "genre": "Rock",
    //   "image_path": "assets/images/WishYouWereHere.jpg",
    //   "length": "5:34",
    //   "liked_by": [],
    //   "song_name": "WishYouWereHere.mp3",
    //   "title": "Wish You Were Here"
    // },

    // {
    //   "artist": "The Who",
    //   "genre": "Rock",
    //   "image_path": "assets/images/BabaORiley.jpg",
    //   "length": "5:08",
    //   "liked_by": [],
    //   "song_name": "BabaORiley.mp3",
    //   "title": "Baba O'Riley"
    // },

    // {
    //   "artist": "U2",
    //   "genre": "Rock",
    //   "image_path": "assets/images/WithOrWithoutYou.jpg",
    //   "length": "4:56",
    //   "liked_by": [],
    //   "song_name": "WithOrWithoutYou.mp3",
    //   "title": "With or Without You"
    // },

    // {
    //   "artist": "AC/DC",
    //   "genre": "Rock",
    //   "image_path": "assets/images/BackInBlack.jpg",
    //   "length": "4:15",
    //   "liked_by": [],
    //   "song_name": "BackInBlack.mp3",
    //   "title": "Back in Black"
    // },

    // {
    //   "artist": "Nirvana",
    //   "genre": "Rock",
    //   "image_path": "assets/images/SmellsLikeTeenSpirit.jpg",
    //   "length": "5:01",
    //   "liked_by": [],
    //   "song_name": "SmellsLikeTeenSpirit.mp3",
    //   "title": "Smells Like Teen Spirit"
    // },

    // {
    //   "artist": "The Eagles",
    //   "genre": "Rock",
    //   "image_path": "assets/images/HotelCalifornia.jpg",
    //   "length": "6:30",
    //   "liked_by": [],
    //   "song_name": "HotelCalifornia.mp3",
    //   "title": "Hotel California"
    // },

    // {
    //   "artist": "The Doors",
    //   "genre": "Rock",
    //   "image_path": "assets/images/LightMyFire.jpg",
    //   "length": "7:06",
    //   "liked_by": [],
    //   "song_name": "LightMyFire.mp3",
    //   "title": "Light My Fire"
    // },

    // {
    //   "artist": "Guns N' Roses",
    //   "genre": "Rock",
    //   "image_path": "assets/images/SweetChildOMine.jpg",
    //   "length": "5:56",
    //   "liked_by": [],
    //   "song_name": "SweetChildOMine.mp3",
    //   "title": "Sweet Child o' Mine"
    // },

    // {
    //   "artist": "Jimi Hendrix",
    //   "genre": "Rock",
    //   "image_path": "assets/images/PurpleHaze.jpg",
    //   "length": "2:50",
    //   "liked_by": [],
    //   "song_name": "PurpleHaze.mp3",
    //   "title": "Purple Haze"
    // },

    // {
    //   "artist": "Radiohead",
    //   "genre": "Rock",
    //   "image_path": "assets/images/KarmaPolice.jpg",
    //   "length": "4:21",
    //   "liked_by": [],
    //   "song_name": "KarmaPolice.mp3",
    //   "title": "Karma Police"
    // },

    // {
    //   "artist": "Bruce Springsteen",
    //   "genre": "Rock",
    //   "image_path": "assets/images/BornToRun.jpg",
    //   "length": "4:30",
    //   "liked_by": [],
    //   "song_name": "BornToRun.mp3",
    //   "title": "Born to Run"
    // },

    // {
    //   "artist": "Pearl Jam",
    //   "genre": "Rock",
    //   "image_path": "assets/images/Alive.jpg",
    //   "length": "5:40",
    //   "liked_by": [],
    //   "song_name": "Alive.mp3",
    //   "title": "Alive"
    // },

    // {
    //   "artist": "Foo Fighters",
    //   "genre": "Rock",
    //   "image_path": "assets/images/Everlong.jpg",
    //   "length": "4:10",
    //   "liked_by": [],
    //   "song_name": "Everlong.mp3",
    //   "title": "Everlong"
    // },

    // {
    //   "artist": "Coldplay",
    //   "genre": "Rock",
    //   "image_path": "assets/images/Yellow.jpg",
    //   "length": "4:29",
    //   "liked_by": [],
    //   "song_name": "Yellow.mp3",
    //   "title": "Yellow"
    // },

    // {
    //   "artist": "Red Hot Chili Peppers",
    //   "genre": "Rock",
    //   "image_path": "assets/images/UnderTheBridge.jpg",
    //   "length": "4:34",
    //   "liked_by": [],
    //   "song_name": "UnderTheBridge.mp3",
    //   "title": "Under the Bridge"
    // },

    // {
    //   "artist": "Linkin Park",
    //   "genre": "Rock",
    //   "image_path": "assets/images/InTheEnd.jpg",
    //   "length": "3:36",
    //   "liked_by": [],
    //   "song_name": "InTheEnd.mp3",
    //   "title": "In the End"
    // }
    // {
    //   "artist": "Ahmed Basyouni",
    //   "genre": "Arabic",
    //   "image_path": "assets/images/basyouni.jpg",
    //   "length": "2:59",
    //   "liked_by": [],
    //   "song_name": "Basyouni.mp3",
    //   "title": "What is this Beauty?"
    // },
    // {
    //   "artist": "Tamer Hosny",
    //   "genre": "Arabic",
    //   "image_path": "assets/images/TamerHosny.jpg",
    //   "length": "4:05",
    //   "liked_by": [],
    //   "song_name": "TamerHosny.mp3",
    //   "title": "What is this Beauty?"
    // },
    // {
    //   "artist": "Amr Diab",
    //   "genre": "Arabic",
    //   "image_path": "assets/images/amrdiab.png",
    //   "length": "5:33",
    //   "liked_by": [],
    //   "song_name": "AmrDiab.mp3",
    //   "title": "Threaten Me"
    // },
    // {
    //   "artist": "Ahmed Saad",
    //   "genre": "Arabic",
    //   "image_path": "assets/images/AhmedSaad.jpg",
    //   "length": "4:02",
    //   "liked_by": [],
    //   "song_name": "Robbery.mp3",
    //   "title": "Move Away Move Away!"
    // },
    // {
    //   "artist": "Wegz ft. Molotof",
    //   "genre": "Arabic",
    //   "image_path": "assets/images/Wegz.jpg",
    //   "length": "3:45",
    //   "liked_by": [],
    //   "song_name": "DorakGai.mp3",
    //   "title": "Your next in line!"
    // },
  ];
  ;

  // Loop through the list and add documents to Firestore
  for (var docData in documents) {
    try {
      // Add document to a collection named 'your_collection_name'
      await firestore.collection('Songs').add(docData);
      print('Document added successfully');
    } catch (e) {
      print('Error adding document: $e');
    }
  }
}
