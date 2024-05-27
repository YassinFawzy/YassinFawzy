import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './components/songcomponent.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference songsCollection =
      FirebaseFirestore.instance.collection('Songs');
  List<DocumentSnapshot> searchResults = [];

  final List<QueryDocumentSnapshot> test = [];

  void searchSongs(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    QuerySnapshot snapshot = await songsCollection
        .where('title',
            isGreaterThanOrEqualTo:
                query.split(' ').map((word) => word.capitalize()).join(' '))
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      searchResults = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              onChanged: (query) {
                searchSongs(query);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1e1e1e),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return SongComponent(
                    song_id: searchResults[index].id,
                    imagePath: searchResults[index]['image_path'],
                    title: searchResults[index]['title'],
                    artist: searchResults[index]['artist'],
                    songName: searchResults[index]['song_name'],
                    length: searchResults[index]['length'],
                    songIndex: index,
                    queue: test,
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
