import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modernapplication_project/Library.dart';
import 'package:modernapplication_project/homepage.dart';
import 'components/songcomponent.dart';
import 'components/musicdisplay.dart';
import 'dart:math';
import 'SearchPage.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Library()));
    }
  }

  int activeButtonIndex = 0;

  Random randomSong = Random();
  List<QueryDocumentSnapshot> randomSongs = [];
  getData() async {
    List<QueryDocumentSnapshot> allSongs = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Songs').get();
    allSongs.addAll(querySnapshot.docs);
    while (randomSongs.length < 10) {
      var random = randomSong.nextInt(allSongs.length);
      if (randomSongs.contains(allSongs[random])) {
        continue;
      } else {
        randomSongs.add(allSongs[random]);
      }
    }
    setState(() {});
  }

  List<QueryDocumentSnapshot> rockSongss = [];
  getRockData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Songs')
          .where("genre", isEqualTo: "Rock")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        rockSongss = querySnapshot.docs;
      } else {
        print("No Rock songs found.");
      }

      setState(() {});
    } catch (e) {
      print("Error fetching Rock songs: $e");
    }
  }

  List<QueryDocumentSnapshot> HipHops = [];
  getHipData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Songs')
          .where("genre", isEqualTo: "Rap")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        HipHops = querySnapshot.docs;
      } else {
        print("No Rock songs found.");
      }

      setState(() {});
    } catch (e) {
      print("Error fetching Rock songs: $e");
    }
  }

  List<QueryDocumentSnapshot> Jazz = [];
  getJazzData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Songs')
          .where("genre", isEqualTo: "Jazz")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Jazz = querySnapshot.docs;
      } else {
        print("No Rock songs found.");
      }

      setState(() {});
    } catch (e) {
      print("Error fetching Rock songs: $e");
    }
  }

  List<QueryDocumentSnapshot> arabicSongs = [];
  getArabicData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Songs')
          .where("genre", isEqualTo: "Arabic")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        arabicSongs = querySnapshot.docs;
      } else {
        print("No Arabic songs found.");
      }

      setState(() {});
    } catch (e) {
      print("Error fetching Arabic songs: $e");
    }
  }

  loading() async {
    await Future.delayed(Duration(milliseconds: 600));
  }

  @override
  void initState() {
    super.initState();
    getData();
    getRockData();
    getHipData();
    getJazzData();
    getArabicData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * .075),
          child: AppBar(
            backgroundColor: const Color.fromRGBO(145, 195, 255, 1),
            leadingWidth: screenWidth,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  side: BorderSide.none),
              extendedPadding: EdgeInsets.fromLTRB(
                  screenWidth * .1, 0, screenWidth * .75, 0),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => SearchPage())));
              },
              label: Text("Explore", textAlign: TextAlign.left),
              backgroundColor: const Color.fromRGBO(145, 195, 255, 1),
              icon: const Icon(Icons.search),
            ),
          )),
      body: FutureBuilder(
        future: loading(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
              color: const Color.fromRGBO(145, 195, 255, 1),
              size: 100,
            )));
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: screenHeight*.2,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(145, 195, 255, 1),
                    borderRadius: BorderRadius.only(),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: const Text(
                          '"Where Words Fail, Music Speaks"',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Text(
                            '- Shaaban Abdelrahim',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Text(
                            'Swifty Top 25',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight * .35,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(145, 195, 255, 1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < arabicSongs.length; i++)
                            MusicDisplay(
                              songId: arabicSongs[i].id,
                              imagePath: arabicSongs[i]["image_path"],
                              title: arabicSongs[i]["title"],
                              subtitle: arabicSongs[i]["artist"],
                              songName: arabicSongs[i]["song_name"],
                              songIndex: i,
                              length: arabicSongs[i]["length"],
                              queue: arabicSongs,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                    child: Text(
                      'Discover',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildButton(0, 'Get Swifty!', false),
                            buildButton(1, 'Rock', false),
                            buildButton(2, 'Rap', false),
                            buildButton(3, 'Jazz', false)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.4,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    scrollDirection: Axis.vertical,
                    itemCount: randomSongs.length,
                    itemBuilder: (context, index) {
                      if (isButtonActive(0)) {
                        return SongComponent(
                          song_id: randomSongs[index].id,
                          imagePath: randomSongs[index]["image_path"],
                          title: randomSongs[index]["title"],
                          artist: randomSongs[index]["artist"],
                          length: randomSongs[index]["length"],
                          songName: randomSongs[index]["song_name"],
                          songIndex: index,
                          queue: randomSongs,
                        );
                      }
                      if (isButtonActive(1)) {
                        return SongComponent(
                          song_id: rockSongss[index].id,
                          imagePath: rockSongss[index]["image_path"],
                          title: rockSongss[index]["title"],
                          artist: rockSongss[index]["artist"],
                          length: rockSongss[index]["length"],
                          songName: rockSongss[index]["song_name"],
                          songIndex: index,
                          queue: rockSongss,
                        );
                      }
                      if (isButtonActive(2)) {
                        return SongComponent(
                          song_id: HipHops[index].id,
                          imagePath: HipHops[index]["image_path"],
                          title: HipHops[index]["title"],
                          artist: HipHops[index]["artist"],
                          length: HipHops[index]["length"],
                          songName: HipHops[index]["song_name"],
                          songIndex: index,
                          queue: HipHops,
                        );
                      }
                      if (isButtonActive(3)) {
                        return SongComponent(
                          song_id: Jazz[index].id,
                          imagePath: Jazz[index]["image_path"],
                          title: Jazz[index]["title"],
                          artist: Jazz[index]["artist"],
                          length: Jazz[index]["length"],
                          songName: Jazz[index]["song_name"],
                          songIndex: index,
                          queue: Jazz,
                        );
                      }
                      return null;
                    },
                  ),
                ),
                // const SizedBox(height: 8),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(35, 35, 35, 1),
        currentIndex: 1,
        onTap: onTabTapped,
        selectedItemColor: const Color.fromRGBO(145, 195, 255, 1),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_outlined),
            label: 'Library',
          ),
        ],
      ),
    );
  }

  Widget buildButton(int index, String label, bool isActive) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          activeButtonIndex = isActive ? 0 : index;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          activeButtonIndex == index
              ? const Color.fromRGBO(145, 195, 255, 1)
              : Colors.transparent,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: activeButtonIndex == index ? Colors.black : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  bool isButtonActive(int index) {
    return index == activeButtonIndex;
  }
}
