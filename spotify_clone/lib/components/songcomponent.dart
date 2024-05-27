import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './musicplayer.dart';

class SongComponent extends StatefulWidget {
  final String imagePath;
  final String title;
  final String artist;
  final String songName;
  final String? albumName;
  final String length;
  final String song_id;
  final bool? selected;
  final int songIndex;
  final List<QueryDocumentSnapshot> queue;

  SongComponent(
      {required this.song_id,
      required this.imagePath,
      required this.title,
      required this.artist,
      required this.songName,
      required this.length,
      required this.songIndex,
      this.albumName,
      this.selected,
      required this.queue});

  @override
  _SongComponentState createState() => _SongComponentState();
}

class _SongComponentState extends State<SongComponent> {
  bool isLiked = false;
  late DocumentReference songRef;
  late List<dynamic> likedSongs = [];

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      throw Exception("User not logged in");
    }
  }

  @override
  void initState() {
    super.initState();
    songRef =
        FirebaseFirestore.instance.collection('Songs').doc(widget.song_id);
    songRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // print('Document exists');
        setState(() {
          likedSongs = List.from(documentSnapshot["liked_by"]);
          isLiked = likedSongs.contains(getCurrentUserId());
        });
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error checking document existence: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayer(
              song_id: widget.song_id,
              title: widget.title,
              artist: widget.artist,
              length: widget.length,
              image: widget.imagePath,
              albumName: widget.albumName,
              songName: widget.songName,
              currentIndex: widget.songIndex,
              currentQueue: widget.queue,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: widget.selected == null ? Colors.black : Colors.white,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image(
                image: AssetImage(widget.imagePath),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color:
                        widget.selected == null ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  widget.artist,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget.selected == null
                        ? Color(0xFFABABAB)
                        : Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              widget.length,
              style: TextStyle(
                  color: widget.selected == null ? Colors.white : Colors.black),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLiked = !isLiked;
                });

                await songRef.update({
                  'liked_by': isLiked
                      ? FieldValue.arrayUnion([getCurrentUserId()])
                      : FieldValue.arrayRemove([getCurrentUserId()])
                });
              },
              child: Icon(
                isLiked ? Icons.favorite_outlined : Icons.favorite_outline,
                color: isLiked
                    ? Colors.red
                    : widget.selected == null
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
