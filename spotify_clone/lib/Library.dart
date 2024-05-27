import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modernapplication_project/explore.dart';
import 'package:modernapplication_project/homepage.dart';
import 'components/songcomponent.dart';
import './LibraryFlow/Likes.dart';
import './LibraryFlow/Playlists.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Explore()));
    }
  }

  List<QueryDocumentSnapshot> arabicSongss = [];
  getArabicData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Songs')
          .where("genre", isEqualTo: "Arabic")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        arabicSongss = querySnapshot.docs;
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
    getArabicData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Your Library',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
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
            return SingleChildScrollView(
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      'Your Songs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Likes()),
                            );
                          },
                          child: LibraryComponent(
                            icon: Icons.favorite,
                            title: 'Likes',
                            iconColor: Color.fromRGBO(145, 195, 255, 1),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Playlists()),
                            );
                          },
                          child: LibraryComponent(
                            icon: Icons.library_music,
                            title: 'Playlists',
                            iconColor: Color.fromRGBO(73, 138, 109, 1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Pinned',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(
                          Icons.push_pin,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PinnedItem(
                          imagePath: "assets/images/amrdiab.png",
                          title: 'Playlist: Depression Season',
                        ),
                        PinnedItem(
                          imagePath: "assets/images/amrdiab.png",
                          title: 'Likes',
                        ),
                        PinnedItem(
                          imagePath: "assets/images/amrdiab.png",
                          title: 'Playlist: Depression Season',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Recently Played',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .35,
                      child: ListView.builder(
                        padding: EdgeInsets.all(20),
                        scrollDirection: Axis.vertical,
                        itemCount: arabicSongss.length,
                        itemBuilder: (context, index) => SongComponent(
                          song_id: arabicSongss[index].id,
                          imagePath: arabicSongss[index]["image_path"],
                          title: arabicSongss[index]["title"],
                          artist: arabicSongss[index]["artist"],
                          songName: arabicSongss[index]["song_name"],
                          length: arabicSongss[index]["length"],
                          songIndex: index,
                          queue: arabicSongss,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(35, 35, 35, 1),
        currentIndex: 2,
        onTap: onTabTapped,
        selectedItemColor: Color.fromRGBO(145, 249, 255, 1),
        unselectedItemColor: Colors.white,
        items: [
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
}

class PinnedItem extends StatelessWidget {
  final String imagePath;
  final String title;

  PinnedItem({
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF1e1e1e),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.next_plan,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class LibraryComponent extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;

  LibraryComponent({
    required this.icon,
    required this.title,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF1e1e1e),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 35,
            color: iconColor,
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
