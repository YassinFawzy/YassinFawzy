import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:modernapplication_project/components/playlistcard.dart';
import 'package:modernapplication_project/components/songcomponent.dart';
import 'package:modernapplication_project/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MusicPlayer extends StatefulWidget {
  final String title;
  final String artist;
  final String length;
  final String image;
  final String songName;
  final String? albumName;
  final String song_id;
  final int currentIndex;
  final List<QueryDocumentSnapshot> currentQueue;
  
  const MusicPlayer({
    super.key,
    required this.song_id,
    required this.title,
    required this.artist,
    required this.length,
    required this.image,
    required this.songName,
    this.albumName,
    required this.currentIndex,
    required this.currentQueue,
  });
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final player = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  late DocumentReference songRef;
  late List<dynamic> likedSongs = [];

  bool isPlaying = false;
  bool firstPlay = true;
  bool isLiked = false;

  List<QueryDocumentSnapshot> currentQueue = [];
  List<QueryDocumentSnapshot> queue = [];
  List<QueryDocumentSnapshot> playlists = [];
  Queue<QueryDocumentSnapshot> playingQueue = Queue<QueryDocumentSnapshot>();

  late Timer timer;

  getData() async {
    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('Playlists')
        .where(getCurrentUserId())
        .get();
    playlists.addAll(querySnapshot2.docs);
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

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;

    String formattedTime =
        '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  addToPlaylist() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
          height: MediaQuery.of(context).size.height * .9,
          width: MediaQuery.of(context).size.width * .9,
          color: Colors.black,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: playlists.length,
              itemBuilder: (BuildContext context, index) => PlaylistCard(
                    playlist_id: playlists[index].id,
                    imagePath: "assets/images/placeholder.jpg",
                    name: playlists[index]["playlist_name"],
                    subtext:
                        "${(playlists[index].data() as Map<String, dynamic>)["songs"].length} Songs",
                    action: "add",
                    song_id: widget.song_id,
                  ))),
    );
  }

  playNext() {
    var tempSong = playingQueue.first;
    playingQueue.removeFirst();
    playingQueue.addLast(tempSong);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MusicPlayer(
                  song_id: playingQueue.first.id,
                  title: playingQueue.first["title"],
                  artist: playingQueue.first["artist"],
                  length: playingQueue.first["length"],
                  image: playingQueue.first["image_path"],
                  songName: playingQueue.first["song_name"],
                  currentIndex: 0,
                  currentQueue: playingQueue.toList(),
                )));
  }

  playPrevious() {
    var tempSong = playingQueue.last;
    playingQueue.removeLast();
    playingQueue.addFirst(tempSong);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MusicPlayer(
                  song_id: playingQueue.first.id,
                  title: playingQueue.first["title"],
                  artist: playingQueue.first["artist"],
                  length: playingQueue.first["length"],
                  image: playingQueue.first["image_path"],
                  songName: playingQueue.first["song_name"],
                  currentIndex: 0,
                  currentQueue: playingQueue.toList(),
                )));
  }

  @override
  void initState() {
    super.initState();

    songRef =
        FirebaseFirestore.instance.collection('Songs').doc(widget.song_id);
    songRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          likedSongs = List.from(documentSnapshot["liked_by"]);
          isLiked = likedSongs.contains(getCurrentUserId());
        });
      } else {}
    });

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    currentQueue = widget.currentQueue;
    for (int i = 0; i < widget.currentIndex; i++) {
      var tempValue = currentQueue.first;
      currentQueue.removeAt(0);
      currentQueue.add(tempValue);
    }
    playingQueue = Queue<QueryDocumentSnapshot>.from(currentQueue);

    getData();

    new Timer.periodic(
        Duration(milliseconds: 500), (Timer t) => setState(() {}));

    player.onPlayerComplete.listen((event) {
      player.stop();
      playNext();
    });

    player.play(AssetSource(widget.songName));
    setState(() {
      isPlaying = true;
      firstPlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding:
            EdgeInsets.fromLTRB(0, screenHeight * 0.05, 0, screenHeight * 0.05),
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.image),
            fit: BoxFit.fitHeight,
            colorFilter:
                const ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.05, 0, screenWidth * 0.05, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        player.stop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                  Text(
                    widget.albumName ?? widget.artist,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  IconButton(
                    // backgroundColor: Colors.transparent,
                    onPressed: () async {
                      setState(() {
                        isLiked = !isLiked;
                      });
                      await songRef.update({
                        'liked_by': isLiked
                            ? FieldValue.arrayUnion([getCurrentUserId()])
                            : FieldValue.arrayRemove([getCurrentUserId()])
                      });
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: isPlaying ? 300 : 275,
              width: isPlaying ? 300 : 275,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                      image: AssetImage(widget.image), fit: BoxFit.cover)),
            ),
            Column(
              children: [
                Text(
                  widget.artist,
                  style: const TextStyle(color: Colors.white54, fontSize: 18),
                ),
                const SizedBox(
                  height: 7.5,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.075, 0, screenWidth * 0.075, 0),
              child: Column(
                children: [
                  SliderTheme(
                    data: const SliderThemeData(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        thumbShape: RoundSliderOverlayShape(overlayRadius: 0),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 5),
                    child: Slider.adaptive(
                      value: position.inSeconds.toDouble(),
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (double value) {
                        final position = Duration(seconds: value.toInt());
                        player.seek(position);
                        player.resume();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(position.inSeconds.toInt()),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        formatTime((duration - position).inSeconds.toInt()),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.15, 0, screenWidth * 0.15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.fast_rewind_sharp),
                    onPressed: () {
                      player.stop();
                      playPrevious();
                    },
                    color: Colors.white,
                    iconSize: 30,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 30,
                    child: IconButton(
                      icon: Icon(isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded),
                      onPressed: () {
                        if (isPlaying) {
                          player.pause();
                          isPlaying = !isPlaying;
                        } else {
                          player.resume();
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        }
                        setState(() {});
                      },
                      color: Colors.white,
                      iconSize: 40,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.fast_forward_sharp),
                    onPressed: () {
                      player.stop();
                      playNext();
                    },
                    color: Colors.white,
                    iconSize: 30,
                    style: const ButtonStyle(),
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 20,
                child: FloatingActionButton.extended(
                  backgroundColor: const Color.fromRGBO(44, 74, 111, 1),
                  onPressed: () {
                    addToPlaylist();
                    setState(() {});
                  },
                  icon: const Icon(Icons.library_music_sharp,
                      size: 12.5, color: Colors.white),
                  label: const Text(
                    "Add to Playlist",
                    style: TextStyle(
                        fontSize: 12.5,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 20,
                child: FloatingActionButton.extended(
                  backgroundColor: const Color.fromRGBO(44, 74, 111, 1),
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.black,
                        isScrollControlled: false,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        context: context,
                        builder: (BuildContext context) {
                          return ListView.builder(
                              padding: const EdgeInsets.all(15),
                              itemCount: currentQueue.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                var tempQueue = playingQueue.toList();
                                if (currentQueue[index].id == widget.song_id) {
                                  return GestureDetector(
                                    onTap: () {
                                      player.stop();
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: SongComponent(
                                        song_id: tempQueue[index].id,
                                        imagePath: tempQueue[index]
                                            ["image_path"],
                                        title: tempQueue[index]["title"],
                                        artist: tempQueue[index]["artist"],
                                        length: tempQueue[index]["length"],
                                        songName: tempQueue[index]["song_name"],
                                        selected: true,
                                        queue: tempQueue.toList(),
                                        songIndex: index),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    player.stop();
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: SongComponent(
                                    song_id: tempQueue[index].id,
                                    imagePath: tempQueue[index]["image_path"],
                                    title: tempQueue[index]["title"],
                                    artist: tempQueue[index]["artist"],
                                    length: tempQueue[index]["length"],
                                    songName: tempQueue[index]["song_name"],
                                    queue: tempQueue.toList(),
                                    songIndex: index,
                                  ),
                                );
                              });
                        });
                  },
                  icon: const Icon(Icons.library_music_sharp,
                      size: 12.5, color: Colors.white),
                  label: const Text(
                    "Queue",
                    style: TextStyle(
                        fontSize: 12.5,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
