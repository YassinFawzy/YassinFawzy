import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modernapplication_project/components/playlistpage.dart';

class PlaylistCard extends StatefulWidget {
  final String playlist_id;
  final String imagePath;
  final String name;
  final String subtext;
  final String action;
  final String? song_id;

  const PlaylistCard(
      {super.key,
      required this.playlist_id,
      required this.imagePath,
      required this.name,
      required this.subtext,
      required this.action,
      this.song_id});

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  List<dynamic> songs = [];

  getData() async {
    DocumentReference playlistRef = FirebaseFirestore.instance
        .collection("Playlists")
        .doc(widget.playlist_id);
    DocumentSnapshot snapshot = await playlistRef.get();
    songs = snapshot["songs"] ?? [];
  }

  bool checkSong(String? song_id) {
    return songs.contains(song_id);
  }

  IconData? chooseIcon() {
    return checkSong(widget.song_id)
        ? Icons.playlist_remove_rounded
        : Icons.playlist_add_rounded;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return widget.action == "delete"
        ? InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlaylistSongs(
                        playlist_name: widget.name,
                        playlist_id: widget.playlist_id)),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
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
                        widget.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.subtext,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFFABABAB),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('Playlists')
                            .doc(widget.playlist_id)
                            .delete();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () async {
              List<String?> currentSong = [widget.song_id];
              await FirebaseFirestore.instance
                  .collection("Playlists")
                  .doc(widget.playlist_id)
                  .update({
                'songs': checkSong(widget.song_id)
                    ? FieldValue.arrayRemove(currentSong)
                    : FieldValue.arrayUnion(currentSong)
              });
              checkSong(widget.song_id)
                  ? print("Song Removed successfully")
                  : print("Songs added successfully");
              setState(() {});
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black,
                ),
                child: Column(
                  children: [
                    Icon(
                      checkSong(widget.song_id)
                          ? Icons.playlist_remove_rounded
                          : Icons.playlist_add_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )),
          );
  }
}
