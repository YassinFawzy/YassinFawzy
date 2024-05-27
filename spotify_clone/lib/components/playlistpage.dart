import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modernapplication_project/components/songcomponent.dart';

class PlaylistSongs extends StatefulWidget {
  final String playlist_id;
  final String playlist_name;
  const PlaylistSongs(
      {super.key, required this.playlist_id, required this.playlist_name});

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  List<dynamic> songs = [];
  List<QueryDocumentSnapshot> playlistSongs = [];

  getData() async {
    DocumentReference playlistRef = FirebaseFirestore.instance
        .collection("Playlists")
        .doc(widget.playlist_id);
    DocumentSnapshot snapshot = await playlistRef.get();
    songs = snapshot["songs"] ?? [];

    QuerySnapshot allPlaylistSongs = await FirebaseFirestore.instance
        .collection('Songs')
        .where(FieldPath.documentId, whereIn: songs)
        .get();
    playlistSongs.addAll(allPlaylistSongs.docs);
    setState(() {});
    print("Data Getting Complete");
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.playlist_name),
              IconButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('Playlists')
                        .doc(widget.playlist_id)
                        .delete();
                    Navigator.pop(context);
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 160, 23, 13),
                  ))
            ],
          ),
          backgroundColor: const Color.fromRGBO(73, 138, 109, 1),
          elevation: 0,
          shape: const RoundedRectangleBorder(
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .7,
          width: MediaQuery.of(context).size.width * .9,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: playlistSongs.length,
              itemBuilder: (BuildContext context, index) => SongComponent(
                    song_id: playlistSongs[index].id,
                    imagePath: playlistSongs[index]["image_path"],
                    title: playlistSongs[index]["title"],
                    artist: playlistSongs[index]["artist"],
                    songName: playlistSongs[index]["song_name"],
                    length: playlistSongs[index]["length"],
                    songIndex: index,
                    queue: playlistSongs,

                  )),
        ),
      ),
    );
  }
}
