import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'musicplayer.dart';

class MusicDisplay extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String songName;
  final String? albumName;
  final String songId;
  final List<QueryDocumentSnapshot> queue;
  final int songIndex;
  final String length;

  MusicDisplay(
      {required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.songName,
      required this.songId,
      required this.songIndex,
      required this.length,
      this.albumName,
      required this.queue});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayer(
              song_id: songId,
              title: title,
              artist: subtitle,
              length: "204",
              image: imagePath,
              albumName: albumName,
              songName: songName,
              currentIndex: songIndex,
              currentQueue: queue,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: AssetImage(imagePath),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 7.5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.5),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 8.0,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
