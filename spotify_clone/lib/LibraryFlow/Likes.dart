import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modernapplication_project/components/songcomponent.dart';

class Likes extends StatefulWidget {
  @override
  _LikesState createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      throw Exception("User not logged in");
    }
  }

  List<QueryDocumentSnapshot> allSongs = [];
  List<QueryDocumentSnapshot> likedSongs = [];
  TextEditingController searchController = TextEditingController();

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Songs').get();
    allSongs.addAll(querySnapshot.docs);
    for (int i = 0; i < allSongs.length; i++) {
      if (allSongs[i]["liked_by"].contains(getCurrentUserId())) {
        likedSongs.add(allSongs[i]);
      }
    }
    print(likedSongs);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
    searchController.addListener(() {
      setState(() {});
    });
  }

  List<DocumentSnapshot> getFilteredSongs() {
    String searchTerm = searchController.text.toLowerCase();
    return likedSongs
        .where((song) => song["title"].toLowerCase().contains(searchTerm))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          title: Row(
            children: [
              Icon(
                Icons.favorite,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'Likes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromARGB(255, 145, 195, 255),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search For Song',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 43, 43, 43),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height * .65,
              width: MediaQuery.of(context).size.width * .9,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: getFilteredSongs().length,
                itemBuilder: (context, index) => SongComponent(
                  song_id: getFilteredSongs()[index].id,
                  imagePath: getFilteredSongs()[index]["image_path"],
                  title: getFilteredSongs()[index]["title"],
                  artist: getFilteredSongs()[index]["artist"],
                  songName: getFilteredSongs()[index]["song_name"],
                  length: getFilteredSongs()[index]["length"],
                  songIndex: index,
                  queue: likedSongs,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
