import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modernapplication_project/components/playlistcard.dart';

class Playlists extends StatefulWidget {
  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  final TextEditingController new_playlist_name = TextEditingController();
  String errorMessage = "";
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('Playlists');

  List<QueryDocumentSnapshot> playlists = [];
  getData() async {
    QuerySnapshot allPlaylists = await FirebaseFirestore.instance
        .collection('Playlists')
        .where("belongsTo", isEqualTo: getCurrentUserId())
        .get();
    playlists.addAll(allPlaylists.docs);
    setState(() {});
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      throw Exception("User not logged in");
    }
  }

  addPlaylist() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) => Container(
              height: MediaQuery.of(context).size.height * .6,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    controller: new_playlist_name,
                    decoration: InputDecoration(
                      labelText: 'Playlist Name',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (new_playlist_name.text == "") {
                        errorMessage = "Playlist cant be an empty name";
                        setState(() {});
                      } else {
                        await collectionReference.add({
                          "playlist_name": new_playlist_name.text,
                          "songs": <String>[],
                          "belongsTo": getCurrentUserId()
                        });
                        print("Playlist Created successfully");
                        Navigator.pop(context);
                        setState(() {
                          new_playlist_name.text = "";
                          playlists.clear();
                          getData();
                        });
                      }
                    },
                    child: Text("Create Playlist"),
                  ),
                ],
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                'Playlists',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(73, 138, 109, 1),
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
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .055,
              child: FloatingActionButton.extended(
                  onPressed: () {
                    addPlaylist();
                  },
                  label: Text("Add Playlist"),
                  icon: Icon(Icons.add),
                  backgroundColor: const Color.fromRGBO(145, 195, 255, 1)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .7,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: playlists.length,
                itemBuilder: (BuildContext context, int index) {
                  return PlaylistCard(
                    playlist_id: playlists[index].id,
                    imagePath: "assets/images/placeholder.jpg",
                    name: playlists[index]["playlist_name"],
                    subtext:
                        "${(playlists[index].data() as Map<String, dynamic>)["songs"].length} Songs",
                    action: "delete",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
