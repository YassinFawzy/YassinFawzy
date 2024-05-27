import 'package:firebase_auth/firebase_auth.dart';                                                                 
import 'package:flutter/material.dart';
import 'Library.dart';
import 'explore.dart';
import 'components/musicdisplay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signin_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> randomSongs = [];
  List<QueryDocumentSnapshot> rockSongs = [];
  List<QueryDocumentSnapshot> popSongs = [];
  List<QueryDocumentSnapshot> rapSongs = [];

  String? getCurrentUsername() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.email?.split("@")[0];
    } else {
      throw Exception("User not logged in");
    }
  }

  getData() async {
    QuerySnapshot allsongs =
        await FirebaseFirestore.instance.collection('Songs').get();
    randomSongs.addAll(allsongs.docs);

    QuerySnapshot rocksongs = await FirebaseFirestore.instance
        .collection('Songs')
        .where("genre", isEqualTo: "Rock")
        .get();
    rockSongs.addAll(rocksongs.docs);

    QuerySnapshot popsongs = await FirebaseFirestore.instance
        .collection('Songs')
        .where("genre", isEqualTo: "Jazz")
        .get();
    popSongs.addAll(popsongs.docs);

    QuerySnapshot rapsongs = await FirebaseFirestore.instance
        .collection('Songs')
        .where("genre", isEqualTo: "Rap")
        .get();
    rapSongs.addAll(rapsongs.docs);
    setState(() {});
  }

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Explore()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Library()));
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  loading() async {
    await Future.delayed(Duration(seconds: 1, milliseconds: 250));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              "Welcome ${getCurrentUsername()}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: const Color.fromRGBO(145, 195, 255, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5),
                    bottom: Radius.circular(5),
                  ))),
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Text('Logout'),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: loading(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                  color: const Color.fromRGBO(145, 195, 255, 1),
                size: 100,
              )),
            );
          } else {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(7.5),
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    const Text(
                      "Songs For You!",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 175.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: randomSongs.length,
                        itemBuilder: (context, index) {
                          return MusicDisplay(
                            songId: randomSongs[index].id,
                            imagePath: randomSongs[index]["image_path"],
                            title: randomSongs[index]["title"],
                            subtitle: randomSongs[index]["artist"],
                            songName: randomSongs[index]["song_name"],
                            queue: randomSongs,
                            songIndex: index,
                            length: randomSongs[index]["length"],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Rock Songs For You!",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 175.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: rockSongs.length,
                        itemBuilder: (context, index) {
                          return MusicDisplay(
                            songId: rockSongs[index].id,
                            imagePath: rockSongs[index]["image_path"],
                            title: rockSongs[index]["title"],
                            subtitle: rockSongs[index]["artist"],
                            songName: rockSongs[index]["song_name"],
                            queue: rockSongs,
                            songIndex: index,
                            length: rockSongs[index]["length"],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      "Rap Songs For You!",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 175.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: rapSongs.length,
                        itemBuilder: (context, index) {
                          return MusicDisplay(
                            songId: rapSongs[index].id,
                            imagePath: rapSongs[index]["image_path"],
                            title: rapSongs[index]["title"],
                            subtitle: rapSongs[index]["artist"],
                            songName: rapSongs[index]["song_name"],
                            queue: rapSongs,
                            songIndex: index,
                            length: rapSongs[index]["length"],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      "Jazz Songs For You!",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 175.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: popSongs.length,
                        itemBuilder: (context, index) {
                          return MusicDisplay(
                            songId: popSongs[index].id,
                            imagePath: popSongs[index]["image_path"],
                            title: popSongs[index]["title"],
                            subtitle: popSongs[index]["artist"],
                            songName: popSongs[index]["song_name"],
                            queue: popSongs,
                            songIndex: index,
                            length: popSongs[index]["length"],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(0.0),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(145, 249, 255, 1),
                            shadowColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Your Live Feed',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(35, 35, 35, 1),
        currentIndex: 0,
        onTap: onTabTapped,
        selectedItemColor: const Color.fromRGBO(145, 249, 255, 1),
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
}
